//
//  WorkerEditor.swift
//  TaskTrackr
//
//  Created by Eric Ho on 2/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import Former

extension ItemEditorController {
    // MARK: - build Workder form
    func buildWorkerForm() {
        // worker first name
        let firstNameField = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "First Name"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textField.textColor = .formerSubColor()
            $0.textField.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.placeholder = "First Name"
                $0.text = currentWorker != nil ? currentWorker?.firstName : ""
                firstName = $0.text!
            }.onTextChanged { (text) in
                // save product name
                self.firstName = text
        }
        
        // worker last name
        let lastNameField = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Last Name"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textField.textColor = .formerSubColor()
            $0.textField.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.placeholder = "Last Name"
                $0.text = currentWorker != nil ? currentWorker?.lastName : ""
                lastName = $0.text!
            }.onTextChanged { (text) in
                // save product name
                self.lastName = text
        }
        
        let sectionBasic = SectionFormer(rowFormer: firstNameField, lastNameField).set(headerViewFormer: createHeader("Basic Worker Info"))
        
        // worker role
        let options = ["Worker", "Senior Worker", "Lead Worker", "Expert"]
        role = currentWorker == nil ? options[0] : (currentWorker?.role)!
        let roleRow = createSelectorRow("Role", role, sheetSelectorRowSelected(options: options))
        let sectionRole = SectionFormer(rowFormer: roleRow).set(headerViewFormer: createHeader("Role"))
        
        // login account: username
        let username = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Username"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textField.textColor = .formerSubColor()
            $0.textField.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.placeholder = "Username"
                $0.text = currentWorker != nil ? currentWorker?.username : ""
                self.username = $0.text!
            }.onTextChanged { (text) in
                // save username
                self.username = text
        }
        
        // login account: password - randomly generated
        let initialPassword = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Password"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textField.textColor = .red
            $0.textField.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.placeholder = "Initial Password"
                $0.text = currentWorker != nil ? currentWorker?.initialPassword : ""
                self.initialPassword = $0.text!
            }.onTextChanged { (text) in
                // save product name
                self.initialPassword = text
        }
        
        let accountInfo = SectionFormer(rowFormer: username, initialPassword).set(headerViewFormer: createHeader("Account"))
        
        former.append(sectionFormer: sectionBasic, sectionRole, accountInfo)
    }
    
    func saveWorkerForm() -> Bool {
        guard !firstName.isEmpty else {
            return false
        }
        if currentWorker == nil {
            // create a new worker object
            currentWorker = Worker()
            currentWorker?.firstName = firstName
            currentWorker?.lastName = lastName
            currentWorker?.role = role
            currentWorker?.username = username
            currentWorker?.initialPassword = initialPassword
            
            // add new item
            DatabaseService.shared.addObject(for: currentWorker!)
            
            // register new account using username and password provided
            AuthenticationService.shared.signUp(userName: username, password: initialPassword) {
                
            }
        } else {
            // update item
            DatabaseService.shared.updateWorker(for: currentWorker!, with: firstName, with: lastName, with: role, with: username, with: initialPassword)
            
            // change username/password for worker
            //
        }
        
        return true
    }

}
