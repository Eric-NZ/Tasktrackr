//
//  ProductsTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 6/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController, ManageItemDelegate {
    
    // MARK: - ManageItemDelegate
    func addItem() {
        print("Will add a product!")
    }
    
    func editingMode(editing: Bool, animate: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
