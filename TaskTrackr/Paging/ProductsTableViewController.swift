//
//  ProductsTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 6/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift

class ProductsTableViewController: UITableViewController, ManageItemDelegate {
    
    let products: Results<Product>
    let realm = DatabaseService.shared.getRealm()
    var notificationToken: NotificationToken?
    var selectedWorker: Worker?
    var isNewForm: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        
        // initialize products
        products = realm.objects(Product.self).sorted(byKeyPath: "timestamp", ascending: false)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        addNotificationHandle()
    }
    
    /** Once data changed, controller will be notified.
     */
    func addNotificationHandle() {
        notificationToken = products.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: - ManageItemDelegate
    func addItem(sender: Any?) {
        print("Will add a product!")
    }
    
    func editingMode(editing: Bool, animate: Bool) {
        print("Will edit a product!\(editing)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell")
        cell?.textLabel?.text = products[indexPath.row].productName
        
        return cell!
    }
    
}
