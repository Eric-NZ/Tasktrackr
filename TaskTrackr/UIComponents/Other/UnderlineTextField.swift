//
//  FormTextField.swift
//  TaskTrackr
//
//  Created by Eric Ho on 9/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class UnderlineTextField: UITextField {
    
    var placeholderColor: UIColor?
    var bottomColor: UIColor? {
        didSet {
            placeholderColor = Static.getComplementaryForColor(color: self.bottomColor!)
        }
    }

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.textColor = UIColor.lightText
        self.borderStyle = .none
        self.tintColor = UIColor.white
        self.autocapitalizationType = .none
        self.clearButtonMode = .whileEditing
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var placeholder: String? {
        didSet {
            let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: placeholderColor ?? textColor as Any]
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setBottomBorder(backGroundColor: UIColor, borderColor: UIColor) {
        self.layer.backgroundColor = backGroundColor.cgColor
        
        // defines the layers shadow
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowColor = borderColor.cgColor
        
        self.bottomColor = borderColor
    }
}
