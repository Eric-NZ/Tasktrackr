//
//  ServicePickerViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 17/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol ServicePickerDelegate {
    func selectionDidFinish(service: Service)
}

class ServicePickerViewController: SinglePickerController {
    var servicePickerDelegate: ServicePickerDelegate?
    var services: [Service] = DatabaseService.shared.getObjectArray(objectType: Service.self) as! [Service]
    var service: Service?
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // register tableview cell
        tableView.register(CommonTableViewCell.self, forCellReuseIdentifier: CommonTableViewCell.ID)
        
        // select item
        if service != nil {
            setSelection(on: calcIndexPath(from: service!))
        }
    }
    
    override func selectionFinished(selection: IndexPath) {
        self.service = matchService(from: selection)
        if servicePickerDelegate != nil {
            servicePickerDelegate?.selectionDidFinish(service: self.service!)
        }
    }
    
    func calcIndexPath(from service: Service) -> IndexPath {
        var row = 0
        let numberOfServices = services.count
        for r in 0..<numberOfServices {
            if services[r] == service {
                row = r
            }
        }
        return IndexPath(row: row, section: 0)
    }
    
    func matchService(from indexPath: IndexPath) -> Service {
        let index = indexPath.row
        return services[index]
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
