//
//  TagTableViewCell.swift
//  TaskTrackr
//
//  Created by Eric Ho on 16/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import TagListView

class TagTableViewCell: UITableViewCell {

    @IBOutlet weak var modelTagList: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}

class TagControlTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newModelField: UITextField!
    
    var onAddPressed : ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onAdd(_ sender: UIButton) {
        onAddPressed?(newModelField.text ?? "")
    }
}
