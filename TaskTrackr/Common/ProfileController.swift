//
//  ProfileController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 13/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // logout button
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func commonInit() {
        view.backgroundColor = UIColor.white
        title = "Me"
        
        tabBarItem.image = UIImage(named: "tab_profile")
    }

    @objc func buttonTapped(_ sender: UIButton) {
        Authentication.shared.logout {
            // back to PermisesionController
            let permissionController = Static.getInstance(with: Static.permissionController)
            if let window = UIApplication.shared.delegate?.window {
                window?.rootViewController = permissionController
                window?.makeKeyAndVisible()
            }
        }
    }
}
