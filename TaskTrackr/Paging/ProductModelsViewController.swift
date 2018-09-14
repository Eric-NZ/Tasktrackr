//
//  ProductModelsViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 14/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import TagListView

class ProductModelsViewController: UIViewController {
    @IBOutlet weak var modelTagView: TagListView!
    
    let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
    
    override func viewDidLoad() {
        
        navigationItem.rightBarButtonItem = done
    }
    
    @objc func donePressed() {
        
    }
}
