//
//  WorkersTableViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 5/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class WorkersTableViewController: UITableViewController, ManageItemDelegate {
    
    let workers: [String] = ["John ZW", "Engua ADs", "GeeGEE HDDD"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - AddItemDelegate
    func addItem() {
        print("will add a worker!")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

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
