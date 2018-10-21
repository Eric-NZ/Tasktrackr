//
//  AllTasksTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 29/08/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift

class TaskSearchTableViewController: UITableViewController {
    var selectedTask : Task?
    let realm = DatabaseService.shared.getRealm()
    let tasks: Results<Task>
    var notificationToken: NotificationToken?
    
    required init?(coder aDecoder: NSCoder) {
        tasks = realm.objects(Task.self).sorted(byKeyPath: "timestamp", ascending: false)
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: TrackedTaskCell.ID, bundle: nil), forCellReuseIdentifier: TrackedTaskCell.ID)
        tableView.dataSource = self
        notificationToken = DatabaseService.shared.addNotificationHandle(objects: tasks, tableView: self.tableView)
    }
}

// MARK: - Table view data source & delegate
extension TaskSearchTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: TrackedTaskCell.ID) {
            cell.textLabel?.text = tasks[indexPath.row].taskTitle
            cell.detailTextLabel?.text = tasks[indexPath.row].taskDesc
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: TrackedTaskCell.ID)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // store selected Task
        selectedTask = tasks[indexPath.row]
        // create segue
        if let taskDetail = Static.getInstance(with: "TaskDetailViewController") as? TaskDetailViewController {
            let segue = UIStoryboardSegue(identifier: "OpenTaskDetail", source: self, destination: taskDetail) {
                taskDetail.task = self.selectedTask
                self.navigationController?.pushViewController(taskDetail, animated: true)
            }
            segue.perform()
        }
    }
}
