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

    var tools: [Tool] = DatabaseService.shared.getObjectArray(objectType: Tool.self) as! [Tool]
    var products: [Product] = DatabaseService.shared.getObjectArray(objectType: Product.self) as! [Product]
    // NOTE: this is an array includes arrays that include models belong to each specific product.
    var modelArrays: [[Model]] = []
    
    enum selectedFrom {
        case fromTool
        case fromProduct
    }
    var eventFrom = selectedFrom.fromTool

    override func viewDidLoad() {
        super.viewDidLoad()

        // load all models for each product
        modelArrays = products.map({
            return DatabaseService.shared.getModelArray(in: $0)
        })
        
        delegate = self
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
            return cell
        case .fromProduct:
            let cell = tableView.dequeueReusableCell(withIdentifier: ModelTableViewCell.ID) ?? UITableViewCell(style: .default, reuseIdentifier: ModelTableViewCell.ID)
            cell.textLabel?.text = modelArrays[indexPath.section][indexPath.row].modelName
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventFrom == .fromProduct ? products[section].productName : "All Tools"
    }

}


