//
//  ActivatedTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 29/08/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class TaskTrackingViewController: UIViewController {
    
    let activatedTaskArray: [String] = ["task1", "task3", "task4", "task6",]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Static.task_editor, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as! TaskEditorViewController
        
    }

}
