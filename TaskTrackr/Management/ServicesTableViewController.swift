//
//  ServicesTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 5/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift

class ServicesTableViewController: UITableViewController, ManageItemDelegate {
    
    var notificationToken: NotificationToken?
    let realm = DatabaseService.shared.getRealm()
    var services: Results<Service>
    var selectedService: Service?
    var isNewItem: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        services = realm.objects(Service.self)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = DatabaseService.shared.addNotificationHandle(objects: services, tableView: self.tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemForm = segue.destination as! ItemEditorController
        itemForm.currentService = sender == nil ? nil : selectedService
        itemForm.clientPage = Static.page_service
    }
    
    func openFormController(sender: Any?) {
        performSegue(withIdentifier: Static.segue_openServiceForm, sender: sender)
    }
    
    // MARK: - MangeItemDelegate
    func addItem(sender: Any?) {
        openFormController(sender: nil)
    }
    
    func editingMode(editing: Bool, animate: Bool) {
        setEditing(editing, animated: animate)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath)
        
        cell.textLabel?.text = services[indexPath.row].serviceTitle
        cell.detailTextLabel?.text = services[indexPath.row].serviceDesc
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedService = services[indexPath.row]
        openFormController(sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            removeService(service: services[indexPath.row])
        default:
            break
        }
    }
    
    // remove entire service
    func removeService(service: Service ) {
        DatabaseService.shared.removeObject(toRemove: service)
    }
    
}

