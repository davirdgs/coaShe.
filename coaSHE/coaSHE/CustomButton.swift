//
//  CustomButton.swift
//  Design_coashe
//
//  Created by Carolina Bonturi on 11/22/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    
    
    override init(frame aFrame: CGRect) {
        super.init(frame: aFrame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setProperties() {
        // self.setTitleColor(UIColor(red: 253.0 / 255.0, green: 164.0 / 255.0, blue: 134.0 / 255.0, alpha: 0.8), forState: UIControlState.Normal)
        self.setTitleColor(UIColor(white: 1.0, alpha: 0.8), forState: UIControlState.Normal)
        
        // self.titleLabel?.font = UIFont(name: "Helvetica", size: 26)
        
        self.layer.borderWidth = 1
        
        //self.layer.borderColor = UIColor(red: 253.0 / 255.0, green: 164.0 / 255.0, blue: 134.0 / 255.0, alpha: 0.8).CGColor
        self.layer.borderColor = UIColor(white: 1.0, alpha: 0.8).CGColor
        
        self.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setProperties()
    }
}