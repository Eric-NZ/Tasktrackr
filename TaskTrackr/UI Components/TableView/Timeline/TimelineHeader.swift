//
//  TimelineHeader.swift
//  TaskTrackr
//
//  Created by Eric Ho on 22/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

// HeadData with abstract elements instead of specific items.
struct SectionData {
    var title: String = ""
    var subTitle: String = ""
    var bulletFirst: String = ""
    var bulletSecond: String = ""
    var bulletThird: String = ""
    var image: UIImage = UIImage(named: "no-image")!
}

class TimelineHeader: UITableViewHeaderFooterView {
    static let ID = "TimelineHeader"
    var containerView: TimelineHeaderContainer!
    private var headerData: SectionData? {
        didSet {
            updateHeaderView()
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // setup container
        setupContainer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setHeaderData(headerData: SectionData?) {
        if let headerData = headerData {
            self.headerData = headerData
        }
    }
    
}

// MARK: - private functions
extension TimelineHeader {
    private func setupContainer() {
        if let view = Bundle.main.loadNibNamed("TimelineHeaderContainer", owner: self, options: nil)?[0] as? TimelineHeaderContainer {
            containerView = view
            addSubview(containerView)
            
            // set constraint
            containerView.translatesAutoresizingMaskIntoConstraints = false
            let left = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .right, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([left, bottom, right, top])
        }
    }
}

// MARK: - private functions
extension TimelineHeader {
    private func updateHeaderView() {
        if let headerData = self.headerData {
            containerView.titleLabel.text = headerData.title
            containerView.postDescLabel.text = headerData.subTitle
            containerView.workerLabel.text = headerData.bulletFirst
            containerView.addressLabel.text = headerData.bulletSecond
            containerView.dateLabel.text = headerData.bulletThird
            containerView.imageView.image = headerData.image
        }
    }
}
