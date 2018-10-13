//
//  WorkersTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 5/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift

class WorkersTableViewController: UITableViewController, ManageItemDelegate {
    
    let workers: Results<Worker>
    let realm = DatabaseService.shared.getRealm()
    var notificationToken: NotificationToken?
    var selectedWorker: Worker?
    
    required init?(coder aDecoder: NSCoder) {

        // initialize self.realm
        workers = realm.objects(Worker.self).sorted(byKeyPath: "timestamp", ascending: false)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addNotificationHandle()
        notificationToken = DatabaseService.shared.addNotificationHandle(objects: workers, tableView: self.tableView)
    }
    
    // MARK: - ManageItemDelegate
    func addItem(sender: Any?) {        // sender: RootPaingViewController, create a new form
        openWorkerForm(sender: nil)
    }
    
    func editingMode(editing: Bool, animate: Bool) {
        setEditing(editing, animated: animate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // tell the destination View controller which worker item is selected
        let itemForm = segue.destination as! ItemEditorController
        itemForm.currentWorker = sender == nil ? nil : selectedWorker
        itemForm.clientPage = Static.page_worker
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerCell", for: indexPath)
        cell.textLabel?.text = workers[indexPath.row].firstName
        cell.detailTextLabel?.text = workers[indexPath.row].role

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            removeWorker(worker: workers[indexPath.row])
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
        openWorkerForm(sender: self)
    }
    
    /**
        Get Instance of Specific Page
     */
    func rootViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Static.pageRouter)
    }
    
    /**
        Remove Worker Item
     */
    func removeWorker(worker: Worker) {
        DatabaseService.shared.removeObject(toRemove: worker)
    }

    func openWorkerForm(sender: Any?) {
        performSegue(withIdentifier: Static.segue_openWorkerForm, sender: sender)
    }
    
}
