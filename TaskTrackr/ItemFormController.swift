//
//  AddItemFormController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 7/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import Former
import TagListView

class ItemFormController: FormViewController {
    
    // current item
    var currentAction: Action?
    var currentWorker: Worker?
    var currentProduct: Product?
    var currentTool: Tool?
    var currentSite: Site?
    
    // for product
    var tagListView: TagListView?
    var productName: String = ""
    var productDesc: String = ""
    
    // for worker
    var firstName: String = ""
    var lastName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        
        // build form
        buildProductForm()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        former.deselect(animated: animated)
    }
    
    // initial model array
    func initialModelArray() -> [Model] {
        if (currentProduct == nil) {
            return []
        } else {
            let models: [Model] = DatabaseService.shared.getModelArray(in: currentProduct!)
            return models
        }
    }
    
    // changed model array
    func changedModelArray() -> [Model] {
        let tagViews: [TagView] = (tagListView?.tagViews)!
        let models: [Model] = tagViews.map {
            let model = Model()
            model.modelName = $0.titleLabel?.text
            model.product = currentProduct
            return model
        }
        return models
    }
    
    func buildProductForm() {
        
        // Section Header
        let createHeader : ((String) -> ViewFormer ) = { text in
            return LabelViewFormer<FormLabelHeaderView>().configure {
                $0.text = text
                $0.viewHeight = 44
            }
        }
        
        // Menu
        let _: ((String, (() -> Void)?) -> RowFormer) = { (text, onSelected) in
            return LabelRowFormer<FormLabelCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 16)
                $0.accessoryType = .disclosureIndicator
                }.configure {
                    $0.text = text
                }.onSelected({ _ in
                    onSelected?()
                })
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
            let models: [String] = self.initialModelArray().map {
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
    
    @objc func donePressed() {
        guard !productName.isEmpty else {
            Static.showToast(toastText: "Please provide a product name.")
            return
        }
        
        if (currentProduct == nil) {
            // create a new item
            currentProduct = Product()
            currentProduct?.productName = productName
            currentProduct?.productDesc = productDesc
            let list = DatabaseService.shared.arrayToList(from: changedModelArray())
            currentProduct?.models = list
            // add to database
            DatabaseService.shared.addProduct(with: currentProduct!)
        } else {
            // edit an existing item
            DatabaseService.shared.updateProduct(for: currentProduct!, with: productName, with: productDesc, with: changedModelArray())
        }
        
        // save models
        DatabaseService.shared.saveModels(to: currentProduct!, with: changedModelArray())
        
        // if chose present modally call "dismiss", otherwise, call this:
        navigationController?.popViewController(animated: true)
    }
}
