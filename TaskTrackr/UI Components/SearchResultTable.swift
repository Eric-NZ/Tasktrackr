//
//  SearchResultTable.swift
//  TaskTrackr
//
//  Created by Eric Ho on 13/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol SearchResultTableDelegate {
    func didResultItemSelected(index: Int)
}

class SearchResultTable: UITableViewController {
    
    public var delegate: SearchResultTableDelegate?
    private var matchingItems: [String] = []
    
    public func loadMatchingItems(items: [String]) {
        matchingItems = items
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") {
            cell.textLabel?.text = matchingItems[indexPath.row]
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: "SearchResultCell")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (delegate != nil) {
            delegate?.didResultItemSelected(index: indexPath.row)
        }
    }
}
