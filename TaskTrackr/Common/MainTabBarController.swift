//
//  MainTabBarController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 13/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func commonInit() {
        
    }
}
