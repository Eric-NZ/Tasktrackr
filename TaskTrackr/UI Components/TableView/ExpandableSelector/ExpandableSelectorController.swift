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
    var markStates: [[UITableViewCell.AccessoryType]] = []
    
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
    
    // init checkmark states from indices array
    public func setupSelectionMatrixFromIndices(marked indices: [[Int]]) {
        let numberOfSections = tableView.numberOfSections
        for section in 0..<numberOfSections {
            // markStates array has not yet current section, append an empty array
            if markStates.count == section {
                markStates.append([])
            }
            let numberOfRowsInSection = tableView.numberOfRows(inSection: section)
            for row in 0..<numberOfRowsInSection {
                // markStates[section] array has not yet current row, append current item
                if markStates[section].count == row {
                    markStates[section].append(.none)
                }
                markStates[section][row] = indices[section].contains(row) ? .checkmark : .none
            }
        }
    }
    
    // get selection matrix
    public func getSelectionMatrix() -> [[Bool]]{
        var matrix: [[Bool]] = []
        matrix = markStates.map({
            let bools: [Bool] = $0.map({
                return $0 == .checkmark ? true : false
            })
            return bools
        })
        
        return matrix
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

            // NOTE: initMarkStates must be invoked before this
            if markStates.count > 0 {
                cell.accessoryType = (markStates[indexPath.section][indexPath.row])
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
            if markStates.count > 0 {
                markStates[indexPath.section][indexPath.row] = cell.accessoryType
            }
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
