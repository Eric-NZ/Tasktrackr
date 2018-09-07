//
//  AddItemFormController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 7/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import SwiftForms

/* ItemFormControllerDeletgate
 */
protocol ItemFormControllerDelegate {
    func loadFormData(for controller: FormViewController)
}

/* UITableViewController
 */
class ItemFormController: FormViewController {
    
    var delegate: ItemFormControllerDelegate?
    var senderController: UIViewController?
    var isNewForm: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // build Form
        if senderController != nil {
            buildForm(for: (senderController!.restorationIdentifier!))
            // load data
            if !isNewForm {
                delegate?.loadFormData(for: self)
            }
        }

    }
    
    func buildForm(for page: String) {
        switch (page) {     // restoration id: was set same to Storyboard ID
        case Constants.ACTION_PAGE:
            buildActionForm()
        case Constants.WORKER_PAGE:
            buildWorkerForm()
        case Constants.PRODUCT_PAGE:
            buildProductForm()
        case Constants.TOOL_PAGE:
            buildToolForm()
        case Constants.SITE_PAGE:
            buildSiteForm()
            break
        default:
            return
        }
    }
    
    func buildActionForm() {
        self.title = "Action"
    }
    
    func buildWorkerForm() {
        self.title = "Register New Worker"
        // form
        let form = FormDescriptor(title: "Worker")
        //      section1
        let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        //          rowFirstName
        let rowFirstName = FormRowDescriptor(tag: "First Name", type: .name, title: "First Name")
        rowFirstName.configuration.cell.appearance = ["textField.placeholder" : "John" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section1.rows.append(rowFirstName)
        //          rowLastName
        let rowLastName = FormRowDescriptor(tag: "Last Name", type: .name, title: "Last Name")
        rowLastName.configuration.cell.appearance = ["textField.placeholder" : "Wang" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section1.rows.append(rowLastName)
        //      section2
        let section2 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        //          rowRole
        let rowRole = FormRowDescriptor(tag: "Role", type: .name, title: "Role")
        rowRole.configuration.cell.appearance = ["textField.placeholder" : "e.g. Installer" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section2.rows.append(rowRole)
        form.sections = [section1, section2]
        
        form.sections = [section1, section2]
        
        self.form = form
    }
    
    func buildProductForm() {
        self.title = "Product"
    }
    
    func buildToolForm() {
        self.title = "Tool"
    }
    
    func buildSiteForm() {
        self.title = "Site"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return form.sections.count
    }
    
    struct Static {
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let jobTag = "job"
        static let emailTag = "email"
        static let URLTag = "url"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let picker = "picker"
        static let birthday = "birthday"
        static let categories = "categories"
        static let button = "button"
        static let stepper = "stepper"
        static let slider = "slider"
        static let textView = "textview"
    }

}
