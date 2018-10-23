//
//  ActivatedTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 29/08/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift

class TaskTrackingViewController: UIViewController {
    @IBOutlet weak var tableView: TimelineTableView!
    var notificationToken: NotificationToken?
    let realm = DatabaseService.shared.getRealm()
    var tasks: Results<Task>
    
    required init?(coder aDecoder: NSCoder) {
        tasks = realm.objects(Task.self).sorted(byKeyPath: "timestamp", ascending: false)
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        notificationToken = DatabaseService.shared.addNotificationHandle(objects: tasks, tableView: self.tableView)
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

// MARK: - UITableViewDataSource
extension TaskTrackingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // only diplay the finished node of a whole process.
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.tableView.dataForHeaderInSection = {(section) in
            let task = self.tasks[section]
            var headerData = HeaderData()
            // title
            headerData.title = task.taskTitle
            // desc
            let descString = String(format: "created by %@, on %@", "Manager", formatter.string(from: task.timestamp))
            headerData.postDesc = descString
            // address
            headerData.address = task.address
            // due date
            let dueDateString = formatter.string(from: task.dueDate)
            headerData.dateString = String(format: "Due Date: %@", dueDateString)
            // workers
            var workerString = "Workers: "
            if task.workers.count == 0 {
                workerString.append(contentsOf: "No worker designated. ")
            } else {
                for worker in task.workers {
                    workerString.append(contentsOf: worker.firstName!)
                    workerString.append(contentsOf: "; ")
                }
            }
            // remove last "; "
            workerString.removeLast(2)
            headerData.workders = workerString
            // image
            if task.images.count > 0 {
                headerData.image = UIImage(data: task.images[0])!
            }

            return headerData
        }
        
        return "whatever"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // CELL: - each section(eash task) is bound to the cells (task states)
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineCell.ID, for: indexPath)
        let task = tasks[indexPath.section]
        switch task.taskState {
        case .pending:
            break
        case .processing:
            break
        case .finished:
            break
        case .failed:
            break
        default:                // default: created
            break
        }
        return cell
    }

}
