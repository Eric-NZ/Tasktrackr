//
//  TaskCell.swift
//  TaskTrackr
//
//  Created by Eric Ho on 22/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    
    static let ID = "TimelineCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
