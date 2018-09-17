//
//  LoginViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 8/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import LFLoginController
import RealmSwift

class LoginViewController: UIViewController, LFLoginControllerDelegate {
    
    var loginViewController: LFLoginController? = nil

    
    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) {
        if type == .Login {     // user is logging in
            login(userName: email, password: password)
        } else {                // user is signing up
            let creds = SyncCredentials.usernamePassword(username: email, password: password, register: true)
            SyncUser.logIn(with: creds, server: Static.AUTH_URL) { (user, err) in
                // sign up successfully!
            }
            
        }
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
                // display a Toast
                Static.showToast(toastText: "Login successful!")
                // forward to home controller
                self.presentHomeController()
                
            } else if let _ = err {
                self.loginViewController?.wrongInfoShake()
//                fatalError(error.localizedDescription)
            }
        }
        
    }
    
    func presentHomeController() {
        performSegue(withIdentifier: "PresentHomeController", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Login Controller
        loginViewController = LFLoginController()
        guard loginViewController != nil else {return}
        self.addChild(loginViewController!)
        self.view.addSubview(loginViewController!.view)
        
        loginViewController!.delegate = self
        loginViewController?.backgroundColor = #colorLiteral(red: 0.3440366972, green: 0.5581039755, blue: 0.8980392157, alpha: 1)
    }

}
