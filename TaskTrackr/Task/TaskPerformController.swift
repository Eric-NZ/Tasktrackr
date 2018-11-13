//
//  TaskPerformController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 13/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class TaskPerformController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func commonInit() {
        view.backgroundColor = UIColor.white
        title = "Perform"
        tabBarItem.image = UIImage(named: "tab_to-do-list")
    }
}
