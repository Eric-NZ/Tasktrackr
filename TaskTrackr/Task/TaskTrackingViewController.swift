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
    var taskNotification: NotificationToken?
    var notificationPool: [NotificationToken] = []
    var tasks: Results<Task>
    // timeString, StateString, image
    let rowDataPool: [(String, UIImage)] = [("Created", UIImage(named: "created")!),
                                            ("Pending", UIImage(named: "pending")!),
                                            ("Processing", UIImage(named: "processing")!),
                                            ("Finished", UIImage(named: "finished")!),
                                            ("Failed", UIImage(named: "failed")!)]
    
    required init?(coder aDecoder: NSCoder) {
        tasks = DatabaseService.shared.getResultsOfTask()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNotification = DatabaseService.shared.addNotificationHandleForSections(objects: tasks, tableView: self.tableView, callback: nil)
        
        // init callbacks
        setupCallbackHandle()
    }
    
    deinit {
        taskNotification?.invalidate()
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

// MARK: - Implement callbacks
extension TaskTrackingViewController {
    func setupCallbackHandle() {
        tableView.numberOfHeaders = {
            return self.tasks.count
        }
        
        tableView.dataForHeaderInSection = {(section) in
            return self.wrapHeaderData(for: section) ?? SectionData()
        }
        
        tableView.numberOfRowsInSection = {(section) in
            return self.tasks[section].stateChanges.count
        }
        
        tableView.dataForRowAtIndexPath = {(indexPath) in
            return self.wrapRowDataForIndexPath(indexPath: indexPath) ?? RowData()
        }
    }
    
    private func wrapHeaderData(for section: Int) -> SectionData? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let task = self.tasks[section]
        var headerData = SectionData()
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
    
    private func wrapRowDataForIndexPath(indexPath: IndexPath) -> RowData? {
        let task = self.tasks[indexPath.section]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        // assign rowData values occording to the current task state
        var rowData = RowData()
        let taskChanges = task.stateChanges
        let taskState = taskChanges[indexPath.row].taskState
        
        rowData.illustrateImage = rowDataPool[indexPath.row].1
        rowData.illustrateTitle = rowDataPool[indexPath.row].0
        rowData.timeText = formatter.string(from: taskChanges[indexPath.row].changeTime)
        
        switch taskState {
        case .created:
            rowData.illustrateImage = rowDataPool[0].1
            rowData.illustrateTitle = rowDataPool[0].0
        case .pending:
            rowData.illustrateImage = rowDataPool[1].1
            rowData.illustrateTitle = rowDataPool[1].0
        case .processing:
            rowData.illustrateImage = rowDataPool[2].1
            rowData.illustrateTitle = rowDataPool[2].0
            break
        case .finished:
            rowData.illustrateImage = rowDataPool[3].1
            rowData.illustrateTitle = rowDataPool[3].0
            break
        case .failed:
            rowData.illustrateImage = rowDataPool[4].1
            rowData.illustrateTitle = rowDataPool[4].0
            break
        }
        rowData.timeText = formatter.string(from: taskChanges[indexPath.row].changeTime)
        
        return rowData
    }
}
