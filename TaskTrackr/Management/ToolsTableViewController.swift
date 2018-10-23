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
        
        notificationToken = DatabaseService.shared.addNotificationHandleForRows(objects: tools, tableView: self.tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        tools = realm.objects(Tool.self).sorted(byKeyPath: "timestamp", ascending: false)
        
        super.init(coder: aDecoder)
    }
    
    func openItemForm(sender: Any?) {
        performSegue(withIdentifier: Static.segue_openToolForm, sender: sender)
    }
    
    func removeTool(tool: Tool) {
        DatabaseService.shared.removeObject(toRemove: tool)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemForm = segue.destination as! ItemEditorController
        itemForm.clientPage = Static.page_tool
        itemForm.currentTool = sender == nil ? nil : selectedTool
    }
    
    // MARK: - ManageItemDelegate
    func addItem(sender: Any?) {
        openItemForm(sender: nil)
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
        
        openItemForm(sender: self)
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
