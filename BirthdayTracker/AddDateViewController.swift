//
//  AddDateViewController.swift
//  BirthdayTracker
//
//  Created by Jakob Stuber on 7/7/19.
//  Copyright © 2019 Jakob Stuber. All rights reserved.
//

import UIKit

class AddDateViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func saveTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "schoolSegue", sender: sender)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addSchoolDateViewController = segue.destination as? AddSchoolDateViewController else {
            return
        }
        
        addSchoolDateViewController.name = nameField.text
    
        addSchoolDateViewController.birthday = datePicker.date
        
    }
    
}
