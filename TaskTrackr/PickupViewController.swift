//
//  PickupViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 25/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import CollapsibleTableSectionViewController

class PickupViewController: CollapsibleTableSectionViewController {

    var products: [Product] = DatabaseService.shared.getObjectArray(objectType: Product.self) as! [Product]
    // NOTE: this is an array includes arrays that include models belong to each specific product.
    var modelArrays: [[Model]] = []
    var tools: [Tool] = DatabaseService.shared.getObjectArray(objectType: Tool.self) as! [Tool]
    var modelBoolArrays: [[Bool]] = []
    var toolBoolArray: [Bool] = []
    
    enum selectedFrom {
        case fromTool
        case fromProduct
    }
    var eventFrom = selectedFrom.fromTool

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize right bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(onSelectPressed))

        // load all models for each product
        modelArrays = products.map({
            return DatabaseService.shared.getModelArray(in: $0)
        })
        
        // build a Bool two-dimensional array which has the same item structure as modelArrays
        modelBoolArrays = modelArrays.map({ (models) -> [Bool] in
            let bools: [Bool] = models.map({ (model) -> Bool in
                return false
            })
            return bools
        })
        // build a Bool array which has the same item structure as toolArray, initialize all item to false
        toolBoolArray = tools.map({ (tool) -> Bool in
            return false
        })
        
        // set delegate
        delegate = self
    }
    
    @objc func onSelectPressed() {
        
    }
}

extension PickupViewController: CollapsibleTableSectionDelegate {

    // MARK: - CollapsibleTableSectionDelegate
    func numberOfSections(_ tableView: UITableView) -> Int {
        return eventFrom == .fromTool ? 1 : products.count
    }
    
    func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch eventFrom {
        case .fromProduct:
            return modelArrays[section].count
        case .fromTool:
            return tools.count
        }
    }
    
    func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch eventFrom {
        case .fromTool:
            let cell = tableView.dequeueReusableCell(withIdentifier: ToolTableViewCell.ID) ?? UITableViewCell(style: .default, reuseIdentifier: ToolTableViewCell.ID)
            cell.textLabel?.text = tools[indexPath.row].toolName
            // present checkmark state
            cell.accessoryType = toolBoolArray[indexPath.row] ? .checkmark : .none
            return cell
        case .fromProduct:
            let cell = tableView.dequeueReusableCell(withIdentifier: ModelTableViewCell.ID) ?? UITableViewCell(style: .default, reuseIdentifier: ModelTableViewCell.ID)
            cell.textLabel?.text = modelArrays[indexPath.section][indexPath.row].modelName
            // present checkmark state
            cell.accessoryType = modelBoolArrays[indexPath.section][indexPath.row] ? .checkmark : .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventFrom == .fromProduct ? products[section].productName : "All Tools"
    }
    
    func collapsibleTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        switch eventFrom {
        case .fromProduct:
            if cell?.accessoryType == .checkmark {      // previously selected
                modelBoolArrays[indexPath.section][indexPath.row] = false
                cell?.accessoryType = .none
            } else {                                    // previously deselected
                modelBoolArrays[indexPath.section][indexPath.row] = true
                cell?.accessoryType = .checkmark
            }
        case .fromTool:
            if cell?.accessoryType == .checkmark {      // previously selected
                toolBoolArray[indexPath.row] = false
                cell?.accessoryType = .none
            } else {                                    // previously deselected
                toolBoolArray[indexPath.row] = true
                cell?.accessoryType = .checkmark
            }
            break
        }
    }

}
