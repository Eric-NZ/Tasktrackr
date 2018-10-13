//
//  PickupViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 25/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import CollapsibleTableSectionViewController

protocol ToolAndModelPickupDelegate {
    func finishSelection(selectedtools: [Tool], selectedModels: [ProductModel])
}

class ProductPickerViewController: CollapsibleTableSectionViewController {
    
    var pickupDelegate: ToolAndModelPickupDelegate?

    var products: [Product] = DatabaseService.shared.getObjectArray(objectType: Product.self) as! [Product]
    // NOTE: this is an array includes arrays that include models belong to each specific product.
    var allModelArrays: [[ProductModel]] = []
    // all tools
    var allTools: [Tool] = DatabaseService.shared.getObjectArray(objectType: Tool.self) as! [Tool]
    // this 2-dimension array has the same structure as array allModelArrays
    var modelBoolArrays: [[Bool]] = []
    // this array has the same structure as allTools
    var toolBoolArray: [Bool] = []
    // for collecting selected tools and models
    var selectedTools: [Tool] = []
    var selectedModels: [ProductModel] = []
    
    enum selectedFrom {
        case fromTool
        case fromProduct
    }
    var eventFrom = selectedFrom.fromTool

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize right bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onSelectPressed))

        // load all models for each product
        allModelArrays = products.map({
            return DatabaseService.shared.getModelArray(in: $0)
        })
        
        // initialize check states
        initSelectionStates()
        
        print(modelBoolArrays)
        
        // set delegate
        delegate = self
    }
    
    /** Initial selection states depend on the arrays: selectedModels & selectedTools.
        this function just converts the array structure.
     */
    func initSelectionStates() {
        // build a Bool two-dimensional array which has the same item structure as modelArrays
        modelBoolArrays = allModelArrays.map({
            let bools: [Bool] = $0.map({ (model) -> Bool in
                return selectedModels.contains(model) ? true : false
            })
            return bools
        })
        // build a Bool array which has the same item structure as toolArray, initialize all item to false
        toolBoolArray = allTools.map({ (tool) -> Bool in
            return selectedTools.contains(tool) ? true : false
        })
    }
    
    /** append selected models using both modelBoolArrays and allModalArrays(2-dimension array)
        append selected tools
    */
    func collectSelection() {
        // NOTE: make sure the arrays are empty before append
        selectedTools.removeAll()
        selectedModels.removeAll()
        
        for i in toolBoolArray.indices {
            if toolBoolArray[i] == true {
                selectedTools.append(allTools[i])
            }
        }
        
        for i in modelBoolArrays.indices {
            for j in modelBoolArrays[i].indices {
                if modelBoolArrays[i][j] == true {
                    selectedModels.append(allModelArrays[i][j])
                }
            }
        }
    }
    
    @objc func onSelectPressed() {
        // collect selected tools & models
        collectSelection()
        
        // perform delegate method
        if pickupDelegate != nil {
            pickupDelegate?.finishSelection(selectedtools: selectedTools, selectedModels: selectedModels)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension ProductPickerViewController: CollapsibleTableSectionDelegate {

    // MARK: - CollapsibleTableSectionDelegate
    func numberOfSections(_ tableView: UITableView) -> Int {
        return eventFrom == .fromTool ? 1 : products.count
    }
    
    func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch eventFrom {
        case .fromProduct:
            return allModelArrays[section].count
        case .fromTool:
            return allTools.count
        }
    }
    
    func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch eventFrom {
        case .fromTool:
            let cell = tableView.dequeueReusableCell(withIdentifier: ToolTableViewCell.ID) ?? UITableViewCell(style: .default, reuseIdentifier: ToolTableViewCell.ID)
            cell.textLabel?.text = allTools[indexPath.row].toolName
            // present checkmark state
            cell.accessoryType = toolBoolArray[indexPath.row] ? .checkmark : .none
            return cell
        case .fromProduct:
            let cell = tableView.dequeueReusableCell(withIdentifier: ModelTableViewCell.ID) ?? UITableViewCell(style: .default, reuseIdentifier: ModelTableViewCell.ID)
            cell.textLabel?.text = allModelArrays[indexPath.section][indexPath.row].modelName
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
