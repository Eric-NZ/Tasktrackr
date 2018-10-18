//
//  ToolPickerViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 18/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class ToolPickerViewController: ExpandableSelectorController {

    var tools = DatabaseService.shared.getObjectArray(objectType: Tool.self) as! [Tool]
    // for collecting selected models
    var selectedTools: [Tool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set arrow image
        configureSectionArrow(arrowImage: UIImage(named: "down-arrow")!)
        // register cell
        tableView.register(CommonTableViewCell.self, forCellReuseIdentifier: CommonTableViewCell.ID)
        // set datasource
        expandableTableViewDataSource = self
        
        // init checkmark states
        let indices = DatabaseService.shared.mappingSegregatedIndices(wholeMatrix: [tools], elements: selectedTools)
        initMarkStates(marked: indices)
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
