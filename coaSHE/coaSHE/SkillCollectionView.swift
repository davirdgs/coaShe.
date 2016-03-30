//
//  SkillCollectionView.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 01/01/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "skillCell"

class SkillCollectionView: UICollectionViewController {
    
    var categoryId: Int = 0
    var table = SkillTable.getSkillTable()

    //Variável que armazena o super tema para fazermos a query no Parse.
    var superTema = ""
    
    //Variável que armazena a lista de subtemas da super categoria.
    var subjectList = []
    
    //Vetor que guarda variáveis auxiliares para garantir que não serão feitas várias requisições para o Parse caso o usuário fique clicando e desclicando um tema.
    var clickedArray:NSMutableArray = []
    
    //outlet da collection view
    @IBOutlet var collectionViewOutlet: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Carrega os subtemas relativos ao supertema.
        ParseAuxiliarMethods.sharedInstance.retrieveAllFromClass("Subjects", queryParameter: "bigTema", queryKey: self.superTema, sortingParameter: nil, ascendingOrder: nil, completion: { (retrieveObjects) -> Void in
            if retrieveObjects != nil {
                self.subjectList = retrieveObjects!
                self.collectionViewOutlet.reloadData()
                
                for _ in 0 ... (self.subjectList.count - 1) {
                    self.clickedArray.insertObject(0, atIndex: 0)
                }
                
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Retorna quantos elementos foram obtidos para a categoria do Parse
        return self.subjectList.count
        
        //return self.table[self.categoryId].skillList.count
        
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! skillView
        
        //Pegando do Parse!
        cell.label.text = (self.subjectList[indexPath.row].valueForKey("subject")) as? String
        let imageName = self.subjectList[indexPath.row].valueForKey("backgroundImageName") as? String
        cell.imageView.image = UIImage(named: imageName!)
        
        //Pegando do proprio celular \/
        //cell.label.text = self.table[self.categoryId].skillList[indexPath.row].skill
        //cell.imageView.image = UIImage(named: self.table[categoryId].skillList[indexPath.row].imageName)

        cell.backView.layer.cornerRadius = cell.layer.frame.height/6
        
        if(table[self.categoryId].skillList[indexPath.row].valid) {
            cell.imageView.alpha = 0.8//0.7
            cell.backView.alpha = 0.9
        } else {
            cell.imageView.alpha = 0.3//0.3
            cell.backView.alpha = 0.3
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return Styles.sectionInserts
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width - (Styles.sectionInserts.left + Styles.sectionInserts.right), height: self.view.frame.height/5)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.table[self.categoryId].skillList[indexPath.row].valid = !self.table[self.categoryId].skillList[indexPath.row].valid
        //Verifica se a célula ainda não foi clicada, evitando requisições desnecessárias ao parse.
        if ((self.table[self.categoryId].skillList[indexPath.row].valid == false)&&(clickedArray[indexPath.row] as! NSObject == 0)&&(PFUser.currentUser() != nil)) {
            let coashes = self.subjectList[indexPath.row].objectForKey("coaShes") as! [String]
            let userId = PFUser.currentUser()?.valueForKey("objectId") as! String
            let new_coashes_array: NSMutableArray = []
            //Passa por todos os coachs do subject clicado, verificando se o User é um coach.
            for coach in coashes {
                if (strcmp(coach, userId) != 0) {
                    new_coashes_array.insertObject(coach, atIndex: 0)
                }
            }
            self.subjectList[indexPath.row].setObject(new_coashes_array, forKey: "coaShes")
            self.subjectList[indexPath.row].saveInBackground()
            self.clickedArray[indexPath.row] = 1
        }
        
        self.collectionView?.reloadData()
        
    }
    

}
