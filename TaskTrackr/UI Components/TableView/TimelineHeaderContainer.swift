//
//  TimelineHeaderView.swift
//  TaskTrackr
//
//  Created by Eric Ho on 22/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class TimelineHeaderContainer: UIView {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var workerLabel: UILabel!
    @IBOutlet weak var postDescLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
