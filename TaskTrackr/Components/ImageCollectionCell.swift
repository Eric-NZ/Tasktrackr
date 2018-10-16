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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
