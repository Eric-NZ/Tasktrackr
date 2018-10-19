//
//  WorkerPickerViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 17/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol WorkerPickerDelegate {
    func selectionDidFinish(selectedWorkers: [Worker])
}
class WorkerPickerViewController: ExpandableSelectorController {
    var workerPickerDelegate: WorkerPickerDelegate?
    let workers: [Worker] = DatabaseService.shared.getObjectArray(objectType: Worker.self) as! [Worker]
    var selectedWorkers: [Worker] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup navigation right button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneTapped))

        // setup arrow image
        configureSectionArrow(arrowImage: UIImage(named: "down-arrow")!)
        
        // register tableview cell
        tableView.register(CommonTableViewCell.self, forCellReuseIdentifier: CommonTableViewCell.ID)
        
        // set datasource
        expandableTableViewDataSource = self
        
        // init checkmark states
        let indices = DatabaseService.shared.mappingSegregatedIndices(wholeMatrix: [workers], elements: selectedWorkers)
        setupSelectionMatrixFromIndices(marked: indices)
    }
    
    @objc func onDoneTapped() {
        // call delegate method
        if workerPickerDelegate != nil {
            // calc selected workers
            selectedWorkers = calcSelectedWorkers(selectionMatrix: getSelectionMatrix())
            workerPickerDelegate?.selectionDidFinish(selectedWorkers: selectedWorkers)
        }
        // pop view controller(self)
        navigationController?.popViewController(animated: true)
    }
    
    func calcSelectedWorkers(selectionMatrix: [[Bool]]) -> [Worker] {
        var workers: [Worker] = []
        let numberOfDepartment = selectionMatrix.count
        for d in 0..<numberOfDepartment {
            let numberOfWorkersInDepartment = selectionMatrix[d].count
            for w in 0..<numberOfWorkersInDepartment {
                if selectionMatrix[d][w] {
                    workers.append(self.workers[w])
                }
            }
        }
        return workers
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

