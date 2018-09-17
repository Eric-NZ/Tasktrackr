//
//  ToolsTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 6/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import RealmSwift

class ToolsTableViewController: UITableViewController, ManageItemDelegate {
    
    let realm = DatabaseService.shared.getRealm()
    let tools : Results<Tool>
    var selectedTool: Tool?
    var isNewForm: Bool = true
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationHandle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        tools = realm.objects(Tool.self).sorted(byKeyPath: "timestamp", ascending: false)
        
        super.init(coder: aDecoder)
    }
    
    /** Once data changed, controller will be notified.
     */
    func addNotificationHandle() {
        notificationToken = tools.observe { [weak self] (changes) in
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
    
    func openItemForm(isNewForm: Bool, sender: Any?) {
        self.isNewForm = isNewForm
        performSegue(withIdentifier: Constants.tool_segue, sender: sender)
    }
    
    func removeTool(tool: Tool) {
        try! realm.write {
            realm.delete(tool)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: - ItemFormControllerDelegate
    func loadFormData(for form: UIViewController) {
        
    }
    
    // MARK: - ManageItemDelegate
    func addItem(sender: Any?) {
        openItemForm(isNewForm: true, sender: sender)
    }
    
    func editingMode(editing: Bool, animate: Bool) {
        // set editing mode to tableview
        setEditing(editing, animated: animate)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolCell")
        cell?.textLabel?.text = tools[indexPath.row].toolName
        cell?.detailTextLabel?.text = tools[indexPath.row].toolDesc
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tools.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedTool = tools[indexPath.row]
        
        openItemForm(isNewForm: false, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            removeTool(tool: tools[indexPath.row])
        case .insert:
            break
        default:
            return
        }
    }
}
