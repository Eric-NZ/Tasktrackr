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

class ItemEditorController: FormViewController {
    
    // client page identifer
    var clientPage: String = ""
    // current item
    var currentService: Service?
    var currentWorker: Worker?
    var currentProduct: Product?
    var currentTool: Tool?
    
    // for service
    var serviceTitle: String = ""
    var serviceDesc: String = ""
    var productSelectorMenu: LabelRowFormer<FormLabelCell>?
    var toolSelectorMenu: LabelRowFormer<FormLabelCell>?
    var applicableTools: [Tool] = []
    var applicableModels: [ProductModel] = []
    
    // for product
    var tagListView: TagListView?
    var productName: String = ""
    var productDesc: String = ""
    
    // for worker
    var firstName: String = ""
    var lastName: String = ""
    var role: String = ""
    var username: String = ""
    var initialPassword: String = ""
    
    // for tool
    var toolName: String = ""
    var toolDesc: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(donePressed))
        
        // build form
        switch clientPage {
        case Static.page_service:
            buildServiceForm()
        case Static.page_worker:
            buildWorkerForm()
        case Static.page_product:
            buildProductForm()
        case Static.page_tool:
            buildToolForm()
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        former.deselect(animated: animated)
    }
    
    @objc func donePressed() {
        var isSaved: Bool = false
        
        switch clientPage {
        case Static.page_service:
            isSaved = saveServiceForm()
        case Static.page_worker:
            isSaved = saveWorkerForm()
        case Static.page_product:
            isSaved = saveProductForm()
        case Static.page_tool:
            isSaved = saveToolForm()
        default:
            break
        }
        
        // if chose present modally call "dismiss", otherwise, call this:
        if isSaved {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // Section Header
    let createHeader : ((String) -> ViewFormer ) = { text in
        return LabelViewFormer<FormLabelHeaderView>().configure {
            $0.text = text
            $0.viewHeight = 44
        }
    }
    
    // Menu
    let createMenu : ((String, String, (() -> Void)?) -> RowFormer) = { (text, subText, onSelected) in
        return LabelRowFormer<FormLabelCell>() {
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.accessoryType = .disclosureIndicator
            }.configure {
                $0.text = text
                $0.subText = subText
            }.onSelected({ _ in
                onSelected?()
            })
    }
    
    // selector
    let createSelectorRow = { (
        text: String,
        subText: String,
        onSelected: ((RowFormer) -> Void)?
        ) -> RowFormer in
        return LabelRowFormer<FormLabelCell>() {
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.subTextLabel.textColor = .formerSubColor()
            $0.subTextLabel.font = .boldSystemFont(ofSize: 14)
            $0.accessoryType = .disclosureIndicator
            }.configure { form in
                _ = onSelected.map { form.onSelected($0) }
                form.text = text
                form.subText = subText
        }
    }
    
    func sheetSelectorRowSelected(options: [String]) -> (RowFormer) -> Void {
        return { [weak self] rowFormer in
            if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
                let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                options.forEach { title in
                    sheet.addAction(UIAlertAction(title: title, style: .default, handler: { [weak rowFormer] _ in
                        rowFormer?.subText = title
                        // save to variable.
                        self?.role = title
                        rowFormer?.update()
                    })
                    )
                }
                sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(sheet, animated: true, completion: nil)
                self?.former.deselect(animated: true)
            }
        }
    }
    
}
