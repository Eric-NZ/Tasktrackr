//
//  SelectorViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 19/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class SelectorViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var sectionHeaderView: SectionHeaderView?
    
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
        tableView.dataSource = self
        
        // load all models for each product
        modelArrays = products.map({
            return DatabaseService.shared.getModelArray(in: $0)
        })
        
        //
    }
}

extension SelectorViewController: UITableViewDelegate, UITableViewDataSource, SectionHeaderViewDelegate {
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sType == .fromProduct ? modelArrays[section].count : tools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sType == .fromTool ? 1 : products.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        sectionHeaderView = SectionHeaderView.instanceFromNib() as? SectionHeaderView
        sectionHeaderView?.backgroundColor = UIColor.groupTableViewBackground
        sectionHeaderView?.tag = section
        sectionHeaderView?.delegate = self

        return sectionHeaderView
    }
    
    // MARK: - SectionHeaderViewDelegate
    func didSectionHeaderTapped(on selectedTag: Int) {
        switch sType {
        case .fromProduct:
            print ("fromProduct: \(selectedTag)")
        case .fromTool:
            print ("fromProduct: \(selectedTag)")
        }
    }
}

