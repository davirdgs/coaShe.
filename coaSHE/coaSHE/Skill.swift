//
//  Skill.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 01/01/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class Skill: NSObject {

    var skill: String
    var imageName: String
    var valid: Bool = false
    
    init(initWithSkill: String, image: String) {
        self.skill = initWithSkill
        self.imageName = image
    }
    
}
