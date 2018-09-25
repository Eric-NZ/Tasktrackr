//
//  SelectorViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 19/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class SelectorViewController: UIViewController{

    @IBOutlet weak var tableView: HoExpandableTableView!
    
    var sectionHeaderView: SectionHeaderCell?
    
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
        
        tableView.register(UINib(nibName: "ToolTableViewCell", bundle: nil), forCellReuseIdentifier: ToolTableViewCell.ID)
        tableView.register(UINib(nibName: "ModelTableViewCell", bundle: nil), forCellReuseIdentifier: ModelTableViewCell.ID)
        tableView.delegate = self
        tableView.hoExpandableDataSource = self
        
        // load all models for each product
        modelArrays = products.map({
            return DatabaseService.shared.getModelArray(in: $0)
        })
        
        //
    }
}

extension SelectorViewController: UITableViewDelegate, HoExpandableDataSource, SectionHeaderCellDelegate {

    // MARK: - HoExpandableDataSource
    
    func tableView(_ tableView: HoExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        switch sType {
        case .fromProduct:
            return tableView.isSectionExpanded(in: section) ? modelArrays[section].count : 0
        case .fromTool:
            return tableView.isSectionExpanded(in: section) ? tools.count : 0
        }
    }
    
    func tableView(_: HoExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sType {
        case .fromTool:
            let cell = tableView.dequeueReusableCell(withIdentifier: ToolTableViewCell.ID)
            cell?.textLabel?.text = tools[indexPath.row].toolName
            return cell!
        case .fromProduct:
            let cell = tableView.dequeueReusableCell(withIdentifier: ModelTableViewCell.ID)
            cell?.textLabel?.text = modelArrays[indexPath.section][indexPath.row].modelName
            return cell!
        }
    }
    
    func numberOfSections(in tableView: HoExpandableTableView) -> Int {
        return sType == .fromTool ? 1 : products.count
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        sectionHeaderView = SectionHeaderCell.instanceFromNib() as? SectionHeaderCell
        sectionHeaderView?.backgroundColor = UIColor.groupTableViewBackground
        sectionHeaderView?.tag = section
        sectionHeaderView?.delegate = self
        return sectionHeaderView
    }
    
    // MARK: - SectionHeaderCellDelegate
    func willExpandSection(on selectedTag: Int) {
        print("section \(selectedTag) will be expanded!")
        
    }
    
    func willFoldSection(on selectedTag: Int) {
        switch sType {
        case .fromProduct:
            let indecis = modelArrays[selectedTag].indices
            tableView.foldSection(for: selectedTag, at: indecis, animate: .fade)
        case .fromTool:
            let indecis = tools.indices
            tableView.foldSection(for: selectedTag, at: indecis, animate: .fade)
        }
        
    }
    
    func didSectionHeaderTapped(on selectedTag: Int) {
        
    }
}

