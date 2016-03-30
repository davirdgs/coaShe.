//
//  SubjectTableViewCell.swift
//  coaSHE
//
//  Created by Sidney Orlovski Nogueira on 10/26/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundImage: UIImageView!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var avaiableCoachsLabel: UILabel!
    @IBOutlet weak var finishedLabel: UILabel!
    @IBOutlet weak var avaiableMaterialLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
