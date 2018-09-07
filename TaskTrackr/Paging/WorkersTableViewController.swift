//
//  WorkersTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 5/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import SwiftForms

class WorkersTableViewController: UITableViewController, ManageItemDelegate, ItemFormControllerDelegate {
 
    /** ItemFormControllerDelegate
     */
    func loadFormData(for controller: FormViewController) {
        print("I will load some data for \(String(describing: controller))")
    }
    
    let workers: [String] = ["John ZW", "Engua ADs", "GeeGEE HDDD"]

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
        cell.textLabel?.text = workers[indexPath.row]

        return cell
    }
    
    func rootViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Constants.ROOT_PAGE)
    }
}
