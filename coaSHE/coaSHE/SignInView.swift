//
//  SignInView.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 16/11/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit
import Parse

class SignInView: UIViewController, UITextFieldDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var enterAnimate:Bool = false
    var goConfig: Bool = false
    var unwind: Bool = false
    var pass: Bool = false
    
    
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Buttons
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    //Textfields
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        
        if(PFUser.currentUser() != nil) {
            self.goConfig = false
            performSegueWithIdentifier("toEditProfile", sender: self)
        }
        
        if(pass) {
            performSegueWithIdentifier("toEditProfile", sender: self)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        Schedule.initTimeModel()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loginTextField.text = ""
        passTextField.text = ""
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicatorView.alpha = 0.5
        self.activityIndicatorView.layer.cornerRadius = self.activityIndicatorView.frame.height/4
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.activityIndicator.hidden = true
        self.activityIndicatorView.hidden = true
        

        //Set delegates
        loginTextField.delegate = self
        passTextField.delegate = self
        
        //Estilo da fonte
        enterButton.titleLabel?.font = Styles.fontStyle
        registerButton.titleLabel?.font = Styles.fontStyle

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func enterButtonHandler(sender: AnyObject) {
        
        //Activity indicator
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        self.activityIndicatorView.hidden = false
        
        // Send a request to login
        PFUser.logInWithUsernameInBackground(loginTextField.text!, password: passTextField.text!, block: { (user, error) -> Void in
            
            if ((user) != nil) {
                //Carrega as especialidades para o User defaults.
                let userId = PFUser.currentUser()?.valueForKey("objectId") as! String
                let query = PFQuery(className: "_User")
                query.whereKey("objectId", equalTo: userId)
                query.includeKey("user_competencias")
                query.includeKey("user_profile")
                query.getFirstObjectInBackgroundWithBlock({ (object, erro) -> Void in
                    if (erro == nil && object != nil) {
                        //Seta os campos
                        let user_competencias = object!["user_competencias"] as! PFObject
                        //let competencias_array = user_competencias.valueForKey("competencias")
                        
                        let user_profile = object!["user_profile"] as! PFObject
                        
                        UserProfileInfo.name = user_profile.valueForKey("nome") as! String
                        UserProfileInfo.email = user_profile.valueForKey("facetime") as! String
                        UserProfileInfo.headLine = user_profile.valueForKey("titulo_profissional") as! String
                        UserProfileInfo.username = (user?.valueForKey("username"))! as! String
                        UserProfileInfo.summary = user_profile.valueForKey("resumo") as! String
                        let phoneNumber = user_profile.valueForKey("resumo")
                        if (phoneNumber != nil) {
                            UserProfileInfo.phoneNumber = user_profile.valueForKey("resumo") as! String
                        }
                    SkillTable.convertArrayToTable(user_competencias.objectForKey("competencias_defaults") as! [NSObject])
                        Schedule.arrayToTime(user_competencias.objectForKey("disponibilidade") as! [NSObject])
                        //self.defaults.setObject(user_competencias.objectForKey("competencias_defaults") as! [String], forKey: "")
                        UserProfileDAO.persistUserInfo()
                        
                        self.performSegueWithIdentifier("toEditProfile", sender: self)
                        
                        /*
                        let alert = UIAlertController(title: "Sucesso!", message: "Você está Logada!", preferredStyle: UIAlertControllerStyle.Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                            self.goConfig = false
                            self.performSegueWithIdentifier("toEditProfile", sender: self)
                            self.enterAnimate = false
                        }
                        alert.addAction(OKAction)
                        self.presentViewController(alert, animated: true, completion: { () -> Void in
                            
                        })*/
                        
                        
                    } else {
                        print (object)
                        print (erro)
                        print("AEHOOOOO")
                    }
                })
                
            } else {
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.activityIndicatorView.hidden = true
                
                let alert = UIAlertController(title: "Ops!", message: "Usuária ou senha incorreta", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                    // ...
                    self.loginTextField.text = ""
                    self.passTextField.text = ""
                }
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: { () -> Void in
                    
                })
            }
        })
        
    }

    
    override func prepareForSegue(segue:
        UIStoryboardSegue, sender: AnyObject?) {
        
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            self.activityIndicatorView.hidden = true
            
        if (segue.identifier == "toEditProfile") {
            let vc = segue.destinationViewController as! ProfileView
            vc.isFromSelf = true
            vc.unwind = false
            if(self.goConfig) {
                vc.goConfig = self.goConfig
                
            }
        }
    }
    
    @IBAction func registerButtonHandler(sender: AnyObject) {
        
        
        let alert = UIAlertController(title: "Termos e Condições", message: "Ao se registrar você concorda com nossos termos e condições de uso.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let OKAction = UIAlertAction(title: "Concordo", style: .Default) { (action) in
            self.goConfig = true
            self.performSegueWithIdentifier("toEditProfile", sender: self)
        }
        let verTermos = UIAlertAction(title: "Ver Termos", style: .Default) { (aciton) in
            self.performSegueWithIdentifier("termsSegue", sender: self)
            }
        let cancel = UIAlertAction(title: "Cancelar", style: .Default) { (action) in
            
        }
        alert.addAction(OKAction)
        alert.addAction(verTermos)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: { () -> Void in
        })
        
        //self.goConfig = true
        //performSegueWithIdentifier("toEditProfile", sender: self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.loginTextField.resignFirstResponder()
        self.passTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func returnToSignIn(segue: UIStoryboardSegue) {
        
    }
    
}
