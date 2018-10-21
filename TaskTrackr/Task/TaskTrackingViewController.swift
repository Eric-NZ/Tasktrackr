//
//  ActivatedTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 29/08/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class TaskTrackingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let tasks: [Task] = DatabaseService.shared.getObjectArray(objectType: Task.self) as! [Task]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: TrackedTaskCell.ID, bundle: nil), forCellReuseIdentifier: TrackedTaskCell.ID)

        tableView.dataSource = self
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Static.segue_openTaskEditor, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editor = segue.destination as! TaskEditorViewController
        // if nil, means it should be a new task
        editor.currentTask = nil
    }

}

extension TaskTrackingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TrackedTaskCell.ID) {
            cell.textLabel?.text = tasks[indexPath.row].taskTitle
            cell.detailTextLabel?.text = tasks[indexPath.row].taskDesc
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: TrackedTaskCell.ID)
        }
    }

}
