//
//  ServicePickerViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 17/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class ServicePickerViewController: SinglePickerController {
    
    var services: [Service] = DatabaseService.shared.getObjectArray(objectType: Service.self) as! [Service]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register tableview cell
        tableView.register(CommonTableViewCell.self, forCellReuseIdentifier: CommonTableViewCell.ID)
        
        // select item
        setSelection(on: IndexPath(row: 1, section: 0))
    }
    
    override func selectionFinished(selection: IndexPath) {
        // 
    }
}

// MARK: - UITableView DataSource
extension ServicePickerViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonTableViewCell.ID) ?? UITableViewCell(style: .default, reuseIdentifier: CommonTableViewCell.ID)
        cell.textLabel?.text = services[indexPath.row].serviceTitle
        cell.detailTextLabel?.text = services[indexPath.row].serviceDesc
        
        return cell
    }

}
