//
//  BasisRootViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 5/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import DTPagerController

class BasisRootViewController: DTPagerController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewController1: UIViewController?
        let viewController2: UIViewController?
        let viewController3: UIViewController?
        let viewController4: UIViewController?
        let viewController5: UIViewController?

        // Do any additional setup after loading the view.
        viewController1 = ActionsTableViewController()
        viewController1!.title = "Actions"
        viewController2 = WorkersTableViewController()
        viewController2!.title = "Workers"
        viewController3 = ProductsTableViewController()
        viewController3!.title = "Products"
        viewController4 = ToolsTableViewController()
        viewController4!.title = "Tools"
        viewController5 = SitesTableViewController()
        viewController5!.title = "Sites"
        
        viewControllers = [viewController1!, viewController2!, viewController3!, viewController4!, viewController5!]
    }
    
}
