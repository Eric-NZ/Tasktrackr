//
//  SelectorViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 19/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import ExpandableCell

class SelectorViewController: UIViewController {

    @IBOutlet weak var expandableTableView: ExpandableTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expandableTableView.expandableDelegate = self
    }
}

extension SelectorViewController: ExpandableDelegate {
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        <#code#>
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        <#code#>
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        <#code#>
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
