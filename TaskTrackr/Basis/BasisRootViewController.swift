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
        
        setLeftBarItem()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let viewController1 = getInstance(with: Constants.ACTION_PAGE)
        let viewController2 = getInstance(with: Constants.WORKER_PAGE)
        let viewController3 = getInstance(with: Constants.PRODUCT_PAGE)
        let viewController4 = getInstance(with: Constants.TOOL_PAGE)
        let viewController5 = getInstance(with: Constants.SITE_PAGE)
//        viewController5.title = "Sites"
        
        viewControllers = [viewController1,
                           viewController2,
                           viewController3,
                           viewController4,
                           viewController5,]
    }
    
    func setLeftBarItem() {
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    /* get instance of selected viewController index
     */
    func selectedViewController() -> UIViewController? {
        
        switch selectedPageIndex {
        case 0: // Action
            return getInstance(with: Constants.ACTION_PAGE)
        case 1: // Worker
            return getInstance(with: Constants.WORKER_PAGE)
        case 2: // Product
            return getInstance(with: Constants.PRODUCT_PAGE)
        case 3: // Tool
            return getInstance(with: Constants.TOOL_PAGE)
        case 4: // Site
            return getInstance(with: Constants.SITE_PAGE)
        default:
            return nil
        }
    }
    
    /* Get Instance of UIViewController
     */
    func getInstance(with indentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: indentifier)
    }
    
}
