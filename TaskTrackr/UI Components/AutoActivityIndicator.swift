//
//  ProcessingIndicator.swift
//  TaskTrackr
//
//  Created by Eric Ho on 20/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class AutoActivityIndicator: UIActivityIndicatorView {

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ target: UIView?, style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        
        if let parentView = target {
            parentView.addSubview(self)
        }
        hidesWhenStopped = false
    }
    
    override func layoutSubviews() {
        // auto layout
        translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview?.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview?.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([centerX, centerY])
    }
}

// MARK: - public
extension AutoActivityIndicator {
    
    public func start() {
        startAnimating()
    }
    
    public func stop() {
        stopAnimating()
        removeFromSuperview()
    }
}
