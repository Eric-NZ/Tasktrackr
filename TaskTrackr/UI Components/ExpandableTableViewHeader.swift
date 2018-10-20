//
//  ExpandableTableViewHeader.swift
//  TaskTrackr
//
//  Created by Eric Ho on 17/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol ExpandableTableViewHeaderDelegate {
    func didExpandingStateChanged(on section: Int, now isExpanded: Bool)
}

class ExpandableTableViewHeader: UITableViewHeaderFooterView {
    
    // section index
    var index: Int = 0
    // arrow image view
    let arrowView = UIImageView()
    // is expanded: true by default
    var isExpanded: Bool = true
    // header delegate
    var headerDelegate: ExpandableTableViewHeaderDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // add sub view and constraints
        contentView.addSubview(arrowView)
        
        let marginGuide = contentView.layoutMarginsGuide
        let trailingConstraint = NSLayoutConstraint(item: arrowView, attribute: .trailing, relatedBy: .equal, toItem: marginGuide, attribute: .trailing, multiplier: 1, constant: 0)
        let widthConstraint = arrowView.widthAnchor.constraint(equalToConstant: 16)
        let heightConstraint = arrowView.heightAnchor.constraint(equalToConstant: 16)
        let yCenter = NSLayoutConstraint(item: arrowView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingConstraint, widthConstraint, heightConstraint, yCenter])
        
        // add gesture recognizer
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHeaderTapped(_:))))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onHeaderTapped(_ gestureRecognizer: UITapGestureRecognizer) {

        if headerDelegate != nil {
            isExpanded = !isExpanded
            headerDelegate!.didExpandingStateChanged(on: index, now: isExpanded)
        }
    }
    
    func updateArrowState() {
        arrowView.rotate(isExpanded ? 0.0 : .pi / 2)
    }
}
