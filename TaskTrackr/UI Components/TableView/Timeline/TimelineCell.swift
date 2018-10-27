//
//  TaskCell.swift
//  TaskTrackr
//
//  Created by Eric Ho on 22/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    @IBOutlet weak var illustrateImageView: UIImageView!
    @IBOutlet weak var illustrateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    static let ID = "TimelineCell"
    
    private var buttons: [UIButton] = []
    
    private var timelinePoint = TimelinePoint() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    private var timeline = Timeline() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func draw(_ rect: CGRect) {
        for layer in self.contentView.layer.sublayers! {
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        timelinePoint.position = CGPoint(x: illustrateImageView.frame.origin.x - illustrateImageView.frame.width + timeline.width / 2,
                                         y: illustrateLabel.frame.origin.y + illustrateLabel.intrinsicContentSize.height / 2 - timelinePoint.diameter / 2)
        timeline.start = CGPoint(x: timelinePoint.position.x + timelinePoint.diameter / 2,
                                 y: 0)
        timeline.middle = CGPoint(x: timeline.start.x,
                                  y: timelinePoint.position.y)
        timeline.end = CGPoint(x: timeline.start.x,
                               y: self.bounds.size.height)
        timeline.draw(view: self.contentView)
        
        timelinePoint.draw(view: self.contentView)
    }
}
