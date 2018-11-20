//
//  TaskPerformController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 13/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift

class TaskPerformController: UIViewController {
    var tableView: TimelineTableView!
    var taskNotification: NotificationToken?
    var myTasks: Results<Task>
    
    init() {
        myTasks = DatabaseService.shared.getResultsOfTask()
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        myTasks = DatabaseService.shared.getResultsOfTask()
        super.init(coder: aDecoder)
    }
    
    deinit {
        taskNotification?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNotification = DatabaseService.shared.addNotificationHandleForSections(objects: myTasks, tableView: self.tableView, callback: {
            print("I have accessed the realm!!")
        })
        // setup layout
        setupLayout()
        
        // setup data source
        setupDataSource()
    }

    private func commonInit() {
        tableView = TimelineTableView()
        
        view.backgroundColor = UIColor.white
        title = "Perform"
        tabBarItem.image = UIImage(named: "tab_to-do-list")
    }
    
    func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    func setupDataSource() {
        tableView.numberOfSections {
            return self.myTasks.count
        }
        
        tableView.dataForHeader {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            
            let task = self.myTasks[$0]
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
        
        tableView.numberOfRowsInSection {
            return self.myTasks[$0].stateLogs.count
        }
        
        tableView.dataForRowAtIndexPath {
            let task = self.myTasks[$0.section]
            let stateLog = task.stateLogs[$0.row]
            var cellData = CellData()
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            
            // the buttons are only available where it is the last row
            let ifButtonNeeded: Bool = $0.row == task.stateLogs.count - 1
            
            switch stateLog.taskState {
            case .created:
                cellData.timeText = formatter.string(from: stateLog.timestamp)
                cellData.illustrateTitle = "Created"
                cellData.illustrateImage = UIImage(named: "created")
                cellData.isFirstCell = true
                cellData.buttonAttributes = ifButtonNeeded ? [CellData.ButtonAttributeTuple(0, self, UIImage(named: "next"), {()->Void in
                    // callback closure
                    
                }), CellData.ButtonAttributeTuple(1, self, UIImage(named: "edit"), { [weak self] in
                    // callback closure
                    
                    
                }), CellData.ButtonAttributeTuple(2, self, UIImage(named: "trash"), {()->Void in
                    // callback closure
                    
                }), CellData.ButtonAttributeTuple(3, self, UIImage(named: "info"), {()->Void in
                    // callback closure
                    
                })] : []
            case .pending:
                cellData.timeText = formatter.string(from: stateLog.timestamp)
                cellData.illustrateTitle = "Pending"
                cellData.illustrateImage = UIImage(named: "pending")
                cellData.buttonAttributes = ifButtonNeeded ? [CellData.ButtonAttributeTuple(0, self, UIImage(named: "comment"), {()->Void in
                    // callback closure
                    
                }), CellData.ButtonAttributeTuple(1, self, UIImage(named: "info"), {()->Void in
                    // callback closure
                    
                }), CellData.ButtonAttributeTuple(2, self, UIImage(named: "cancel"), {()->Void in
                    // callback closure: back to previous state with offset - 1
                    
                })] : []
            case .processing:
                cellData.timeText = formatter.string(from: stateLog.timestamp)
                cellData.illustrateTitle = "Processing"
                cellData.illustrateImage = UIImage(named: "processing")
                cellData.buttonAttributes = ifButtonNeeded ? [CellData.ButtonAttributeTuple(0, self, UIImage(named: "comment"), {()->Void in
                    // callback closure
                    
                }), CellData.ButtonAttributeTuple(1, self, UIImage(named: "info"), {()->Void in
                    // callback closure
                    
                })] : []
            case .finished:
                cellData.timeText = formatter.string(from: stateLog.timestamp)
                cellData.illustrateTitle = "Finished"
                cellData.illustrateImage = UIImage(named: "finished")
                cellData.isFinalCell = true
                cellData.buttonAttributes = ifButtonNeeded ? [CellData.ButtonAttributeTuple(0, self, UIImage(named: "check"), {()->Void in
                    // callback closure
                    
                }), CellData.ButtonAttributeTuple(1, self, UIImage(named: "backward"), {()->Void in
                    // callback closure
                    
                }), CellData.ButtonAttributeTuple(2, self, UIImage(named: "info"), {()->Void in
                    // callback closure
                    
                })] : []
            case .failed:
                cellData.timeText = formatter.string(from: stateLog.timestamp)
                cellData.illustrateTitle = "Failed"
                cellData.illustrateImage = UIImage(named: "failed")
                cellData.isFinalCell = true
                cellData.buttonAttributes = ifButtonNeeded ? [CellData.ButtonAttributeTuple(0, self, UIImage(named: "archive"), {()->Void in
                    // callback closure
                    
                }), CellData.ButtonAttributeTuple(1, self, UIImage(named: "trash"), {()->Void in
                    // callback closure
                    
                }), CellData.ButtonAttributeTuple(2, self, UIImage(named: "info"), {()->Void in
                    // callback closure
                    
                })] : []
            }
            
            return cellData
        }
    }
}
