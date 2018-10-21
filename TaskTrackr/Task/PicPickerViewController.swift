//
//  PicPickerViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 14/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol PicturePickerDelegate {
    func onPictureSelectionFinished(images: [UIImage])
}

class PicPickerViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: ImageCollectionView!
    var delegate: PicturePickerDelegate?
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NOTE: register collection view cell: instead of using class, use Nib, or the sub views will be nil!
        imageCollectionView.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: ImageCollectionCell.ID)
        // set default image on imageCollectionView
        imageCollectionView.setDefaultImage(image: UIImage(named: "no-image"))
        // set image removability
        imageCollectionView.setImageRemovability(removable: true)
        // set datasource
        imageCollectionView.dataSource = self
        imageCollectionView.imageCollectionViewDelegate = self
        // configure bar items
        configureNavItems()
    
    }
    
    func configureNavItems() {
        // image creator button
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera"), for: UIControl.State.normal)
        let addImageButton = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(onAddPhotoTouched), for: UIControl.Event.touchUpInside)
        // done button
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneTouched))
        // spacing
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 20
        navigationItem.rightBarButtonItems = [doneButton, space, addImageButton]

    }
    
    @objc func onAddPhotoTouched() {
        // popup alert action sheet
        popupActionSheet()
    }
    
    @objc func onDoneTouched() {
        // collect images
        if delegate != nil {
            delegate?.onPictureSelectionFinished(images: images)
        }
        // dismiss
        navigationController?.popViewController(animated: true)
    }
    
    func popupActionSheet() {
        // create an alert controller
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.takePicture()
        }
        let albumAction = UIAlertAction(title: "Choose from Album", style: .default) { (action) in
            self.choosePicture()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(albumAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func takePicture() {
        let picturePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picturePicker.sourceType = .camera
            present(picturePicker, animated: true, completion: nil)
        } else {
            // camera doesn't exist
            print("Camera doesn't exist!")
        }
        
        picturePicker.delegate = self
    }

    func choosePicture() {
        let picturePicker = UIImagePickerController()
        picturePicker.allowsEditing = true
        picturePicker.sourceType = .photoLibrary
        present(picturePicker, animated: true, completion: nil)
        
        picturePicker.delegate = self
    }
    
}

extension PicPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCollectionViewDelegate {
    // MARK: - ImageCollectionViewDelegate
    func onReceiveDeleteRequest(indexPath: IndexPath) {
        images.remove(at: indexPath.item)
        imageCollectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as? ImageCollectionCell

        cell?.setImage(image: images[indexPath.item])
        cell?.titleLabel.text = String(format: "%d", indexPath.item)
        return cell!
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // extract image
        if !info.isEmpty {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            // append image to array
            images.append(image)
            imageCollectionView.reloadData()
        } else {
            print("image info error")
        }
        
        dismiss(animated: true, completion: nil)
    }
}

