//
//  ProfileImageView.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 11/03/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class ProfileImageView: UIView {

    @IBOutlet weak var backgroundProfileImage: UIImageView!
    @IBOutlet weak var centerProfileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleName: UILabel!
    
    let image = UIImage(named: "costumer")
    
    override func drawRect(rect: CGRect) {
       
        self.backgroundColor = Styles.roxoCoashe
        
        backgroundProfileImage.image = image
        backgroundProfileImage.alpha = 0.8
        centerProfileImage.image = image
        
        centerProfileImage.layer.cornerRadius = centerProfileImage.layer.frame.height/2
        centerProfileImage.layer.masksToBounds = false
        centerProfileImage.clipsToBounds = true
    }

}
