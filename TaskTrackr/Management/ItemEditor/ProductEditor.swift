//
//  ProductEditor.swift
//  TaskTrackr
//
//  Created by Eric Ho on 2/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import Former
import TagListView

extension ItemEditorController {
    // MARK: - build Product form
    func buildProductForm() {
        
        // initial model array
        let initialModelArray : () -> [ProductModel] = {
            if (self.currentProduct == nil) {
                return []
            } else {
                let models: [ProductModel] = DatabaseService.shared.getModelArray(in: self.currentProduct!)
                return models
            }
        }
        
        // product name
        let nameField = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Product Name"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textField.textColor = .formerSubColor()
            $0.textField.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.placeholder = "Product Name"
                $0.text = currentProduct != nil ? currentProduct?.productName : ""
                productName = $0.text!
            }.onTextChanged { (text) in
                // save product name
                self.productName = text
        }
        // product desc
        let descField = TextViewRowFormer<FormTextViewCell>() {
            $0.titleLabel.text = "Description"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFont(ofSize: 15)
            }.configure {
                $0.placeholder = "Add product introduction."
                $0.text = currentProduct != nil ? currentProduct?.productDesc : ""
                productDesc = $0.text!
            }.onTextChanged { (text) in
                // save product desc
                self.productDesc = text
        }
        
        let sectionBasic = SectionFormer(rowFormer: nameField, descField).set(headerViewFormer: createHeader("Basic Product Info"))
        
        // models
        let tagRow = CustomRowFormer<TagTableViewCell>(instantiateType: .Nib(nibName: "TagTableViewCell")) {
            let models: [String] = initialModelArray().map {
                return $0.modelName!
            }
            $0.modelTagList.addTags(models)
            // save member variable tagListView
            self.tagListView = $0.modelTagList
            }.configure {
                $0.rowHeight = UITableView.automaticDimension
        }
        let tagControl = CustomRowFormer<TagControlTableViewCell>(instantiateType: .Nib(nibName: "TagControlTableViewCell")) {
            $0.onAddPressed = { newTagName in
                // text from the textField in TagControlTableViewCell
                if !newTagName.isEmpty {
                    self.tagListView?.addTag(newTagName)
                    
                    // in order to update the custom cell height
                    self.tableView.reloadData()
                }
            }
        }
        
        let sectionModels = SectionFormer(rowFormer: tagRow, tagControl).set(headerViewFormer: createHeader("Product Models"))
        former.append(sectionFormer: sectionBasic, sectionModels)
    }
    
    // save Product form
    func saveProductForm() -> Bool {
        guard !productName.isEmpty else {
            return false
        }
        
        // changed model array
        let changedModelArray: () -> [ProductModel] = {
            let tagViews: [TagView] = (self.tagListView?.tagViews)!
            let models: [ProductModel] = tagViews.map {
                let model = ProductModel()
                model.modelName = $0.titleLabel?.text
                model.product = self.currentProduct
                return model
            }
            return models
        }
        
        if (currentProduct == nil) {
            // create a new item
            currentProduct = Product()
            currentProduct?.productName = productName
            currentProduct?.productDesc = productDesc
            // add to database
            DatabaseService.shared.addObject(for: currentProduct!)
        } else {
            // edit an existing item
            DatabaseService.shared.updateProduct(for: currentProduct!, with: productName, with: productDesc, with: changedModelArray())
        }
        
        // save models
        DatabaseService.shared.saveModels(to: currentProduct!, with: changedModelArray())
        
        return true
    }
}
