//
//  LoginScreen_ViewController.swift
//  coaSHE
//
//  Created by Carolina Bonturi on 11/24/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit
import Parse

class LoginScreen_ViewController: UIViewController {
    
    var jaTemConta: Bool = false

    // MARK: Outlets
    
    @IBOutlet weak var backgroundLoginScreen: UIImageView!
    
    //@IBOutlet weak var labelLoginScreen: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBAction func startPressed(sender: AnyObject) {
    }
    
    @IBOutlet weak var termsAndConditions: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = PFUser.currentUser()
        //PFUser.logOut()
        if (currentUser != nil) {
            
            //Faz a segue acontecer na thread principal.
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("loggedIn", sender: self)
            }
            
        }
        // Do any additional setup after loading the view.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button action
    
    @IBAction func startPressedHandler(sender: AnyObject) {
        
        performSegueWithIdentifier("loggedIn", sender: self)
        // TODO: condicional para tabbar
    }
    
    @IBAction func alreadyRegisteredHandler(sender: AnyObject) {
        self.jaTemConta = true
        self.performSegueWithIdentifier("loggedIn", sender: self)
    }
    
    @IBAction func termsAndConditionsHaldler(sender: AnyObject) {
        performSegueWithIdentifier("toTerms", sender: self)
    }

    @IBAction func returnToLoginScreen(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "loggedIn" && self.jaTemConta) {
            let vc = segue.destinationViewController as! TabBarController
            vc.jaTemConta = true
        }
    }
    
}
