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
    func loadFormData(for controller: FormViewController)
}

/* UITableViewController
 */
class ItemFormController: FormViewController {
    
    var delegate: ItemFormControllerDelegate?
    var senderController: UIViewController?
    var isNewForm: Bool = false
    
    let realm: Realm
    
    required init(coder aDecoder: NSCoder) {
        
        // Create the configuration
        let syncServerURL = Constants.REALM_URL
//        for user in SyncUser.all {
//            debugPrint("user: \(user.key) - \(user.value)")
//            user.value.logOut()
//        }
        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: SyncUser.current!, realmURL: syncServerURL))
        
        // Open the remote Realm
        realm = try! Realm(configuration: config)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // build Form
        if senderController != nil {
            buildForm(for: (senderController!.restorationIdentifier!))
            // load data
            if !isNewForm {
                delegate?.loadFormData(for: self)
            }
            
            // set right bar button
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        }

    }
    
    @objc func donePressed() {
        
        let worker = Worker()
        worker.firstName = form.sections[0].rows[0].value as? String
        worker.lastName = form.sections[0].rows[1].value as? String
        worker.role = form.sections[1].rows[0].value as? String
        worker.timestamp = Date()

        try! realm.write {
            realm.add(worker)
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

}
