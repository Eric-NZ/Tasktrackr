//
//  SelectorViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 19/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import LUExpandableTableView

class SelectorViewController: UIViewController, LUExpandableTableViewDelegate, LUExpandableTableViewDataSource {

    @IBOutlet weak var tableView: LUExpandableTableView!
    
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

        tableView.register(SectionHeaderCell.self, forHeaderFooterViewReuseIdentifier: SectionHeaderCell.ID)
        tableView.register(UINib(nibName: "ToolTableViewCell", bundle: nil), forCellReuseIdentifier: ToolTableViewCell.ID)
        tableView.register(UINib(nibName: "ModelTableViewCell", bundle: nil), forCellReuseIdentifier: ModelTableViewCell.ID)
        
        tableView.expandableTableViewDelegate = self
        tableView.expandableTableViewDataSource = self
        // load all models for each product
        modelArrays = products.map({
            return DatabaseService.shared.getModelArray(in: $0)
        })
        
        tableView.expandSections(at: [0, 1])
    }
    
    // MARK: - LUExpandableTableViewDelegate & LUExpandableTableViewDataSource

    func expandableTableView(_ expandableTableView: LUExpandableTableView, sectionHeaderOfSection section: Int) -> LUExpandableTableViewSectionHeader {
        guard let sectionHeader = expandableTableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderCell.ID) as? SectionHeaderCell else {
            assertionFailure("Section header shouldn't be nil")
            return LUExpandableTableViewSectionHeader()
        }
        switch sType {
        case .fromTool:
            sectionHeader.textLabel?.text = "All Tools"
        case .fromProduct:
            sectionHeader.textLabel?.text = products[section].productName
        }
        
        return sectionHeader
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        switch sType {
        case .fromTool:     // for Tool
            let cell = expandableTableView.dequeueReusableCell(withIdentifier: ToolTableViewCell.ID)
            cell?.textLabel?.text = tools[indexPath.row].toolName
            cell?.detailTextLabel?.text = tools[indexPath.row].toolDesc
            return cell!
        case .fromProduct:     // for Product
            let cell = expandableTableView.dequeueReusableCell(withIdentifier: ModelTableViewCell.ID)
            let model = modelArrays[indexPath.section][indexPath.row]
            cell?.textLabel?.text = model.modelName
            return cell!
        }
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = expandableTableView.estimatedSectionHeaderHeight
        return height
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = expandableTableView.estimatedRowHeight
        return height
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        return sType == .fromProduct ? modelArrays[section].count : tools.count
    }
    
    func numberOfSections(in expandableTableView: LUExpandableTableView) -> Int {
        print("numberOfSections")
        return sType == .fromProduct ? products.count : 1
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectSectionHeader sectionHeader: LUExpandableTableViewSectionHeader, atSection section: Int) {
        print("didSelectSectionHeader")
    }
}
