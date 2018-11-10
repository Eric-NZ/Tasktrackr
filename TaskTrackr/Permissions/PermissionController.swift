//
//  LoginViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 8/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift

class PermissionController: LoginController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set login handler
        handleLoginRequest { (userName, password) in
            self.performLogin(userName: userName, password: password)
        }
    }
    
    func signUp(userName: String, password: String) {
        let creds = SyncCredentials.usernamePassword(username: userName, password: password, register: true)
        SyncUser.logIn(with: creds, server: Static.AUTH_URL) { (user, err) in
            // sign up successfully!
        }
    }
    
    func performLogin(userName: String, password: String) {
        // logout any other users
        DatabaseService.shared.logout()
        // log in current user
        login(userName: userName, password: password)
    }
    
    func forgotPasswordTapped(email: String) {
        // No! I've never forgot my password!
    }
    
    func login(userName: String, password: String) {
        
        let creds = SyncCredentials.usernamePassword(username: userName, password: password, register: false)
        
        SyncUser.logIn(with: creds, server: Static.AUTH_URL) { (user, err) in
            if let _ = user {
                // User is logged in
                Static.currentUser = user
                // forward to home controller
                self.presentHomeController()
                
            } else if let error = err {
//                fatalError(error.localizedDescription)
                print(error.localizedDescription)
                self.loginErrorWarning()
            }
        }
        
    }
    
    func presentHomeController() {
        performSegue(withIdentifier: "PresentHomeController", sender: self)
    }

}
