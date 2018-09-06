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
        // Do any additional setup after loading the view.
        
        loadSegmemtedPages()
        setLeftBarItem()
    }
    
    func loadSegmemtedPages() {

        viewControllers = [getInstance(with: Constants.ACTION_PAGE),
                           getInstance(with: Constants.WORKER_PAGE),
                           getInstance(with: Constants.PRODUCT_PAGE),
                           getInstance(with: Constants.TOOL_PAGE),
                           getInstance(with: Constants.SITE_PAGE)]
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
