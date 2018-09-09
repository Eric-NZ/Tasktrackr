//
//  WorkersTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 5/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import SwiftForms
import RealmSwift

class WorkersTableViewController: UITableViewController, ManageItemDelegate, ItemFormControllerDelegate {
    
    let workers: Results<Worker>
    let realm = DatabaseService.shared.getRealm()
    var notificationToken: NotificationToken?
    var selectedWorker: Worker?
    
    var isNewForm: Bool = true
    
    required init?(coder aDecoder: NSCoder) {

        // initialize self.realm
        workers = realm.objects(Worker.self).sorted(byKeyPath: "timestamp", ascending: false)
        
        super.init(coder: aDecoder)
    }
    
    /** ItemFormControllerDelegate
     */
    func loadFormData(for controller: UIViewController) {
        let formController: ItemFormController = controller as! ItemFormController
        
        formController.form.sections[0].rows[0].value = selectedWorker?.firstName as AnyObject
        formController.form.sections[0].rows[1].value = selectedWorker?.lastName as AnyObject
        formController.form.sections[1].rows[0].value = selectedWorker?.role as AnyObject
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationHandle()
    }
    
    /** Once data changed, controller will be notified.
     */
    func addNotificationHandle() {
        notificationToken = workers.observe { [weak self] (changes) in
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
    func addItem(sender: Any?) {        // sender: RootPaingViewController, create a new form
        openWorkerForm(isNewForm: true, sender: sender)
    }
    
    func editingMode(editing: Bool, animate: Bool) {
        setEditing(editing, animated: animate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // tell the destination View controller 2 things:
        // 1. is a new form? - isNewForm: Bool
        // 2. who will use the form? -  paingIdentifier: String
        // 3. which item is selected
        
        let itemFormController = segue.destination as! ItemFormController
        itemFormController.delegate = self
        
        // will build a new form without filling data
        itemFormController.isNewItem = isNewForm
        // let ItemFormController know client page it will build a form for
        itemFormController.clientPageIdentifer = Constants.WORKER_PAGE
        // which item is selected
        itemFormController.selectedWorker = selectedWorker
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerCell", for: indexPath)
        cell.textLabel?.text = workers[indexPath.row].firstName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            removeWorker(worker: workers[indexPath.row])
            break
        case .insert:
            break
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // open item detail form controller
        selectedWorker = workers[indexPath.row]
        openWorkerForm(isNewForm: false, sender: self)
    }
    
    /**
        Get Instance of Specific Page
     */
    func rootViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Constants.ROOT_PAGE)
    }
    
    /**
        Remove Worker Item
     */
    func removeWorker(worker: Worker) {
        try! realm.write {
            realm.delete(worker)
        }
    }
    

    func openWorkerForm(isNewForm: Bool, sender: Any?) {
        self.isNewForm = isNewForm
        
        performSegue(withIdentifier: Constants.WORKER_SEGUE, sender: sender)
    }
    
}
