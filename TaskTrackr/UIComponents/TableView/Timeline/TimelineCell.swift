//
//  TaskCell.swift
//  TaskTrackr
//
//  Created by Eric Ho on 22/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

struct CellData {
    typealias ButtonAttributeTuple = (tag: Int, target: Any?, image: UIImage?, callback: (()->Void)?)
    // illustrateImage
    var illustrateImage: UIImage?
    // illustrateTitle
    var illustrateTitle: String = ""
    // time text
    var timeText: String = ""
    // button attributes for cell
    var buttonAttributes: [ButtonAttributeTuple] = []
    // other attributes
    var isFirstCell: Bool = false
    var isFinalCell: Bool = false
}

class TimelineCell: UITableViewCell {
    @IBOutlet weak var illustrateImageView: UIImageView!
    @IBOutlet weak var illustrateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!

    static let ID = "TimelineCell"
    
    private var cellData: CellData? {
        didSet {
            updateCellUI(using: cellData!)
        }
    }
    
    // public function: set cell data
    public func setCellData(cellData: CellData) {
        self.cellData = cellData
    }
    
    private func updateCellUI(using data: CellData) {
        // UI
        illustrateImageView.image = data.illustrateImage
        illustrateLabel?.text = data.illustrateTitle
        timeLabel?.text = data.timeText
        
        // UX
        for attribute in data.buttonAttributes {
            let button = UIButton(type: .custom)
            button.setImage(attribute.image, for: .normal)
            button.tag = attribute.tag
            button.addTarget(self, action: #selector(buttonEventHandlerRouter(_:)), for: .touchUpInside)
            
            self.buttonStackView.addArrangedSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 24).isActive = true
        }
        
        timeline.frontColor = data.isFirstCell ? .clear : .black
        timeline.backColor = data.isFinalCell ? .clear : .black
    }
    
    @objc func buttonEventHandlerRouter(_ sender: UIButton) {
        self.cellData?.buttonAttributes[sender.tag].callback?()
    }
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for view in buttonStackView.arrangedSubviews {
            // NOTE: using view.removeFromSuperview() instead of buttonStackView.removeArraggedSubView,
            // Because that only remove the view out of arrangement but not removing from the superview.
            view.removeFromSuperview()
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
