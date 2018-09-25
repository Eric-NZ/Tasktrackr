//
//  SectionHeaderCell.swift
//  TaskTrackr
//
//  Created by Eric Ho on 24/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol SectionHeaderCellDelegate {
    func didSectionHeaderTapped (on selectedTag: Int)
    func willExpandSection(on selectedTag: Int)
    func willFoldSection(on selectedTag: Int)
}

class SectionHeaderCell: UITableViewCell {

    var delegate:  SectionHeaderCellDelegate?
    @IBOutlet weak var expandImage: UIImageView!
    var isExpanded: Bool = true {
        didSet {
            expandImage.image = isExpanded ? UIImage(assetIdentifier: .minus) : UIImage(assetIdentifier: .plus)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        expandImage.image = UIImage(assetIdentifier: .minus)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        addGestureRecognizer(tapGesture)
        
    }
    
    func updateExpandingStatus() {
        if delegate != nil {
            if isExpanded {
                delegate?.willFoldSection(on: tag)
            } else {
                delegate?.willExpandSection(on: tag)
            }
        }
        isExpanded = !isExpanded
    }

    @objc func headerTapped() {
        // header tapped!!
        updateExpandingStatus()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SectionHeaderCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}
