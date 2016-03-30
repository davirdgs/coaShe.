//
//  TabBarController.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 18/01/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var jaTemConta: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.items![0].image = UIImage(named: "tabSubjects")
        self.tabBar.items![1].image = UIImage(named: "tabProfile")
        
        self.tabBar.items![0].title = "Temas"
        self.tabBar.items![1].title = "Perfil"
        
        if(jaTemConta) {
            self.selectedIndex = 1
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
