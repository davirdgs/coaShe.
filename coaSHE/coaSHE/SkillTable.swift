//
//  SkillTable.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 01/01/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class SkillTable: NSObject {

    private static var skillTable: [Category] = [Category]()
    
    static func setSkillTable() {
        self.skillTable = [
            Category(categoryName: "Carreira Acadêmica", image: "carreira acadêmica", skills: [
                Skill(initWithSkill: "Intercâmbio", image: "intercâmbio"),
                Skill(initWithSkill: "Preparação de Aulas", image: "preparação de aula"),
                Skill(initWithSkill: "Peer Review", image: "peer review")
                ]),
            Category(categoryName: "Desenvolvimento Pessoal", image: "desenvolvimento pessoal", skills: [
                Skill(initWithSkill: "Administração do Tempo", image: "clock"),
                Skill(initWithSkill: "Autoconhecimento", image: "sky"),
                Skill(initWithSkill: "Marketing Pessoal", image: "way"),
                Skill(initWithSkill: "Qualidade de Vida", image: "sky"),
                Skill(initWithSkill: "Liderança", image: "liderança"),
                Skill(initWithSkill: "Comunicação", image: "doctype"),
                Skill(initWithSkill: "Educação Fianceira", image: "educação financeira")
                ]),
            Category(categoryName: "Empreendedorismo", image: "empreendedorismo", skills: [
                Skill(initWithSkill: "Design Thinking", image: "design thinking"),
                Skill(initWithSkill: "Vendas", image: "desk3"),
                Skill(initWithSkill: "Lean Startup", image: "lean startup"),
                Skill(initWithSkill: "Modelo de Negócios", image: "sky"),
                Skill(initWithSkill: "Customer Development", image: "desk2"),
                Skill(initWithSkill: "Evaluation", image: "desk3")
                ]),
            Category(categoryName: "Mercado de Trabalho", image: "mercado de trabalho", skills: [
                Skill(initWithSkill: "Processo Seletivo", image: "processo seletivo"),
                Skill(initWithSkill: "Concurso Público", image: "concurso público"),
                Skill(initWithSkill: "Currículo", image: "curriculo_")
                ]),
            Category(categoryName: "Linguagem de Programação", image: "linguagem de programação", skills: [
                Skill(initWithSkill: "Java", image: "java"),
                Skill(initWithSkill: "Objective-C", image: "objective c"),
                Skill(initWithSkill: "Swift", image: "background1")
                ]),
            Category(categoryName: "Design", image: "design", skills: [
                Skill(initWithSkill: "Identidade Visual", image: "desk5"),
                Skill(initWithSkill: "Branding", image: "branding"),
                Skill(initWithSkill: "Photoshop", image: "photoshop"
                )
                ])
        ]
    }
    
    static func setSkillTable(table: [Category]) {
        self.skillTable = table
    }
    
    static func getSkillTable() -> [Category]{
        return self.skillTable
    }
    
    /// Coloca dados da skillTable em um NSArray
    static func convertTableToArray() -> NSArray {
        
        let mutableArray = NSMutableArray()
        
        mutableArray.addObject(skillTable.count)
        
        // [skillTable.count, categoryName, categoryImage, skillList.count, skill, image, valid ...]
        for i in 0...(skillTable.count-1) {
            mutableArray.addObject(skillTable[i].categoryName)
            mutableArray.addObject(skillTable[i].imageName)
            mutableArray.addObject(skillTable[i].skillList.count)
            for j in 0...(skillTable[i].skillList.count - 1) {
                mutableArray.addObject(skillTable[i].skillList[j].skill)
                mutableArray.addObject(skillTable[i].skillList[j].imageName)
                mutableArray.addObject(skillTable[i].skillList[j].valid)
            }
        }

        return mutableArray as NSArray
    }
    
    /// Converte o NSArray de skill na skillTable
    static func convertArrayToTable(array: NSArray) {
        var table = [Category]()
        
        //skillcount index
        var scIndex = 3
        for _ in 0...(array[0] as! Int - 1) {   //Numero de categorias
            var skillList = [Skill]()
            
            for j in 0...(array[scIndex] as! Int - 1) {
                let skill = Skill(initWithSkill: array[scIndex + 3*j + 1] as! String, image: array[scIndex + 3*j + 2] as! String)
                
                skill.valid = array[scIndex + 3*j + 3] as! Bool
                skillList.append(skill)
            }
            
            let cat = Category(categoryName: array[scIndex - 2] as! String, image: array[scIndex - 1] as! String, skills: skillList)
            
            //Atualiza scIndex
            //3*[i(n-1)] + i(n-1) + 3
            scIndex = scIndex + 3 + 3 * (array[scIndex] as! Int)
            
            table.append(cat)
        }
        setSkillTable(table)
    }
    
}
