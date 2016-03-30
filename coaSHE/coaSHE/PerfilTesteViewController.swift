//
//  PerfilTesteViewController.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 11/03/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class PerfilTesteViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var topView: UIView!

    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    
    @IBOutlet weak var purpleView: UIView!
    
    @IBOutlet weak var pictureBackView: UIImageView!
    
    @IBOutlet weak var centerPictureView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var disponibilidadeView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var queroUmCoashe: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.purpleView.backgroundColor = Styles.roxoCoashe
        self.purpleView.alpha = 0.7
        
        pictureBackView.alpha = 0.4
        
        segControl.tintColor = Styles.azulEscuro
        segControl.layer.cornerRadius = segControl.layer.frame.height/2
        segControl.layer.borderWidth = 1
        segControl.layer.borderColor = Styles.azulEscuro.CGColor
        segControl.layer.masksToBounds = true
        
        centerPictureView.layer.cornerRadius = centerPictureView.layer.frame.height/2
        centerPictureView.layer.masksToBounds = true
        
        textView.hidden = false
        disponibilidadeView.hidden = true
        skillsCollectionView.hidden = true
        
        queroUmCoashe.backgroundColor = Styles.verdeCoashe
        queroUmCoashe.layer.cornerRadius = queroUmCoashe.layer.frame.height/4
        queroUmCoashe.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func segControlHandler(sender: AnyObject) {
        
        if(segControl.selectedSegmentIndex == 0) {
            textView.hidden = false
            disponibilidadeView.hidden = true
            skillsCollectionView.hidden = true
            
        } else if(segControl.selectedSegmentIndex == 1) {
            textView.hidden = true
            disponibilidadeView.hidden = true
            skillsCollectionView.hidden = false
            
        } else if(segControl.selectedSegmentIndex == 2) {
            textView.hidden = true
            disponibilidadeView.hidden = false
            skillsCollectionView.hidden = true
            
        }
        
    }
    

}


//@IBOutlet weak var scrollView: UIScrollView!

/*
override func viewDidLoad() {
super.viewDidLoad()
NSLog("0")

scrollView.opaque = false

scrollView.frame = view.bounds

//Container das imagens de perfil
let topProfile: UIView = NSBundle.mainBundle().loadNibNamed("ProfileImageView",
owner: self,
options: nil)[0] as! UIView

//topProfile.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height*3/8)

topProfile.drawRect(CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height*3/8))


scrollView.addSubview(topProfile)
scrollView.layoutIfNeeded()

scrollView.contentSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height)
scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)


}
*/