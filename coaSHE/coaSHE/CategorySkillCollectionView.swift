//
//  CategorySkillCollectionView.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 01/01/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "categoryCell"

class CategorySkillCollectionView: UICollectionViewController {
    
    let sectionInserts = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5.0)

    var categoryId: Int = 0
    
    var subjects = []
    
    var categoryClicked = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "toSkillsCollection") {
            let vc = segue.destinationViewController as! SkillCollectionView
            vc.categoryId = self.categoryId
            vc.superTema = self.categoryClicked
        }
        
    }
    
    // - MARK: UICollectionViewDataSource
    
    @IBAction func returnToCategory(segue: UIStoryboardSegue) {
        
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return SkillTable.getSkillTable().count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! skillView
        
        let table = SkillTable.getSkillTable()
        
        cell.backView.layer.cornerRadius = cell.layer.frame.height/6
        cell.backView.alpha = 0.9
        
        cell.label.text = table[indexPath.row].categoryName
        cell.imageView.image = UIImage(named: table[indexPath.row].imageName)
        //cell.imageView.image = UIImage(named: "background_verde")
        cell.imageView.alpha = 0.8
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return Styles.sectionInserts
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - (sectionInserts.left + sectionInserts.right), height: self.view.frame.height/5)
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let table = SkillTable.getSkillTable()
        self.categoryClicked = table[indexPath.row].categoryName
        self.categoryId = indexPath.row
    performSegueWithIdentifier("toSkillsCollection", sender: self)
        
        
    }

    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    


}
