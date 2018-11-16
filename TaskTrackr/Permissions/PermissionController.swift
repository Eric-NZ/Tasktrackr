//
//  LoginViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 8/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class PermissionController: LoginController {
    
    override func viewDidLoad() {
        if let image = UIImage(named: "loginImage") {
            setLoginImage(image: image)
        }
        
        super.viewDidLoad()
        
        // set login handler
        handleLoginRequest { (username, password) in
            self.performLogin(userName: username, password: password)
        }
        // set signUp handler
        handleSignUpRequest { (username, password) in
            self.signUp(userName: username, password: password)
        }
    }
    
    func signUp(userName: String, password: String) {
        Authentication.shared.signUp(userName: userName, password: password) {
            // handle register completion
            
        }
    }
    
    func performLogin(userName: String, password: String) {
        // logout any other users
        Authentication.shared.logout(complection: nil)
        // log in current user
        logIn(userName: userName, password: password)
    }
    
    func logIn(userName: String, password: String) {
        Authentication.shared.logIn(userName: userName, password: password) {
            switch($0) {
            case .logged_as_manager:
                self.presentManagerEntry()
            case .logged_as_worker:
                self.presentWorkerEntry()
            case .logged_out:
                break
            }
        }
    }
    
    func presentManagerEntry() {
        performSegue(withIdentifier: "PresentManagerEntry", sender: self)
    }
    
    func presentWorkerEntry() {
        let mainTab = MainTabBarController()
        mainTab.setViewControllers([TaskPerformController(), ProfileController()], animated: true)
        
        if let appDelegate = UIApplication.shared.delegate {
            if let window = appDelegate.window {
                window?.makeKeyAndVisible()
                window?.rootViewController = mainTab
            }
        }
        
    }

}
