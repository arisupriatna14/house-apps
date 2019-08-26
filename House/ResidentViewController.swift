//
//  ResidentViewController.swift
//  House
//
//  Created by Ari Supriatna on 25/08/19.
//  Copyright © 2019 Ari Supriatna. All rights reserved.
//

import UIKit
import CoreData

class ResidentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFromCoreData()
        tableView.tableFooterView = UIView()
    }
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let resident = fetchedResultsController.object(at: indexPath) as! Resident
        
        cell.textLabel?.text = resident.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let objectToDelete = fetchedResultsController.object(at: indexPath) as! Resident
            
            AppDelegate.context.delete(objectToDelete)
            saveToCoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "residentsToResidentDetailSeg", sender: indexPath)
    }
    
    //MARK: IBActions
    @IBAction func addBarButtonPressed(_ sender: Any) {
        print("Add resident")
        showAddItemAlertController(title: "Add Resident")
    }
    
    //MARK: Show AddItem Alert
    func showAddItemAlertController(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (_nameTextField) in
            _nameTextField.placeholder = "Name resident"
            self.nameTextField = _nameTextField
        }
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alert) in
            print("Save Resident")
            self.saveResident()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: FetchFromDataCore
    func fetchFromCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Resident")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching resident: \(error.localizedDescription)")
        }
    }
    
    //MARK: Save Resident to Core Data
    func saveResident() {
        if nameTextField.text != "" {
            let context = AppDelegate.context
            let resident = Resident(context: context)
            
            resident.name = nameTextField.text
            saveToCoreData()
            tableView.reloadData()
        }
    }
    
    //MARK: SaveToCoreData
    func saveToCoreData() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
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
        if segue.identifier == "residentsToResidentDetailSeg" {
            let indexPath = sender as! IndexPath
            let destinationVC = segue.destination as! ResidentDetailViewController

            destinationVC.localResident = (fetchedResultsController.object(at: indexPath) as! Resident)
        }
    }
}
