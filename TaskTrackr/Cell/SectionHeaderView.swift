//
//  SectionHeaderView.swift
//  TaskTrackr
//
//  Created by Eric Ho on 24/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol SectionHeaderViewDelegate {
    func didSectionHeaderTapped (on selectedTag: Int)
}

class SectionHeaderView: UIView {
    
    var delegate:  SectionHeaderViewDelegate?
    
    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func headerTapped() {
        // header tapped!!
        if delegate != nil {
            delegate?.didSectionHeaderTapped(on: tag)
        }
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SectionHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
