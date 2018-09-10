//
//  AddItemFormController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 7/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyFORM

/* ItemFormControllerDeletgate
 */
protocol ItemFormControllerDelegate {
    func loadFormData(for form: UIViewController)
}

/* UITableViewController
 */
class ItemFormController: FormViewController {
    
    let realm: Realm = DatabaseService.shared.getRealm()
    var delegate: ItemFormControllerDelegate?
    var isNewItem: Bool = true
    var clientPageIdentifer: String = ""
    var selectedWorker: Worker?
    var selectedProduct: Product?
    
    /**
     Outlet Control Variable List:
     */
    // For Action Form
    
    // For Worker Form
    var firstNameField: TextFieldFormItem?
    var lastNameField: TextFieldFormItem?
    var roleField: OptionPickerFormItem?
    // For Product Form
    var productNameField: TextFieldFormItem?
    var productModelField: TextFieldFormItem?
    var productDescField: TextViewFormItem?
    
    // For Tool Form
    
    // For Site Form
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        
        // If it is not a new item, load data to the form.
        if !isNewItem {
            delegate?.loadFormData(for: self)
        }
    }
    
    override func populate(_ builder: FormBuilder) {
        // build form
        buildForm(for: clientPageIdentifer, builder)
    }
    
    @objc func donePressed() {
        // save form data to data server
        saveFormData(for: clientPageIdentifer)
        
        // if chose present modally call "dismiss", otherwise, call this:
        navigationController?.popViewController(animated: true)
    }
    
    // save item as per different page
    func saveFormData(for page: String) {
        switch(page) {
        case Constants.ACTION_PAGE:
            saveActionForm()
        case Constants.WORKER_PAGE:
            saveWorkerForm()
        case Constants.PRODUCT_PAGE:
            saveProductForm()
        case Constants.TOOL_PAGE:
            saveToolForm()
        case Constants.SITE_PAGE:
            saveSiteForm()
        default:
            return
        }
    }
    
    // Build forms as per different pages
    func buildForm(for page: String, _ builder: FormBuilder) {
        switch (page) {     // restoration id: was set same to Storyboard ID
        case Constants.ACTION_PAGE:
            buildActionForm(builder)
        case Constants.WORKER_PAGE:
            buildWorkerForm(builder)
        case Constants.PRODUCT_PAGE:
            buildProductForm(builder)
        case Constants.TOOL_PAGE:
            buildToolForm(builder)
        case Constants.SITE_PAGE:
            buildSiteForm(builder)
        default:
            return
        }
    }
    
    // Save Action Item to Data Server
    func saveActionForm() {
        
    }
    
    // Save worker item to data server
    func saveWorkerForm() {
        if isNewItem {
            let worker = Worker()
            worker.firstName = firstNameField?.value
            worker.lastName = lastNameField?.value
            worker.role = roleField?.selected?.title
            worker.timestamp = Date()
            
            try! realm.write {
                realm.add(worker)
            }
        } else {
            try! realm.write {
                selectedWorker?.firstName = firstNameField?.value
                selectedWorker?.lastName = lastNameField?.value
                selectedWorker?.role = roleField?.selected?.title
            }
        }
    }
    
    // save product item to data server
    func saveProductForm() {
        if isNewItem {
            let product = Product()
            product.productName = productNameField?.value
            product.productModel = productModelField?.value
            product.productDesc = productDescField?.value
            product.timestamp = Date()
            
            try! realm.write {
                realm.add(product)
            }
        } else {
            try! realm.write {
                selectedProduct!.productName = productNameField?.value
                selectedProduct!.productModel = productModelField?.value
                selectedProduct!.productDesc = productDescField?.value
            }
        }
    }
    
    // save tool item to data server
    func saveToolForm() {}
    
    // save Site item to data server
    func saveSiteForm() {}
    
    // Build Action Form
    func buildActionForm(_ builder: FormBuilder) {
        self.title = "Action"
    }
    
    // Build Worker Form
    func buildWorkerForm(_ builder: FormBuilder) {
        roleField = {
            let instance = OptionPickerFormItem()
            instance.title("Role").placeholder("Required")
            instance.append("Worker").append("Senior Worker").append("Lead Worker").append("Expert")
            
            return instance
        }()
        
        builder += SectionHeaderViewFormItem()
        firstNameField = TextFieldFormItem().title("First Name").placeholder("e.g. John").keyboardType(.default)
        builder += firstNameField!
        lastNameField = TextFieldFormItem().title("Last Name").placeholder("e.g. Meltzer").keyboardType(.default)
        builder += lastNameField!
        
        builder += SectionHeaderViewFormItem()
        builder += roleField!

    }
    
    // Build Product Form
    func buildProductForm(_ builder: FormBuilder) {
        builder += SectionHeaderViewFormItem()
        productNameField = TextFieldFormItem().title("Name").placeholder("e.g. Shower Base").keyboardType(.default)
        builder += productNameField!
        productModelField = TextFieldFormItem().title("Model").placeholder("e.g. D1000a").keyboardType(.default)
        builder += productModelField!
        builder += SectionHeaderViewFormItem()
        productDescField = TextViewFormItem().title("Description: ").placeholder("It can be a brief introduction.")
        builder += productDescField!
    }
    
    // Build Tool Form
    func buildToolForm(_ builder: FormBuilder) {
        self.title = "Tool"
    }
    
    // Build Site Form
    func buildSiteForm(_ builder: FormBuilder) {
        self.title = "Site"
    }

}
