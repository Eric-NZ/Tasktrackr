//
//  ActionsTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 5/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class ActionsTableViewController: UITableViewController, ManageItemDelegate {
 
    let actions: [String] = ["ssssssss", "dddddddddd", "ddf", "fffff", "fffffff"]
    
    func getInstance() -> UIViewController {
        return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - MangeItemDelegate
    func addItem() {
        print("Will add an action!")
    }
    
    func editingMode(editing: Bool, animate: Bool) {
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return actions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath)

        cell.textLabel?.text = actions[indexPath.row]

        return cell
    }

}
