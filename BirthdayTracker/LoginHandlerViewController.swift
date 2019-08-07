//
//  LoginHandlerViewController.swift
//  BirthdayTracker
//
//  Created by Jakob Stuber on 7/4/19.
//  Copyright © 2019 Jakob Stuber. All rights reserved.
//

import Foundation
import FirebaseUI

class LoginHandlerViewController: UIViewController, FUIAuthDelegate {
    
    private var handler: AuthStateDidChangeListenerHandle?
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let authUI = FUIAuth.defaultAuthUI() else {
            return //TODO: Log Error!
        }
        
        authUI.delegate = self
        
        handler = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: "postLoginSegue", sender: self)
            } else {
                let authViewController = authUI.authViewController()
                self?.present(authViewController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let handler = self.handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return AuthPickerViewControler(nibName: "AuthPickerView",
                                                 bundle: Bundle.main,
                                                 authUI: authUI)
    }
}
