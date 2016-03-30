//
//  Styles.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 27/11/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit

class Styles: NSObject {
    
    // MARK: Cores
    static let roxoCoashe: UIColor = UIColor(red: 112/255, green: 78/255, blue: 175/255, alpha: 1)
    
    static let azulCoashe: UIColor = UIColor(red: 51/255, green: 115/255, blue: 244/255, alpha: 1)
    
    static let laranjaCoashe: UIColor = UIColor(red: 248/255, green: 162/255, blue: 75/255, alpha: 1)
    
    static let rosaCoashe: UIColor = UIColor(red: 233/255, green: 65/255, blue: 139/255, alpha: 1)
    
    static let verdeCoashe: UIColor = UIColor(red: 62/255, green: 184/255, blue: 145/255, alpha: 1)
    
    static let azulEscuro: UIColor = UIColor(red: 21/255, green: 65/255, blue: 212/255, alpha: 1)
    
    static let vermelhoCoashe: UIColor = UIColor(red: 243/255, green: 66/255, blue: 36/255, alpha: 1)
    
    static let salmaoApoio: UIColor = UIColor(red: 253/255, green: 164/255, blue: 134/255, alpha: 1)
    
    static let amareloApoio: UIColor = UIColor(red: 221/255, green: 209/255, blue: 109/255, alpha: 1)

    static let fontStyle = UIFont(descriptor: UIFontDescriptor(name: "Helvetica Light", size: 25.0), size: 25.0)
    
    static let redPattern = UIColor(patternImage: UIImage(named: "background_vermelho")!)
    static let greenPattern = UIColor(patternImage: UIImage(named: "background_verde")!)
    static let purplePattern = UIColor(patternImage: UIImage(named: "background_lilas")!)
    
    static let sectionInserts = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    static func getFont() -> UIFont {
        return fontStyle
    }
}
