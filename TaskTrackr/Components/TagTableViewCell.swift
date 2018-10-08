//
//  TagTableViewCell.swift
//  TaskTrackr
//
//  Created by Eric Ho on 16/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import TagListView

class TagTableViewCell: UITableViewCell, TagListViewDelegate {
    
    @IBOutlet weak var modelTagList: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        modelTagList.textFont = UIFont.systemFont(ofSize: 18)
        modelTagList.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    // MARK: - TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("tagPressed")
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)
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
        // empty the text field
        newModelField.text = ""
    }
}
