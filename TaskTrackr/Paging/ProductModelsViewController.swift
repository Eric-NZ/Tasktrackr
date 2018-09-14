//
//  ProductModelsViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 14/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import SwiftyFORM

class ProductModelsViewController: UIViewController {
    override func viewDidLoad() {
//        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
    }
    
    @objc func addPressed() {
        print("add pressed!!")
    }
}
