//
//  MultiSelectionViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 17/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

@objc public protocol ExpandableTableViewDataSource {
    
    @objc optional func numberOfSections(_ tableView: UITableView) -> Int
    func expandableTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func expandableTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

class ExpandableSelectorController: UIViewController {
    var tableView: UITableView!
    var sectionArrowImage: UIImage?
    var expandableTableViewDataSource: ExpandableTableViewDataSource?
    // array cells to store state for each one
    var markStates: [[UITableViewCell.AccessoryType?]?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init tableView
        tableView = UITableView()
        
        // register default cell and header.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(ExpandableTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "DefaultHeader")

        // Auto layout tableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        
        // assign delegate / datasource
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public func configureSectionArrow(arrowImage: UIImage) {
        self.sectionArrowImage = arrowImage
    }
}

// MARK: - UITableViewDataSource
extension ExpandableSelectorController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = expandableTableViewDataSource?.expandableTableView(tableView, numberOfRowsInSection: section) ?? 0
        
        if let header = tableView.headerView(forSection: section) as? ExpandableTableViewHeader {
            numberOfRows = header.isExpanded ? numberOfRows : 0
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = expandableTableViewDataSource?.expandableTableView(tableView, cellForRowAt: indexPath) {
            // if not stored yet, store cell to array
            // - append section
            if markStates.count <= indexPath.section {
                markStates.append([])
            }
            // - append row
            if (markStates[indexPath.section]?.count)! <= indexPath.row {
                markStates[indexPath.section]?.append(.none)
            }
            
            // after above appending, the 2d array can be used as normal
            if let markState = markStates[indexPath.section]?[indexPath.row] {
                cell.accessoryType = markState
            }
            
            return cell
            
        } else {
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DefaultCell")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expandableTableViewDataSource?.numberOfSections?(tableView) ?? 1
    }
}

// MARK: - UITableViewDelegate
extension ExpandableSelectorController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DefaultHeader") as? ExpandableTableViewHeader ?? ExpandableTableViewHeader(reuseIdentifier: "DefaultHeader")
        // section index
        header.index = section
        // arrow image
        if let image = self.sectionArrowImage {
            header.arrowView.image = image
        }
        // set delegate
        header.headerDelegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let isMarked = cell.accessoryType == .checkmark
            cell.accessoryType = isMarked ? .none : .checkmark
            
            // store cell check state
            markStates[indexPath.section]?[indexPath.row] = cell.accessoryType
        }
    }
}

// MARK: - ExpandableTableViewHeaderDelegate
extension ExpandableSelectorController: ExpandableTableViewHeaderDelegate {
    
    func didExpandingStateChanged(on section: Int, now isExpanded: Bool) {
        // reload changed section to invoke numberOfRows method
        var sectionSet = IndexSet([])
        sectionSet.insert(section)
        tableView.reloadSections(sectionSet, with: .automatic)
        // NOTE: after section reloaded, the header.isExpanded is reset to true.
        if let head = tableView.headerView(forSection: section) as? ExpandableTableViewHeader {
            head.isExpanded = isExpanded
            head.updateArrowState()
        }
    }
}
