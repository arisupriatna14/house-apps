//
//  HouseViewController.swift
//  House
//
//  Created by Ari Supriatna on 25/08/19.
//  Copyright © 2019 Ari Supriatna. All rights reserved.
//

import UIKit
import CoreData

protocol HouseViewControllerDelegate {
    func didAddHouse(house: House)
}

class HouseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var nameTextField: UITextField!
    var addressTextField: UITextField!
    
    var didCameFromResidents = false
    var delegate: HouseViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFromCoreData()
        self.navigationItem.rightBarButtonItem?.isEnabled = !didCameFromResidents
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let house = fetchedResultsController.object(at: indexPath) as! House
        
        cell.textLabel?.text = house.name
        cell.detailTextLabel?.text = house.address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let objectToDelete = fetchedResultsController.object(at: indexPath) as! House
            
            AppDelegate.context.delete(objectToDelete)
            saveToCoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if didCameFromResidents {
            delegate?.didAddHouse(house: fetchedResultsController.object(at: indexPath) as! House)
            navigationController?.popViewController(animated: true)
        } else {
            performSegue(withIdentifier: "housesToHouseDetailSeg", sender: indexPath)
        }
        
    }
    
    //MARK: IBAction
    @IBAction func addBarButtonPressed(_ sender: Any) {
        showAddItemAlertController(title: "Add House")
    }
    
    //MARK: Show AddItem View
    func showAddItemAlertController(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (_nameTextField) in
            _nameTextField.placeholder = "Name"
            self.nameTextField = _nameTextField
        }
        
        alertController.addTextField { (_addressTextField) in
            _addressTextField.placeholder = "Address"
            self.addressTextField = _addressTextField
        }
        
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { (alert) in
            print("Add new house")
            self.saveHouse()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true)
    }
    
    //MARK: Save to Core Data
    func saveHouse() {
        if nameTextField.text != "" && addressTextField.text != "" {
            // save
            let context = AppDelegate.context
            
            let house = House(context: context)
            house.name = nameTextField.text
            house.address = addressTextField.text
            saveToCoreData()
            tableView.reloadData()
        } else {
            print("All fields are requires")
        }
    }
    
    //MARK: SaveToCoreData
    func saveToCoreData() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //MARK: FetchFromCoreData
    func fetchFromCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "House")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            print("Error saving house \(error.localizedDescription)")
        }
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            tableView.reloadData()
        default:
            print("Unknown type")
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "housesToHouseDetailSeg" {
            let indexPath = sender as! IndexPath
            let destinationVC = segue.destination as! HouseDetailViewController
            
            destinationVC.localHouse = (fetchedResultsController.object(at: indexPath) as! House)
        }
    }
}
