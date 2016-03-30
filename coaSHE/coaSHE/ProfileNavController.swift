//
//  ProfileNavController.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 10/12/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit

class ProfileNavController: UINavigationController {

    var goConfig: Bool = false
    var profileView:ProfileView!
    var coaShe = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        let vc = viewControllers.first as! ProfileView
        vc.goConfig = goConfig
        
        profileView = vc
        
        print("\(self.coaShe)")
        
        if (strcmp(coaShe, "") != 0) {
            //Fala que não deve pegar info do próprio usuário, e passa o ID do usuário dos quais os dados devem ser obtidos.
            vc.isFromSelf = false
            vc.coaShe_data = coaShe
        } else {
            vc.isFromSelf = true
        }
        
     */   
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Recebe como parâmetro o ID da coaShe no Parse, para preencher a view com as infos da mentora!
    func setCoashe (coaShe: String) {
        self.coaShe = coaShe
    }
    
    
    

}
