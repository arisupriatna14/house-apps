//
//  SearchViewController.swift
//  House
//
//  Created by Ari Supriatna on 25/08/19.
//  Copyright © 2019 Ari Supriatna. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchButtonOutlet: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var allResident: [Resident] = []
    var isSearching = false
    
    override func viewDidLoad() {
      super.viewDidLoad()
      searchTextField.returnKeyType = .search
      
      fetchFromCoreData()
    }
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allResident.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let resident = allResident[indexPath.row]
        
        cell.textLabel?.text = resident.name
        
        return cell
    }
    
    //MARK: IBActions
    @IBAction func searchButtonPressed(_ sender: Any) {
        isSearching = !isSearching
      
        if searchTextField.text != "" {
            // search core data
          if isSearching {
            searchButtonOutlet.setTitle("Cancel", for: .normal)
          } else {
            searchButtonOutlet.setTitle("Search", for: .normal)
          }
          let searchPredicate = NSPredicate(format: "name contains[c] %@", searchTextField.text!)
          
          fetchFromCoreData(predicate: searchPredicate)
        } else {
          searchButtonOutlet.setTitle("Cancel", for: .normal)
          fetchFromCoreData()
        }
    }
    
    //MARK: FetchFromCoreData
    func fetchFromCoreData(predicate: NSPredicate? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Resident")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchRequest.predicate = predicate
        
        let context = AppDelegate.context
        
        do {
            let result = try context.fetch(fetchRequest)
            allResident = result as! [Resident]
            tableView.reloadData()
        } catch {
            print("Error fetching residents: \(error.localizedDescription)")
        }
    }
}
