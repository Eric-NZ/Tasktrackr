//
//  SinglePickerController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 19/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class SinglePickerController: UITableViewController {
    
    private var selection: IndexPath? {
        didSet {
            onSelectionChanged(on: selection!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        onSelectionChanged(on: selection!)
    }
    
    private func onSelectionChanged(on indexPath: IndexPath) {
        if let numberOfSections = tableView?.numberOfSections {
            for section in 0..<numberOfSections {
                if let numberOfRowsInSection = tableView?.numberOfRows(inSection: section) {
                    for row in 0..<numberOfRowsInSection {
                        let ip = IndexPath(row: row, section: section)
                        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) {
                            cell.accessoryType = ip == indexPath ? .checkmark : .none
                        }
                    }
                }
            }
        }
    }
    
    func selectionFinished(selection: IndexPath){}
}

// MARK: - public functions
extension SinglePickerController {
    
    public func setSelection(on indexPath: IndexPath) {
        self.selection = indexPath
    }
}

// MARK: - UITableViewDelegate
extension SinglePickerController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        setSelection(on: indexPath)
        selectionFinished(selection: indexPath)
    }
}
