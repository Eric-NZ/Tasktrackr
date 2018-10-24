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
    var tasks: Results<Task>
    
    required init?(coder aDecoder: NSCoder) {
        tasks = DatabaseService.shared.getResultsOfTask()
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimelineSections()
        notificationToken = DatabaseService.shared.addNotificationHandleForSections(objects: tasks,
                                                                                                tableView: self.tableView,
                                                                                                callback: taskDataChanged)
    }
    
    func taskDataChanged() {
        setupTimelineSections()
    }
    
    func setupTimelineSections() {
        // reload
        tableView.removeAllTimeline()
        let numberOfTasks = tasks.count
        for section in 0..<numberOfTasks {
            tableView.addTimeline(with: wrapHeaderData(for: section))
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Static.segue_openTaskEditor, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editor = segue.destination as! TaskEditorViewController
        // if nil, means it should be a new task
        editor.currentTask = nil
    }
    
    func wrapHeaderData(for section: Int) -> TimelineHeaderData? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let task = self.tasks[section]
        var headerData = TimelineHeaderData()
        // title
        headerData.title = task.taskTitle
        // desc
        let postInfo = String(format: "created by %@, on %@", "Manager", formatter.string(from: task.timestamp))
        headerData.subTitle = postInfo
        // address
        headerData.bulletSecond = task.address
        // due date
        let dueDateString = formatter.string(from: task.dueDate)
        headerData.bulletThird = String(format: "Deadline: %@", dueDateString)
        // workers
        var workerString = "Worker: "
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
        headerData.bulletFirst = workerString
        // image
        if task.images.count > 0 {
            headerData.image = UIImage(data: task.images[0])!
        }
        
        return headerData
    }
}
