//
//  ToolPickerViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 18/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol ToolPickerDelegate {
    func selectionDidFinish(selectedTools: [Tool])
}

class ToolPickerViewController: ExpandableSelectorController {

    var toolPickerDelegate: ToolPickerDelegate?
    var tools = DatabaseService.shared.getObjectArray(objectType: Tool.self) as! [Tool]
    // for collecting selected models
    var selectedTools: [Tool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // config right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneTapped))
        
        // set arrow image
        configureSectionArrow(arrowImage: UIImage(named: "down-arrow")!)
        // register cell
        tableView.register(CommonTableViewCell.self, forCellReuseIdentifier: CommonTableViewCell.ID)
        // set datasource
        expandableTableViewDataSource = self
        
        // init checkmark states
        let indices = DatabaseService.shared.mappingSegregatedIndices(wholeMatrix: [tools], elements: selectedTools)
        setupSelectionMatrixFromIndices(marked: indices)
    }
    
    @objc func onDoneTapped() {
        // get selection matrix
        let matrix = getSelectionMatrix()
        // calc selected tools
        calcSelectedTools(selectionMatrix: matrix)
        // call delegate method
        if toolPickerDelegate != nil {
            toolPickerDelegate?.selectionDidFinish(selectedTools: self.selectedTools)
        }
        // pop view controller
        navigationController?.popViewController(animated: true)
    }
    
    func calcSelectedTools(selectionMatrix: [[Bool]]) {
        var tools: [Tool] = []
        for i in 0..<selectionMatrix.count {
            for j in 0..<selectionMatrix[i].count {
                if selectionMatrix[i][j] {
                    tools.append(self.tools[j])
                }
            }
        }
        self.selectedTools = tools
    }

}

// MARK: - ExpandableTableViewDataSource
extension ToolPickerViewController: ExpandableTableViewDataSource {
    func expandableTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tools.count
    }
    
    func expandableTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonTableViewCell.ID)
        cell?.textLabel?.text = tools[indexPath.row].toolName
        cell?.detailTextLabel?.text = tools[indexPath.row].toolDesc
        
        return cell!
    }
    // UITableView Delegate
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Tools"
    }
}
