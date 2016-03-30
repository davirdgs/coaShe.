//
//  CardCollectionViewCell.swift
//  coaSHE
//
//  Created by Sidney Orlovski Nogueira on 11/24/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    //Image View que deve conter a imagem do tema.
    @IBOutlet weak var subjectImage: UIImageView!
    //Label com o assunto específico
    @IBOutlet weak var subjectTitle_text: UILabel!
    //Label com o grande tema do assunto
    @IBOutlet weak var subjectClassLabel: UILabel!
    
    //Label que exibe o número de coachs disponíveis.
    @IBOutlet weak var coachsAvaiableLabel: UILabel!
    //Label que exibe o número de mentorias finalizadas.
    @IBOutlet weak var finishedMentoringLabel: UILabel!
    
    //Labels com textos estáticos. Outlets usados para alterar o tamanho da fonte
    @IBOutlet weak var coachsAvaiableText: UILabel!
    @IBOutlet weak var finishedMentoringText: UILabel!
    
    
}
