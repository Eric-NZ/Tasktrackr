//
//  ActivatedTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 29/08/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift

typealias ButtonAttributeTuple = (target: Any?, image: UIImage?, callback: ()->Void?)

struct CellData {
    // illustrateImage
    var illustrateImage: UIImage?
    // illustrateTitle
    var illustrateTitle: String = ""
    // time text
    var timeText: String = ""
    // button attributes for cell
    var buttonAttributes: [ButtonAttributeTuple] = []
}

class TaskTrackingViewController: UIViewController {
    
    @IBOutlet weak var tableView: TimelineTableView!
    var taskNotification: NotificationToken?
    var notificationPool: [NotificationToken] = []
    var tasks: Results<Task>
    
    required init?(coder aDecoder: NSCoder) {
        tasks = DatabaseService.shared.getResultsOfTask()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNotification = DatabaseService.shared.addNotificationHandleForSections(objects: tasks, tableView: self.tableView, callback: nil)
        
        // init callbacks
        setupTableViewDataSource()
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
    func setupTableViewDataSource() {
        tableView.numberOfHeaders = {
            return self.tasks.count
        }
        
        tableView.dataForHeaderInSection = {(section) in
            return self.dataForHeaderInSection(in: section) ?? SectionData()
        }
        
        tableView.numberOfRowsInSection = {(section) in
            return self.tasks[section].stateLogs.count
        }
        
        tableView.cellDataForRowAtIndexPath = {(indexPath) in
            return self.cellDataForRowAtIndexPath(indexPath: indexPath) ?? CellData()
        }
    }
    
    private func dataForHeaderInSection(in section: Int) -> SectionData? {
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
    
    private func cellDataForRowAtIndexPath(indexPath: IndexPath) -> CellData? {
        let task = self.tasks[indexPath.section]
        let stateLog = task.stateLogs[indexPath.row]
        var cellData = CellData()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        // the buttons are only available where it is the last row
        let ifButtonNeeded: Bool = indexPath.row == task.stateLogs.count - 1
        
        switch stateLog.taskState {
        case .created:
            cellData.timeText = formatter.string(from: stateLog.timestamp)
            cellData.illustrateTitle = "Created"
            cellData.illustrateImage = UIImage(named: "created")
            
            cellData.buttonAttributes = ifButtonNeeded ? [ButtonAttributeTuple(self, UIImage(named: "next"), {()->Void in
                
            }),
                                                          ButtonAttributeTuple(self, UIImage(named: "edit"), {()->Void in
                                                            
                                                          }),
                                                          ButtonAttributeTuple(self, UIImage(named: "trash"), {()->Void in
                                                            
                                                          }),
                                                          ButtonAttributeTuple(self, UIImage(named: "info"), {()->Void in
                                                            
                                                          })] : []
        case .pending:
            cellData.timeText = formatter.string(from: stateLog.timestamp)
            cellData.illustrateTitle = "Pending"
            cellData.illustrateImage = UIImage(named: "pending")
            cellData.buttonAttributes = ifButtonNeeded ? [ButtonAttributeTuple(self, UIImage(named: "comment"), {()->Void in
                
            }),
                                                          ButtonAttributeTuple(self, UIImage(named: "info"), {()->Void in
                                                            
                                                          })] : []
        case .processing:
            cellData.timeText = formatter.string(from: stateLog.timestamp)
            cellData.illustrateTitle = "Processing"
            cellData.illustrateImage = UIImage(named: "processing")
            cellData.buttonAttributes = ifButtonNeeded ? [ButtonAttributeTuple(self, UIImage(named: "comment"), {()->Void in
                
            }),
                                                          ButtonAttributeTuple(self, UIImage(named: "info"), {()->Void in
                                                            
                                                          })] : []
        case .finished:
            cellData.timeText = formatter.string(from: stateLog.timestamp)
            cellData.illustrateTitle = "Finished"
            cellData.illustrateImage = UIImage(named: "finished")
            cellData.buttonAttributes = ifButtonNeeded ? [ButtonAttributeTuple(self, UIImage(named: "archive"), {()->Void in
                
            }),
                                                          ButtonAttributeTuple(self, UIImage(named: "info"), {()->Void in
                                                            
                                                          })] : []
        case .failed:
            cellData.timeText = formatter.string(from: stateLog.timestamp)
            cellData.illustrateTitle = "Failed"
            cellData.illustrateImage = UIImage(named: "failed")
            cellData.buttonAttributes = ifButtonNeeded ? [ButtonAttributeTuple(self, UIImage(named: "archive"), {()->Void in
                
            }),
                                                          ButtonAttributeTuple(self, UIImage(named: "trash"), {()->Void in
                                                            
                                                          }),
                                                          ButtonAttributeTuple(self, UIImage(named: "info"), {()->Void in
                                                            
                                                          })] : []
        }
        
        return cellData
    }
}
