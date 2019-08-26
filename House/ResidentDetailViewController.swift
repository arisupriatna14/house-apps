//
//  ResidentDetailViewController.swift
//  House
//
//  Created by Ari Supriatna on 25/08/19.
//  Copyright © 2019 Ari Supriatna. All rights reserved.
//

import UIKit

class ResidentDetailViewController: UIViewController, HouseViewControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    var localResident: Resident!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        self.title = localResident.name
    }
    
    
    //MARK: IBActions
    @IBAction func btnAddAddress(_ sender: Any) {
        let houseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "houseVC") as! HouseViewController
        houseVC.didCameFromResidents = true
        houseVC.delegate = self
        
        navigationController?.pushViewController(houseVC, animated: true)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
    }
    
    
    //MARK: UpdateUI
    func updateUI() {
        nameTextField.text = localResident.name
        addressTextField.text = localResident.house?.address
    }
    
    //MARK: Protocol HouseViewControllerDelegate from HouseViewController
    func didAddHouse(house: House) {
        localResident.house = house
        updateUI()
        saveToCoreData()
    }
    
    //MARK: SaveToCoreData
    func saveToCoreData() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

}
