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
            self.handleLoginResult(loginStatus: $0)
        }
    }
    
    func handleLoginResult(loginStatus: Authentication.LoginStatus) {
        var mainTab: UITabBarController?
        
        switch loginStatus {
        case .logged_as_manager:
            mainTab = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Static.mainTabController) as? MainTabBarController)!
            mainTab?.addChild(ProfileController())
        case .logged_as_worker:
            mainTab = MainTabBarController()
            mainTab?.setViewControllers([TaskPerformController(), ProfileController()], animated: true)
        default:
            mainTab = nil
            // login error warning
            loginErrorWarning()
        }
        
        if let appDelegate = UIApplication.shared.delegate {
            if let window = appDelegate.window {
                if let tab = mainTab {
                    window?.rootViewController = tab
                    window?.makeKeyAndVisible()
                }
            }
        }
    }
}
