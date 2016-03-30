//
//  AgendamentoView.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 18/01/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class AgendamentoView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: Constantes e variaveis
    let reuseIdentifier = "hourCell"
    let days: [String] = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
    let hours: [String] = ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"]
    var day: Int = 0
    
    // MARK: Buttons outlets
    
    @IBOutlet weak var nextDayButton: UIButton!
    @IBOutlet weak var backDayButton: UIButton!
    
    // MARK: Outlets
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayLabel.text = days[day]
        topView.backgroundColor = Styles.roxoCoashe
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        let time = Schedule.timeToArray()
        defaults.setObject(time, forKey: "time")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: CollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.hours.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AgendamentoCell
        
        cell.hourLabel.text = self.hours[indexPath.row]
        //
        cell.hourView.layer.cornerRadius = self.view.frame.height * 27.5/(2*667)
        
        if(Schedule.schedule[self.day].selectedHours[indexPath.row]) {
            cell.hourView.backgroundColor = Styles.azulCoashe
            cell.hourLabel.textColor = UIColor.whiteColor()
        } else {
            cell.hourView.backgroundColor = UIColor.whiteColor()
            cell.hourLabel.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {

            return Styles.sectionInserts
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width*9/10, height: self.view.frame.width/9)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        Schedule.schedule[self.day].selectedHours[indexPath.row] = !Schedule.schedule[self.day].selectedHours[indexPath.row]
        self.collectionView.reloadData()
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: Button handlers
    
    @IBAction func backDayButtonHandler(sender: AnyObject) {
        
        UIView.animateWithDuration(0.7, animations: {
            
            self.dayLabel.center.x -= self.dayLabel.bounds.width
            self.dayLabel.alpha = 0
            
            }, completion: {(finished: Bool) -> Void in
                self.day -= 1
                if(self.day < 0) {
                    self.day = self.days.count - 1
                }
                self.collectionView.reloadData()
                self.dayLabel.text = self.days[self.day]
                self.dayLabel.center.x += 2*self.dayLabel.bounds.width
                
                UIView.animateWithDuration(0.7, animations: {
                    self.dayLabel.center.x -= self.dayLabel.bounds.width
                    self.dayLabel.alpha = 1
                })
                
        })
         
    }
    
    @IBAction func nextDayButtonHandler(sender: AnyObject) {
        
        UIView.animateWithDuration(0.7, animations: {
            
            self.dayLabel.center.x += self.dayLabel.bounds.width
            self.dayLabel.alpha = 0
            
            }, completion: {(finished: Bool) -> Void in
                self.day += 1
                if(self.day > (self.days.count-1)) {
                    self.day = 0
                }
                self.collectionView.reloadData()
                self.dayLabel.text = self.days[self.day]
                self.dayLabel.center.x -= 2*self.dayLabel.bounds.width
                
                UIView.animateWithDuration(0.7, animations: {
                    self.dayLabel.center.x += self.dayLabel.bounds.width
                    self.dayLabel.alpha = 1
                })
                
        })
        
    }


}
