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
    
    @IBOutlet weak var numberOfModelsLabel: UILabel!
    
    var models: [Model] = [] {
        didSet {
            print(models)
        }
    }
    
    @IBOutlet weak var modelTagView: TagListView!
    
    let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
    
    override func viewDidLoad() {
        // set right bar item
        navigationItem.rightBarButtonItem = done

    }
    
    @objc func donePressed() {
        
    }
    
    @IBAction func addModelPressed(_ sender: UIButton) {
    }
    
    @IBAction func removeModelPressed(_ sender: UIButton) {
    }
}
