//
//  WorkerPickerViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 17/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class WorkerPickerViewController: ExpandableSelectorController {

    let workers: [Worker] = DatabaseService.shared.getObjectArray(objectType: Worker.self) as! [Worker]
    var selectedWorkers: [Worker] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // set arrow image
        configureSectionArrow(arrowImage: UIImage(named: "down-arrow")!)
        
        // register tableview cell
        tableView.register(CommonTableViewCell.self, forCellReuseIdentifier: CommonTableViewCell.ID)
        
        // set datasource
        expandableTableViewDataSource = self
        
        // init checkmark states
        initMarkStates(marked: DatabaseService.shared.mappingSegregatedIndices(wholeMatrix: [workers], elements: selectedWorkers))
    }
    
}

// MARK: - ExpandableTableViewDataSource
extension WorkerPickerViewController: ExpandableTableViewDataSource {
    func expandableTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workers.count
    }
    
    func expandableTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommonTableViewCell.ID) {
            let worker = workers[indexPath.row]
            let fullName = String(format: "%@ %@", worker.firstName!, worker.lastName!)
            cell.textLabel?.text = fullName
            cell.detailTextLabel?.text = worker.role
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: CommonTableViewCell.ID)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Workers"
    }
}
