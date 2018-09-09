//
//  AddItemFormController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 7/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import SwiftForms
import RealmSwift

/* ItemFormControllerDeletgate
 */
protocol ItemFormControllerDelegate {
    func loadFormData(for controller: UIViewController)
}

/* UITableViewController
 */
class ItemFormController: FormViewController {
    
    let realm: Realm = DatabaseService.shared.getRealm()
    var delegate: ItemFormControllerDelegate?
    var isNewItem: Bool = true
    var clientPageIdentifer: String = ""
    var selectedWorker: Worker?
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        
        // build form
        buildForm(for: clientPageIdentifer)
        
        // If it is not a new item, load data to the form.
        if !isNewItem {
            delegate?.loadFormData(for: self)
        }
    }
    
    @objc func donePressed() {
        
        if isNewItem {      // is creating a new item
            let worker = Worker()
            worker.firstName = form.sections[0].rows[0].value as? String
            worker.lastName = form.sections[0].rows[1].value as? String
            worker.role = form.sections[1].rows[0].value as? String
            worker.timestamp = Date()

            try! realm.write {
                realm.add(worker)
            }
        } else {            // is editing an existing item
            try! realm.write {
                selectedWorker?.firstName = form.sections[0].rows[0].value as? String
                selectedWorker?.lastName = form.sections[0].rows[1].value as? String
                selectedWorker?.role = form.sections[1].rows[0].value as? String
            }
        }
            // if chose present modally call "dismiss", otherwise, call this:
            navigationController?.popViewController(animated: true)
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
        let rowRole = FormRowDescriptor(tag: "Role", type: .picker, title: "Role")
        rowRole.configuration.cell.showsInputToolbar = true
        rowRole.configuration.selection.options = (["A", "B", "C", "D"] as [String]) as [AnyObject]
        rowRole.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            switch option {
            case "A":
                return "Worker"
            case "B":
                return "Senior Worker"
            case "C":
                return "Lead Worker"
            case "D":
                return "Expert"
            default:
                return ""
            }
        }
        section2.rows.append(rowRole)
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

}
