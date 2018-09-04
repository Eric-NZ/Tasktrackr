//
//  ManageOptionList.swift
//  TaskTrackr
//
//  Created by Eric Ho on 29/08/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class ManageOptionList: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    
    let manageOptionList: [String] = ["option1", "option2", "option3", "option3", "option4", "option5"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    // delegate methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageOptionCell")
        cell?.textLabel?.text = manageOptionList[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manageOptionList.count
    }

}
