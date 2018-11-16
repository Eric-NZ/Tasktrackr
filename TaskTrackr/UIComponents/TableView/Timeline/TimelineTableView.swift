//
//  TimelineTableView.swift
//  TaskTrackr
//
//  Created by Eric Ho on 23/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class TimelineTableView: UITableView {
    private override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        // register a nib for the reusable cell identifier
        register(UINib(nibName: TimelineCell.ID, bundle: nil), forCellReuseIdentifier: TimelineCell.ID)
        
        dataSource = self
        delegate = self
    }
    
    // MARK: - callbacks for data source
    private var numberOfHeaders: (()-> Int)?
    private var dataForHeaderInSection: ((_ section: Int) -> SectionData)?
    private var numberOfRowsInSection: ((_ section: Int) -> Int)?
    private var cellDataForRowAtIndexPath: ((_ indexPath: IndexPath) -> CellData)?
    
    public func numberOfSections(numberOfHeaders: @escaping (()-> Int)) {
        self.numberOfHeaders = numberOfHeaders
    }
    
    public func dataForHeader(dataForHeader: @escaping ((_ section: Int) -> SectionData)) {
        self.dataForHeaderInSection = dataForHeader
    }
    
    public func numberOfRowsInSection(numberOfRows: @escaping ((_ section: Int) -> Int)) {
        self.numberOfRowsInSection = numberOfRows
    }
    
    public func dataForRowAtIndexPath(data: @escaping ((_ indexPath: IndexPath) -> CellData)) {
        self.cellDataForRowAtIndexPath = data
    }
}

// MARK: - UITableViewDataSource
extension TimelineTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfHeaders?() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInSection?(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TimelineCell.ID, for: indexPath) as? TimelineCell {
            // set cell data
            if let data = self.cellDataForRowAtIndexPath?(indexPath) {
                cell.setCellData(cellData: data)
            }
            return cell
        } else {
            return TimelineCell(style: .default, reuseIdentifier: TimelineCell.ID)
        }
    }
}
// MARK: - UITableViewDelegate
extension TimelineTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TimelineHeader.ID) as? TimelineHeader ?? TimelineHeader(reuseIdentifier: TimelineHeader.ID)
        // set header data
        if let data = dataForHeaderInSection?(section) {
            header.setHeaderData(headerData: data)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 130
        if let header = tableView.headerView(forSection: section) as? TimelineHeader {
            height = header.containerView.frame.height
        }
        return height
    }
}
