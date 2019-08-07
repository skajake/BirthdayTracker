//
//  AddSchoolDateViewController.swift
//  BirthdayTracker
//
//  Created by Jakob Stuber on 7/13/19.
//  Copyright © 2019 Jakob Stuber. All rights reserved.
//

import Foundation
import FirebaseUI

class AddSchoolDateViewController: UIViewController {
    
    public var name: String?
    public var birthday: Date?
    
    @IBAction func skipTouched(_ sender: Any) {
        close()
    }
    
    @IBAction func saveTouched(_ sender: Any) {
        close()
    }
    
    private func close() {
        
        guard let user = Auth.auth().currentUser else {
            //TODO: Error
            return
        }
        
        Firestore.firestore().collection("users").document(user.uid).collection("dates").addDocument(data: ["name": name ?? "", "birthday": birthday ?? Date(timeIntervalSince1970: 0)])
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
