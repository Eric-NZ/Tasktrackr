//
//  TaskDetailViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 20/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    @IBOutlet weak var imageCollection: ImageCollectionView!
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // register collection view cell
        imageCollection.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: ImageCollectionCell.ID)
        imageCollection.dataSource = self
        // set image should be dispalyed while no images avaible
        imageCollection.setDefaultImage(image: UIImage(named: "no-image"))
        // set image removability
        imageCollection.setImageRemovability(removable: false)
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TaskDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let task = task {
            return task.images.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionCell.ID, for: indexPath) as? ImageCollectionCell {
            cell.imageView.image = UIImage(data: (task?.images[indexPath.item])!)
            return cell
        } else {
            return ImageCollectionCell()
        }
    }

}
