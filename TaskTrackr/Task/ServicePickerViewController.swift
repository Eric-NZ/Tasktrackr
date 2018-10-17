//
//  ServicePickerViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 17/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class ServicePickerViewController: ExpandableSelectorController {
    
    var services: [Service] = DatabaseService.shared.getObjectArray(objectType: Service.self) as! [Service]

    override func viewDidLoad() {
        super.viewDidLoad()

        // set arrow image
        configureSectionArrow(arrowImage: UIImage(named: "down-arrow")!)
        // set datasource
        expandableTableViewDataSource = self
        
        // register tableview cell
        tableView.register(CommonTableViewCell.self, forCellReuseIdentifier: CommonTableViewCell.ID)
    }
    
}

extension ServicePickerViewController: ExpandableTableViewDataSource {
    func expandableTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func expandableTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommonTableViewCell.ID) {
            cell.textLabel?.text = services[indexPath.row].serviceTitle
            cell.detailTextLabel?.text = services[indexPath.row].serviceDesc
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: CommonTableViewCell.ID)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Services"
    }
}
