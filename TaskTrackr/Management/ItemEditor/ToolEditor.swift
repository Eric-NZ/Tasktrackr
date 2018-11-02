//
//  ToolEditor.swift
//  TaskTrackr
//
//  Created by Eric Ho on 2/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import Former

extension ItemEditorController {
    // MARK: - build Tool form
    func buildToolForm() {
        // Tool name
        let nameField = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Tool Name"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textField.textColor = .formerSubColor()
            $0.textField.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.placeholder = "Tool Name"
                $0.text = currentTool != nil ? currentTool?.toolName : ""
                toolName = $0.text!
            }.onTextChanged { (text) in
                // save product name
                self.toolName = text
        }
        // Tool desc
        let descField = TextViewRowFormer<FormTextViewCell>() {
            $0.titleLabel.text = "Description"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFont(ofSize: 15)
            }.configure {
                $0.placeholder = "Add tool introduction."
                $0.text = currentTool != nil ? currentTool?.toolDesc : ""
                toolDesc = $0.text!
            }.onTextChanged { (text) in
                // save product desc
                self.toolDesc = text
        }
        let sectionBasic = SectionFormer(rowFormer: nameField, descField).set(headerViewFormer: createHeader("Tool Info"))
        
        former.append(sectionFormer: sectionBasic)
    }
    // save Tool form
    func saveToolForm() -> Bool {
        guard !toolName.isEmpty else {
            return false
        }
        
        if currentTool == nil {
            // create a new tool
            currentTool = Tool()
            currentTool?.toolName = toolName
            currentTool?.toolDesc = toolDesc
            // save to database
            DatabaseService.shared.addObject(for: currentTool!)
        } else {
            // update existing tool
            DatabaseService.shared.updateTool(for: currentTool!, with: toolName, with: toolDesc)
        }
        return true
    }
}
