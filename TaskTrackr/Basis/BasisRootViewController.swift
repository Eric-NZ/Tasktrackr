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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController1 = storyboard.instantiateViewController(withIdentifier: "ActionViewController") as! ActionsTableViewController
//        viewController1.title = "Actions"
        let viewController2 = storyboard.instantiateViewController(withIdentifier: "WorkerViewController") as! WorkersTableViewController
//        viewController2.title = "Workers"
        let viewController3 = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductsTableViewController
//        viewController3.title = "Products"
        let viewController4 = storyboard.instantiateViewController(withIdentifier: "ToolViewController") as! ToolsTableViewController
//        viewController4.title = "Tools"
        let viewController5 = storyboard.instantiateViewController(withIdentifier: "SiteViewController") as! SitesTableViewController
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
    func selectedControllerIndex() -> Int {
        
        return selectedPageIndex
    }
    
    /*
     */
    
}
