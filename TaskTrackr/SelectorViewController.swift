//
//  SelectorViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 19/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import ExpandableCell

class SelectorViewController: UIViewController, ExpandableDelegate {

    @IBOutlet var tableView: ExpandableTableView!
    
    var tools: [Tool] = DatabaseService.shared.getObjectArray(objectType: Tool.self) as! [Tool]
    var products: [Product] = DatabaseService.shared.getObjectArray(objectType: Product.self) as! [Product]
    // NOTE: this is an array includes arrays that include models belong to each specific product.
    var modelArrays: [[Model]] = []
    
    enum selectedFrom {
        case fromTool
        case fromProduct
    }
    var sType = selectedFrom.fromTool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.expandableDelegate = self
        tableView.animation = .automatic
        
        tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: NormalTableViewCell.ID)
        tableView.register(UINib(nibName: "ToolTableViewCell", bundle: nil), forCellReuseIdentifier: ToolTableViewCell.ID)
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: ProductTableViewCell.ID)
        tableView.register(UINib(nibName: "ModelTableViewCell", bundle: nil), forCellReuseIdentifier: ModelTableViewCell.ID)
        
        // load all models for each product
        modelArrays = products.map({
            return DatabaseService.shared.getModelArray(in: $0)
        })
        
        // BUG: if openAll() has not been invoked, the ExpandableDelegate
        // functions will not be working properly!
        tableView.openAll()
    }
    
    // MARK: - ExpandableDelegate
    
    // NOTE: This function will not be invoked until expandedCellsForRowAt is set up properly.
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        
        var heights: [CGFloat] = []
        
        switch sType {
        case .fromProduct:
            let modelArray = modelArrays[indexPath.row]
            heights = modelArray.map { (whatever) -> CGFloat in
                return 44
            }
        default:
            break
        }
        return heights
    }
    
    // NOTE: This function will not be invoked until openAll() is called.
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        
        switch sType {
        case .fromProduct:
            let modelArray = modelArrays[indexPath.row]
            let cells: [ModelTableViewCell] = modelArray.map {
                let cell: ModelTableViewCell = expandableTableView.dequeueReusableCell(withIdentifier: ModelTableViewCell.ID) as! ModelTableViewCell
                cell.textLabel?.text = $0.modelName
                return cell
            }
            return cells
        case .fromTool:
            return nil
        }
        
    }

    func numberOfSections(in expandableTableView: ExpandableTableView) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return sType == .fromProduct ? products.count : tools.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sType {
        case .fromTool:     // for Tool
            let cell = tableView.dequeueReusableCell(withIdentifier: ToolTableViewCell.ID)
            cell?.textLabel?.text = tools[indexPath.row].toolName
            cell?.detailTextLabel?.text = tools[indexPath.row].toolDesc
            return cell!
        case .fromProduct:     // for Product
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.ID)
            cell?.textLabel?.text = products[indexPath.row].productName
            cell?.detailTextLabel?.text = products[indexPath.row].productDesc
            return cell!
        }
    }
    
}
