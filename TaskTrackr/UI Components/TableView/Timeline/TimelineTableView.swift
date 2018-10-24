//
//  TimelineTableView.swift
//  TaskTrackr
//
//  Created by Eric Ho on 23/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class TimelineTableView: UITableView {
    var timelineHeaders: [TimelineHeaderData] = []
    var timelineCells: [[TimelineCellData]] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // register reusable cell identifier
        register(UINib(nibName: TimelineCell.ID, bundle: nil), forCellReuseIdentifier: TimelineCell.ID)
        
        dataSource = self
        delegate = self
    }
    
    // callback
    public var dataForHeaderInSection: ((_ section: Int) -> (TimelineHeaderData))?
    
    public func addTimeline(with timelineHeaderData: TimelineHeaderData?) {
        if let headerData = timelineHeaderData {
            self.timelineHeaders.append(headerData)
        }
    }
    
    public func removeTimeline(at index: Int) {
        self.timelineHeaders.remove(at: index)
    }
    
    public func removeAllTimeline() {
        self.timelineHeaders.removeAll()
    }

}

// MARK: - UITableViewDataSource
extension TimelineTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return timelineHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineHeader.ID, for: indexPath)
        //
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TimelineTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TimelineHeader.ID) as? TimelineHeader ?? TimelineHeader(reuseIdentifier: TimelineHeader.ID)
        // assign HeaderData to TimelineHeader.HeaderData to update the header view
        header.setHeaderData(headerData: timelineHeaders[section])
        
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
