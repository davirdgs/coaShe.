//
//  TemasCellTableViewCell.swift
//  coaSHE
//
//  Created by Carolina Bonturi on 1/18/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class TemasCellTableViewCell: UITableViewCell {

    @IBOutlet weak var nomeDoTema: UIButton!
    
    @IBOutlet weak var imagemDoTema: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
