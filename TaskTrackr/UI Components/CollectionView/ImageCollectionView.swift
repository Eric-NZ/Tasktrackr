//
//  ImageCollectionView.swift
//  TaskTrackr
//
//  Created by Eric Ho on 20/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol ImageCollectionViewDelegate {
    func onReceiveDeleteRequest(indexPath: IndexPath)
}
class ImageCollectionView: UICollectionView {
    var imageCollectionViewDelegate: ImageCollectionViewDelegate?
    var isImageRemovable: Bool = true
    var defaultImageView: UIImageView?
    var defaultImage: UIImage? {
        didSet {
            initDefaultImageView()
            layoutDefaultImageView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // NOTE: Do not assign delegate in sub classes, or the delegate functions implemented here will never invoked.
        delegate = self
    }
    
    // default image displays while no images available
    public func setDefaultImage(image: UIImage?) {
        if let image = image {
            defaultImage = image
        }
    }
    
    public func setImageRemovability(removable: Bool) {
        isImageRemovable = removable
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ImageCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let space: CGFloat = 3

        if DeviceInfo.Orientation.isPortrait {
            return CGSize(width: width/2 - space, height: width/2 - space)
        } else {
            return CGSize(width: width/4 - space, height: width/4 - space)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        showDefaultImage(show: false)
        
        // set delete button visability and callback function
        if let cell = cell as? ImageCollectionCell {
            cell.deleteButton.isHidden = !isImageRemovable
            cell.onDeleteTapped = { (sender) in
                if let cell = sender as? ImageCollectionCell {
                    if let ip = self.indexPath(for: cell) {
                        self.onReceivedDeleteRequest(indexPath: ip)
                    }
                }
            }
        }
    }
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
}

// MARK: - private functions
extension ImageCollectionView {
    
    private func initDefaultImageView() {
        if let image = defaultImage {
            defaultImageView = UIImageView(image: image)
            if let view = defaultImageView {
                addSubview(view)
            }
        }
    }
    
    private func layoutDefaultImageView() {
        // auto layout
        if let view = defaultImageView {
            defaultImageView!.translatesAutoresizingMaskIntoConstraints = false
            let centerX = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([centerX, centerY])
        }
    }
    
    private func showDefaultImage(show: Bool) {
        defaultImageView?.isHidden = !show
    }
    
    private func onReceivedDeleteRequest(indexPath: IndexPath) {
        if let delegate = imageCollectionViewDelegate {
            delegate.onReceiveDeleteRequest(indexPath: indexPath)
        }
    }
}
