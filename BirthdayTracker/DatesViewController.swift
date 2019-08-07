//
//  DatesViewController.swift
//  BirthdayTracker
//
//  Created by Jakob Stuber on 7/4/19.
//  Copyright © 2019 Jakob Stuber. All rights reserved.
//

import UIKit
import FirebaseUI

class DatesViewController: UIViewController, FUIAuthDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private var handler: AuthStateDidChangeListenerHandle?
    private var documentSnapshot: [DocumentSnapshot] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let authUI = FUIAuth.defaultAuthUI() else {
            return //TODO: Log Error!
        }
        
        authUI.delegate = self
        //TODO: Try this instead... Auth.auth().currentUser
        
        guard let user = Auth.auth().currentUser else {
            //TODO: Error
            return
        }
        
    Firestore.firestore().collection("users").document(user.uid).collection("dates").addSnapshotListener({ (snapshot, error) in
        if(error != nil) {
            //TODO: Log error
            return
        }
        guard let documents = snapshot?.documents else {
            //TODO: Log Error?
            return
        }
        self.documentSnapshot = documents
        self.tableView.reloadData()
        })
    }
        
//        handler = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
//            guard let unwrappedUser = user,
//                let strongSelf = self else {
//                //TODO: Log Major Error
//                return
//            }
//        Firestore.firestore().collection("users").document(unwrappedUser.uid).collection("dates").addSnapshotListener({ (snapshot, error) in
//                if(error != nil) {
//                    //TODO: Log error
//                    return
//                }
//                guard let documents = snapshot?.documents else {
//                    //TODO: Log Error?
//                    return
//                }
//                strongSelf.documentSnapshot = documents
//                strongSelf.tableView.reloadData()
//            })
//        }
//    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let handler = self.handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentSnapshot.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as? DateCell else {
            //TODO: Throw Error
            return UITableViewCell()
        }
        
        guard let data = documentSnapshot[indexPath.row].data() else {
            //TODO: Log Error
            return cell
        }
        
        cell.nameLabel.text = data["name"] as? String ?? ""
        
        if let birthday = data["birthday"] as? Timestamp,
            let diffInyears = Calendar.current.dateComponents([.year], from: birthday.dateValue(), to: Date()).year {
            
            if(diffInyears < 1) {
                if let diffInMonths = Calendar.current.dateComponents([.month], from: birthday.dateValue(), to: Date()).month {
                    cell.ageLabel.text = String(diffInMonths) + " Months"
                } else {
                    cell.ageLabel.text = "0"
                }
            } else {
                cell.ageLabel.text = String(diffInyears)
            }
        } else {
            cell.ageLabel.text = ""
        }
        
        return cell
    }
}

