//
//  skillView.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 02/12/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit

class skillView: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        backView.backgroundColor = Styles.salmaoApoio
    }


}
