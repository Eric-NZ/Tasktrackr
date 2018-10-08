//
//  TaskCreatorViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 8/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import Former

class TaskEditorViewController: FormViewController {
    
    var currentTask: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(onDonePressed))
        
        // build editor form
        buildEditor()
    }
    
    @objc func onDonePressed() {
        // create a new task
        saveNewTask()
    }
    
    // build user input entry
    func buildEditor() {
        // necessary elements: 1.title, 2.desc, 3.service, 4.designated workers, 5.due date, 6.location, 7.ref images
        // Enter Title
        let nameField = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Task Title"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textField.textColor = .formerSubColor()
            $0.textField.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.placeholder = "e.g. "
                $0.text = ""
            }.onTextChanged { (text) in

        }
        // Enter Desc
        let descField = TextViewRowFormer<FormTextViewCell>() {
            $0.titleLabel.text = "Description"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFont(ofSize: 15)
            }.configure {
                $0.placeholder = "Add Task Introduction"
                $0.text = ""
            }.onTextChanged { (text) in
                // save Task desc
        }
        
        // Select Service
        
        // Pickup Designated Workers
        
        // Select Due Date
        
        // Search&Pickup Location
        
        // Upload Images
    }

    func saveNewTask() {
        if currentTask == nil {
            currentTask = Task()
            // set task properties...
            //
            //
            DatabaseService.shared.addNewTask(task: currentTask!)
        }
    }
}
