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
    
    required init?(coder aDecoder: NSCoder) {

        // initialize self.realm
        workers = realm.objects(Worker.self)
        
        super.init(coder: aDecoder)
    }
    
    /** ItemFormControllerDelegate
     */
    func loadFormData(for controller: FormViewController) {
        print("I will load some data for \(String(describing: controller))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - AddItemDelegate
    func addItem() {
        performSegue(withIdentifier: "AddWorkerItem", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemFormController = segue.destination as! ItemFormController
        itemFormController.delegate = self
        
        // send info: 1. new item: true/false; 2. controller instance
        itemFormController.isNewForm = true
        itemFormController.senderController = self
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
    
    func rootViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Constants.ROOT_PAGE)
    }
}
