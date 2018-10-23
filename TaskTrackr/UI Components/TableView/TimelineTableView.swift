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
        
        // register reusable cell identifier
        register(UINib(nibName: TimelineCell.ID, bundle: nil), forCellReuseIdentifier: TimelineCell.ID)
        
        delegate = self
    }
    
    public var dataForHeaderInSection: ((_ section: Int) -> (HeaderData))?

}

extension TimelineTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TimelineHeader.ID) as? TimelineHeader ?? TimelineHeader(reuseIdentifier: TimelineHeader.ID)
        // assign HeaderData to TimelineHeader.HeaderData to update the header view
        if let headerData = dataForHeaderInSection?(section) {
            header.setHeaderData(headerData: headerData)
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
