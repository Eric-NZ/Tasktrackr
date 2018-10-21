//
//  ImageCollectionCell.swift
//  TaskTrackr
//
//  Created by Eric Ho on 15/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    static let ID = "ImageCollectionCell"
    // callback closure
    var onDeleteTapped: ((_ cell: UICollectionViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onDeleteTapped(_ sender: UIButton) {
        onDeleteTapped?(self)
    }
    
    public func setImage(image: UIImage?) {
        if let image = image {
            imageView.image = image
        }
    }
    
    public func setTitle(title: String) {
        titleLabel.text = title
    }

}
