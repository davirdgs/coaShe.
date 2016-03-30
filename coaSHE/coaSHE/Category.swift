//
//  Category.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 01/01/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class Category: NSObject {

    var categoryName: String
    var skillList: [Skill]
    var imageName: String
    
    init(categoryName: String, image: String, skills: [Skill]) {
        self.categoryName = categoryName
        self.skillList = skills
        self.imageName = image
    }
    
}
