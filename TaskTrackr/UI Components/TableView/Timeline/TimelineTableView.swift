//
//  TimelineTableView.swift
//  TaskTrackr
//
//  Created by Eric Ho on 23/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class TimelineTableView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // register a nib for the reusable cell identifier
        register(UINib(nibName: TimelineCell.ID, bundle: nil), forCellReuseIdentifier: TimelineCell.ID)
        
        dataSource = self
        delegate = self
    }
    
    // MARK: - callbacks for data source
    public var numberOfHeaders: (()-> Int)?
    public var dataForHeaderInSection: ((_ section: Int) -> SectionData)?
    public var numberOfRowsInSection: ((_ section: Int) -> Int)?
    public var cellDataForRowAtIndexPath: ((_ indexPath: IndexPath) -> RowData)?
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
            if let data = self.cellDataForRowAtIndexPath?(indexPath) {
                cell.illustrateImageView.image = data.illustrateImage
                cell.illustrateLabel.text = data.illustrateTitle
                cell.timeLabel.text = data.timeText
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
        // assign HeaderData to TimelineHeader.HeaderData to update the header view
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
