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

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}

/* UITableViewController
 */
class ItemFormController: FormViewController, SelectRowDelegate {
    
    var delegate: ItemFormControllerDelegate?
    let realm: Realm = DatabaseService.shared.getRealm()
    var isNewItem: Bool = true
    var clientPageIdentifer: String = ""
    var selectedWorker: Worker?
    var selectedProduct: Product?
    var modelsInSelectedProduct: [Model] = []
    var selectedTool: Tool?
    var selectedAction: Action?
    
    /**
     Outlet Control Variable List:
     */
    // For Action Form
    var actionTitleField: TextFieldFormItem?
    var actionDescField: TextViewFormItem?
    var actionToolsField: OptionPickerFormItem?
    var actionProductsField: OptionPickerFormItem?
    
    // For Worker Form
    var firstNameField: TextFieldFormItem?
    var lastNameField: TextFieldFormItem?
    var roleField: OptionPickerFormItem?
    // For Product Form
    var productNameField: TextFieldFormItem?
    var productModelField: TextFieldFormItem?
    var productDescField: TextViewFormItem?
    
    // For Tool Form
    var toolNameField: TextFieldFormItem?
    var toolDescField: TextViewFormItem?
    
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
            
            // get models in selected product
            modelsInSelectedProduct = realm.objects(Model.self).filter("product=%@", selectedProduct as Any).toArray(ofType: Model.self)
        }
    }
    
    // MARK: - SelectRowDelegate
    func form_didSelectRow(indexPath: IndexPath, tableView: UITableView) {
        print("form_didSelectRow")
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
    
    // Build Action Form
    func buildActionForm(_ builder: FormBuilder) {
        
        // Title and Desc
        self.title = "Action"
        builder += SectionHeaderViewFormItem()
        actionTitleField = TextFieldFormItem().title("Action Title").placeholder("e.g. Install Shower base").keyboardType(.default)
        builder += actionTitleField!
        actionDescField = TextViewFormItem().title("Action Description").placeholder("It can be a brief instruction.")
        builder += actionDescField!
        
        // Products
        builder += SectionHeaderTitleFormItem().title("Applied Products")
        
        
        // Tools
        builder += SectionHeaderTitleFormItem().title("Applied Tools")
        for _ in 0..<12 {
            let tool1: SwitchFormItem = {
                let instance = SwitchFormItem()
                instance.title = "tool1"
                instance.value = true
                return instance
            }()
            builder += tool1
        }
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
        
        // Models
        builder += SectionHeaderViewFormItem()
        let childController = ViewControllerFormItem().title("Models").viewControllerFromInstance(from: Constants.PRODUCT_MODELS)
        builder += childController
        
        // Description
        builder += SectionHeaderViewFormItem()
        productDescField = TextViewFormItem().title("Description    ").placeholder("It can be a brief introduction.")
        builder += productDescField!
    }
    
    // Build Tool Form
    func buildToolForm(_ builder: FormBuilder) {
        self.title = "Tool"
        
        builder += SectionHeaderViewFormItem()
        toolNameField = TextFieldFormItem().title("Name").placeholder("e.g. hammer").keyboardType(.default)
        builder += toolNameField!
        toolDescField = TextViewFormItem().title("Description   ").placeholder("It can be a brief introduction.")
        builder += toolDescField!
    }
    
    // Build Site Form
    func buildSiteForm(_ builder: FormBuilder) {
        self.title = "Site"
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
    func saveToolForm() {
        if isNewItem {
            try! realm.write {
                let tool = Tool()
                tool.toolName = toolNameField?.value
                tool.toolDesc = toolDescField?.value
                realm.add(tool)
            }
        } else {
            try! realm.write {
                selectedTool?.toolName = toolNameField?.value
                selectedTool?.toolDesc = toolDescField?.value
            }
        }
    }
    
    // save Site item to data server
    func saveSiteForm() {}
    
}


extension ViewControllerFormItem {
    
    @discardableResult
    public func viewControllerFromInstance(from identifier: String) -> Self {
        createViewController = { (dismissCommand: CommandProtocol) in
            return RootPagingViewController.getInstance(with: identifier)
        }
        return self
    }
}
