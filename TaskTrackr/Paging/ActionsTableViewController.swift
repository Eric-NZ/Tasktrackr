//
//  ActionsTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 5/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift

class ActionsTableViewController: UITableViewController, ManageItemDelegate {
    
    let realm = DatabaseService.shared.getRealm()
    var actions: Results<Action>
    var selectedAction: Action?
    var isNewItem: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        actions = realm.objects(Action.self)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemForm = segue.destination as! ItemFormController
        itemForm.currentAction = sender == nil ? nil : selectedAction
        itemForm.clientPage = Static.action_page
    }
    
    func openFormController(sender: Any?) {
        performSegue(withIdentifier: Static.action_segue, sender: sender)
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
        return actions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath)
        
        cell.textLabel?.text = actions[indexPath.row].actionTitle
        cell.detailTextLabel?.text = actions[indexPath.row].actionDesc
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedAction = actions[indexPath.row]
        openFormController(sender: self)
    }
    
}
