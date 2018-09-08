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
    
    // user status: has signed in?
    var loginViewController: LFLoginController? = nil
    
    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) {
    }
    
    func forgotPasswordTapped(email: String) {
        
    }
    
    func login(userName: String, password: String) -> Bool {
        
        guard SyncUser.current != nil else {return false}
        
        let creds = SyncCredentials.nickname(userName, isAdmin: true)
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL) { (user, err) in
            
        }
        
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Login Controller
        loginViewController = LFLoginController()
        guard loginViewController != nil else {return}
        self.addChild(loginViewController!)
        self.view.addSubview(loginViewController!.view)
        
        loginViewController!.delegate = self
    }

}
