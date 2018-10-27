//
//  ActivatedTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 29/08/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift

typealias AttribuiteTuple = (target: Any?, image: UIImage?, callback: ()->Void?)

struct RowData {
    // illustrateImage
    var illustrateImage: UIImage?
    // illustrateTitle
    var illustrateTitle: String = ""
    // time text
    var timeText: String = ""
    // button attributes for cell
    
    var buttonAttributes: [AttribuiteTuple] = []
}

class TaskTrackingViewController: UIViewController {
    
    @IBOutlet weak var tableView: TimelineTableView!
    var taskNotification: NotificationToken?
    var notificationPool: [NotificationToken] = []
    var tasks: Results<Task>
    // timeString, StateString, image
    let stateTimelineAtRow: [(String, UIImage)] = [("Created", UIImage(named: "created")!),
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
        
        tableView.cellDataForRowAtIndexPath = {(indexPath) in
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
        // Configure timeline
        let taskChanges = task.stateChanges
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        var rowData = RowData()
        rowData.illustrateImage = stateTimelineAtRow[indexPath.row].1
        rowData.illustrateTitle = stateTimelineAtRow[indexPath.row].0
        rowData.timeText = formatter.string(from: taskChanges[indexPath.row].changeTime)
        
        // determin button attributes by checking what state is on current row, as well as the current state of the task
        rowData.buttonAttributes.removeAll()
        var attributes = [AttribuiteTuple]()
        if indexPath.row == taskChanges.count - 1 {      // current row is the end of the section
            // configure the buttons
            attributes.append((self, UIImage(named: "next"), { () -> Void? in
                print("next")
            }))
            attributes.append((self, UIImage(named: "edit"), { () -> Void? in
                print("edit")
            }))
            attributes.append((self, UIImage(named: "trash"), { () -> Void? in
                print("trash")
            }))
            
            rowData.buttonAttributes = attributes
        }
        
        return rowData
    }
}
