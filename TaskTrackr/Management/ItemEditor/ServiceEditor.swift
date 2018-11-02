//
//  ServiceEditor.swift
//  TaskTrackr
//
//  Created by Eric Ho on 2/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import Former

extension ItemEditorController {
    // MARK: - build Service form
    func buildServiceForm(){
        // initialize model list & tool arrays
        if currentService != nil {
            applicableModels = DatabaseService.shared.modelListToArray(from: (currentService?.models)!)
            applicableTools = DatabaseService.shared.toolListToArray(from: (currentService?.tools)!)
        }
        // Service Title
        let nameField = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Service Title"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textField.textColor = .formerSubColor()
            $0.textField.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.placeholder = "e.g. Install Shower Trays"
                $0.text = currentService != nil ? currentService?.serviceTitle : ""
                serviceTitle = $0.text!
            }.onTextChanged { (text) in
                // save product name
                self.serviceTitle = text
        }
        // Service Desc
        let descField = TextViewRowFormer<FormTextViewCell>() {
            $0.titleLabel.text = "Description"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFont(ofSize: 15)
            }.configure {
                $0.placeholder = "Add Service Introduction"
                $0.text = currentService != nil ? currentService?.serviceDesc : ""
                serviceDesc = $0.text!
            }.onTextChanged { (text) in
                // save service desc
                self.serviceDesc = text
        }
        
        let sectionBasic = SectionFormer(rowFormer: nameField, descField).set(headerViewFormer: createHeader("Basic Service Info"))
        
        // MARK: applied products
        productSelectorMenu = createMenu("🚿 Applicable Products", getProductSelectionStateText()) { [weak self] in
            self?.performSegue(withIdentifier: Static.segue_openProductSelector, sender: self)
            } as? LabelRowFormer<FormLabelCell>
        
        // MARK: applied tools
        toolSelectorMenu = createMenu("🔨 Applicable Tools", getToolSelectionStateText()) { [weak self] in
            // perform segue: OpenToolPicker
            self?.performSegue(withIdentifier: Static.segue_openToolSelector, sender: self)
            } as? LabelRowFormer<FormLabelCell>
        
        let sectionSelector = SectionFormer(rowFormer: productSelectorMenu!, toolSelectorMenu!)
        former.append(sectionFormer: sectionBasic, sectionSelector)
    }
    // save Service form
    func saveServiceForm() -> Bool {
        guard !serviceTitle.isEmpty else {
            return false
        }
        
        var isUpdate = false
        if currentService == nil {       // if it is a new Service
            currentService = Service()
            
        } else {                        // if we are editing an existing Service
            isUpdate = true
        }
        DatabaseService.shared.addService(add: currentService!, serviceTitle, serviceDesc, tools: applicableTools, models: applicableModels, update: isUpdate)
        
        return true
    }
    
    // MARK: prepare information for the presented selector view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Static.segue_openToolSelector:
            prepareForTool(for: segue)
        case Static.segue_openProductSelector:
            prepareForProduct(for: segue)
        default:
            break
        }
    }
    
    private func prepareForTool(for segue: UIStoryboardSegue) {
        let selector = segue.destination as! ToolPickerViewController
        // deliver selectedTools
        selector.selectedTools = applicableTools
        // assign delegate
        selector.toolPickerDelegate = self
    }
    
    private func prepareForProduct(for segue: UIStoryboardSegue) {
        let selector = segue.destination as! ProductPickerViewController
        // init original selected models
        selector.selectedModels = applicableModels
        // init the delegate of selector
        selector.productPickerDelegate = self
    }
}

// MARK: - ItemPickerDelegate
extension ItemEditorController: ProductPickerDelegate, ToolPickerDelegate {
    func selectionDidFinish(selectedTools: [Tool]) {
        self.applicableTools = selectedTools
        
        // update subText on selector menu
        updateSelectorMenu()
    }
    
    func selectionDidFinish(selectedModels: [ProductModel]) {
        self.applicableModels = selectedModels
        
        // update summary on selector menu
        updateSelectorMenu()
    }
    
    func getProductSelectionStateText() -> String {
        let numberOfModels = applicableModels.count
        
        let productSubText: String = {
            switch numberOfModels {
            case 0:
                return Static.none_selected
            case 1:
                return "1 Model Selected"
            default:
                return String.init(format: "%d Models Selected", numberOfModels)
            }
        }()
        
        return productSubText
    }
    
    func getToolSelectionStateText() -> String {
        let numberOfTools = applicableTools.count
        
        let toolSubText: String = {
            switch numberOfTools {
            case 0:
                return Static.none_selected
            case 1:
                return "1 Tool Selected"
            default:
                return String.init(format: "%d Tools Selected", numberOfTools)
            }
        }()
        
        return toolSubText
    }
    
    func updateSelectorMenu() {
        guard productSelectorMenu != nil else {return}
        guard toolSelectorMenu != nil else {return}
        
        productSelectorMenu?.subText = getProductSelectionStateText()
        toolSelectorMenu?.subText = getToolSelectionStateText()
        
        former.reload()
    }
}

