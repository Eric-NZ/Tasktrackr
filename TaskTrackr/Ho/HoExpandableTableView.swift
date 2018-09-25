//
//  HoExpandableTableView.swift
//  TaskTrackr
//
//  Created by Eric Ho on 24/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol HoExpandableDataSource {
    func tableView(_: HoExpandableTableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_: HoExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func numberOfSections(in tableView: HoExpandableTableView) -> Int
}

class HoExpandableTableView: UITableView {
    
    var hoExpandableDataSource: HoExpandableDataSource?
    var numberOfRowsInSection: Int = 0
    var sectionCount: Int = 0 {
        didSet {
            for _ in 0..<sectionCount {
                expandingStates.append(true)
            }
        }
    }
    var expandingStates : [Bool] = []
    
    override func awakeFromNib() {
        dataSource = self
    }
    
    public func sectionExpanded(in section: Int) -> Bool {
        return expandingStates[section]
    }
    
    // collapse section
    public func foldSection(for section: Int, at indices: Range<Int>, animate: RowAnimation) {
        
        // delete rows
        let indexPaths = indices.map {
            return IndexPath(row: $0, section: section)
        }
        // update expanding states
        setExpandingStatus(for: section, isExpanded: false)
        deleteRows(at: indexPaths, with: animate)
    }
    
    // expand section
    public func expandSection(for section: Int, at indices: Range<Int>, animate: RowAnimation) {
        let indexPaths = indices.map {
            return IndexPath(row: $0, section: section)
        }
        setExpandingStatus(for: section, isExpanded: true)
        insertRows(at: indexPaths, with: animate)
    }
    
    private func setExpandingStatus(for section: Int, isExpanded: Bool) {
        expandingStates[section] = isExpanded
    }
    
    
    
    
}

extension HoExpandableTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowCount = hoExpandableDataSource?.tableView(tableView as! HoExpandableTableView, numberOfRowsInSection: section) {
            numberOfRowsInSection = rowCount
        }
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hoExpandableDataSource?.tableView(tableView as! HoExpandableTableView, cellForRowAt: indexPath)
        
        return cell ?? UITableViewCell(frame: .zero)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sectionCount =  hoExpandableDataSource?.numberOfSections(in: tableView as! HoExpandableTableView) {
            self.sectionCount = sectionCount
        }
        return self.sectionCount
    }
}
