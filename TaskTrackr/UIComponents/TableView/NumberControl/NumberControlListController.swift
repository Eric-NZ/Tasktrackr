//
//  QuantityListController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 29/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

struct ItemData {
    var itemName: String = ""
    var numberOfItem: Int = 0

    init(_ itemName: String?, _ numberOfItem: Int? = 0) {
        self.itemName = itemName ?? ""
        self.numberOfItem = numberOfItem ?? 0
    }
    
    init(){}
}

typealias DataTuple = (category: String, items: [ItemData])

class NumberControlListController: UIViewController {
    var tableView: HoExpandableTableView!
    var dataTuples: [DataTuple] = []
    var dataTuplesGetReady: (([DataTuple])->Void)?
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dataTuplesGetReady?(dataTuples)
    }
    
    private func setupTableView() {
        tableView = HoExpandableTableView(style: .plain)
        self.view.addSubview(tableView)
        
        // register reusable cell identifier
        tableView?.register(UINib(nibName: "NumberControlCell", bundle: nil), forCellReuseIdentifier: NumberControlCell.ID)
        // auto layout
        autoLayout()
        // configure callbacks for data source
        configureDataSource()
    }
    
    private func configureDataSource() {
        tableView?.numberOfSectionsInTableView = {
            return self.dataTuples.count
        }
        
        tableView?.numberOfRowsInSection = {(section) in
            return self.dataTuples[section].items.count
        }
        
        tableView?.cellForRowAtIndexPath = {(indexPath) in
            let tuple = self.dataTuples[indexPath.section]
            let itemData = tuple.items[indexPath.row]
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "NumberControlCell", for: indexPath) as? NumberControlCell {
                cell.nameLabel.text = itemData.itemName
                cell.numberField.text = (Int(itemData.numberOfItem)).description
                cell.indexPath = indexPath
                // set callback handler - NOTE: this indexPath is not the equal to the above ones
                cell.numberInCellChanged = {(notifiedIndexPath, number) in
                    self.valueInCellChanged(indexPath: notifiedIndexPath, value: number)
                }
                return cell
            } else {
                return NumberControlCell(style: .default, reuseIdentifier: "NumberControlCell")
            }
        }
        
        tableView?.titleForHeaderInSection = {(section) in
            return self.dataTuples[section].category
        }
    }
    
    private func valueInCellChanged(indexPath: IndexPath, value: Int) {
        self.dataTuples[indexPath.section].items[indexPath.row].numberOfItem = value
    }
    
    private func autoLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0).isActive = true
    }
}
