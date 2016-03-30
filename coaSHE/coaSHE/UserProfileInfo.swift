//
//  UserProfileInfo.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 23/11/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit
import CoreData

class UserProfileInfo: NSObject {
    
    ///Primeiro nome obtido do linkedIn
    static var firstName: String = ""
    ///Sobrenome obtido do linkedIn
    static var lastName: String = ""
    ///Descrição do título atual do usuário no linkedIn
    static var headLine: String = ""
    ///Foto de perfil
    static var profileImage = UIImage(named: "missingProfile")
    ///Skills
    //static var userSkills: [String] = [String]()
    ///Resumo
    static var summary: String = ""
    ///Username
    static var username: String = ""
    ///E-mail
    static var email: String = ""
    ///Numero de telefone
    static var phoneNumber: String = ""
    ///Senha
    static var password: String = ""
    ///Nome completo
    static var name: String = ""
    ///Id do usuário
    static var id: String = ""
    ///Skills do usuário
    static var skills = [String]()
    ///
    static var pictureUrl: String = ""
    
    static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json!
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    ///Imprime atributos da usuária
    static func printInfo() {
        NSLog(firstName)
        NSLog(lastName)
        NSLog(headLine)
    }
    
    ///Popula os skills em um array
    static func getUserSkillsList() -> [String] {
        
        let table = SkillTable.getSkillTable()
        var list = [String]()
        
        for i in 0...(table.count - 1) {
            for j in 0...(table[i].skillList.count - 1) {
                if(table[i].skillList[j].valid) {
                    //list.append(table[i].categoryName + " - " + table[i].skillList[j].skill)
                    list.append(table[i].skillList[j].skill)
                }
            }
        }
        
        return list
    }
}
