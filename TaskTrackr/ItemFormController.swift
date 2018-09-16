//
//  AddItemFormController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 7/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift
import Former


class ItemFormController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        
        // build form
        buildForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        former.deselect(animated: animated)
    }
    
    func buildForm() {
        
        let createHeader : ((String) -> ViewFormer ) = { text in
            return LabelViewFormer<FormLabelHeaderView>().configure {
                $0.text = text
                $0.viewHeight = 44
            }
        }
        
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
            }.onTextChanged { (text) in
                
        }
        // product desc
        let descField = TextViewRowFormer<FormTextViewCell>() {
            $0.titleLabel.text = "Description"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFont(ofSize: 15)
            }.configure {
                $0.placeholder = "Add product introduction."
            }.onTextChanged { (text) in
                
        }
        
        let sectionBasic = SectionFormer(rowFormer: nameField, descField).set(headerViewFormer: createHeader("Basic Product Info"))
        
        // models
        let tagRow = CustomRowFormer<TagTableViewCell>(instantiateType: .Nib(nibName: "TagTableViewCell")) {
            $0.modelTagList.addTags(["dddd", "ssss", "ddddd", "qqqqq", "cccc", "dddd",
                                     "ssss", "ddddd", "qqqqq", "cccc", "dddd", "ssss",
                                     "ddddd", "qqqqq", "cccc", "dddd", "ssss", "ddddd",
                                     "qqqqq", "cccc", "dddd", "ssss", "ddddd", "qqqqq",
                                     "cccc", "dddd", "ssss", "ddddd", "qqqqq", "cccc",
                                     "dddd", "ssss", "ddddd", "qqqqq", "ccfffffcc", "dddd",
                                     "ssss", "ddddd", "qqqqq", "cccc", "dddd", "ssss",
                                     "ddddd", "qqqqq", "cccc", "dddd", "ssss", "ddddd",
                                     "qqqqq", "cccc", "dddd", "ssss", "ddddd", "qqqqq",
                                     "cccc", "dddd", "ssss", "ddddd", "qqqqq", "cccc"])
            }.configure {
                $0.rowHeight = UITableView.automaticDimension
        }
        let tagControl = CustomRowFormer<TagControlTableViewCell>(instantiateType: .Nib(nibName: "TagControlTableViewCell")) {
            $0.onAddPressed = { newTagName in
                print(newTagName)
            }
        }
        
        let sectionModels = SectionFormer(rowFormer: tagRow, tagControl).set(headerViewFormer: createHeader("Product Models"))
        former.append(sectionFormer: sectionBasic, sectionModels)
    }
    
    @objc func donePressed() {
        // save form data to data server
        
        // if chose present modally call "dismiss", otherwise, call this:
        navigationController?.popViewController(animated: true)
    }
    
}
