//
//  OptionSheetController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 15/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

struct SheetItem {
    var item: String = ""
}

class OptionSheetController: UIAlertController {
    
    var sheetItems: [SheetItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func insertSheetItem() {
        
    }
}
