//
//  CoaSheCollectionViewCell.swift
//  coaSHE
//
//  Created by Sidney Orlovski Nogueira on 1/6/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class CoaSheCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coaShePicture: UIImageView!
    @IBOutlet weak var coaSheNameLabel: UILabel!
    
    @IBOutlet weak var coaSheCargoLabel: UILabel!
    
    //Constraint para ajustar a altura do nome da coaShe.
    @IBOutlet weak var TopAdjustmentConstraintForName: NSLayoutConstraint!
    
    //Constraint para ajustar a altura do cargo da coaShe.
    @IBOutlet weak var TopAdjustmentConstraintForCargo: NSLayoutConstraint!
    
    
}
