//
//  ToolTableViewCell.swift
//  TaskTrackr
//
//  Created by Eric Ho on 20/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import ExpandableCell

class ToolTableViewCell: UITableViewCell {
    static let ID = "ToolCell"
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class ProductTableViewCell: ExpandableCell {
    static let ID = "ProductCell"
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class ModelTableViewCell: UITableViewCell {
    static let ID = "ModelCell"
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class NormalTableViewCell: UITableViewCell {
    static let ID = "NormalCell"
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
