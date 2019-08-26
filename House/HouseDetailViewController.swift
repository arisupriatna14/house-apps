//
//  HouseDetailViewController.swift
//  House
//
//  Created by Ari Supriatna on 25/08/19.
//  Copyright © 2019 Ari Supriatna. All rights reserved.
//

import UIKit

class HouseDetailViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var residentsTextField: UITextField!
    
    var localHouse: House!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = localHouse.name
        updateUI()
    }
    

    //MARK: IBActions
    @IBAction func addResidentButtonPressed(_ sender: Any) {
    }
    
    //MARK: UpdateUI
    func updateUI() {
        nameTextField.text = localHouse.name
        addressTextField.text = localHouse.address
        
        var residentName = "This house has no resident"
        
        if let residents = localHouse.resident {
            if residents.count > 0 {
                residentName = ""
                
                for resident in residents.allObjects {
                    let localResident = resident as! Resident
                    residentName = residentName + "\(localResident.name!), "
                }
            }
            
            residentsTextField.text = residentName
        }
    }
}
