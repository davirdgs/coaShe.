//
//  EditProfile2View.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 04/12/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit
import CoreImage
import MobileCoreServices
import Parse

class EditProfile2View: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    var keyboard: CGSize = CGSize(width: 0, height: 0)
    var mediaUI = UIImagePickerController()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // - MARK: Outlets
    
    @IBOutlet weak var stackView: UIStackView!
    //@IBOutlet weak var collectionView: UICollectionView!
    
    // - MARK: Buttons
    
    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    //@IBOutlet weak var addButton: UIButton!
    
    // - MARK:
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // - MARK: Tap gestures outlets
    
    @IBOutlet var imageGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var summaryGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var skillsGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var scheduleGestureRecognizer: UITapGestureRecognizer!
    
    // - MARK: Text fields
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var headLineTextField: UITextField!
    
    //Lista de especialidades dos usuários que vamos salvar no Parse.
    var list = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Activity indicator
        self.activityIndicatorView.alpha = 0.5
        self.activityIndicatorView.layer.cornerRadius = self.activityIndicatorView.frame.height/4
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        imageView.layer.cornerRadius = self.view.frame.height * 5/154
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        
        nameTextField.delegate = self
        userTextField.delegate = self
        phoneTextField.delegate = self
        passTextField.delegate = self
        mailTextField.delegate = self
        headLineTextField.delegate = self
        
        phoneTextField.keyboardType = UIKeyboardType.NumberPad
        mailTextField.keyboardType = UIKeyboardType.EmailAddress
        
        
        mediaUI.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        stopActivityIndicator()
        
        //
        self.imageView.image = UserProfileInfo.profileImage
        
        if(defaults.objectForKey("time") != nil) {
            Schedule.arrayToTime(defaults.objectForKey("time") as! NSArray)
        }
        
        self.registerForKeyboardNotifications()
        summaryLabel.text = UserProfileInfo.summary
        //Pega a lista de skills do usuário.
        self.list = UserProfileInfo.getUserSkillsList()
        
        if(PFUser.currentUser() == nil) {
            userTextField.userInteractionEnabled = true
        } else {
            userTextField.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5)
            passTextField.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5)
            userTextField.userInteractionEnabled = false
            passTextField.userInteractionEnabled = false
            let query = PFQuery(className: "_User")
            query.whereKey("objectId", equalTo: PFUser.currentUser()?.valueForKey("objectId") as! String)
            query.includeKey("user_profile")
            query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                //Pega o usuário, e verifica se não tem erro.
                if (error == nil) {
                    let user_profile = object?.objectForKey("user_profile")
                    self.nameTextField.text = user_profile!.valueForKey("nome") as? String
                    self.userTextField.text = object!.valueForKey("username") as? String
                    self.phoneTextField.text = user_profile!.valueForKey("Telefone") as? String
                    self.passTextField.text = "********"
                    self.mailTextField.text = user_profile!.valueForKey("facetime") as? String
                    self.headLineTextField.text = user_profile!.valueForKey("titulo_profissional") as? String
                    self.summaryLabel.text = user_profile!.valueForKey("resumo") as? String
                }
            })
            
            
        }
        
        summaryLabel.text = UserProfileInfo.summary
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Button handlers
    
    @IBAction func okButtonHandler(sender: AnyObject) {
        
        //Activity indicator
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        self.activityIndicatorView.hidden = false
        
        UserProfileInfo.profileImage = imageView.image
        UserProfileInfo.name = nameTextField.text!
        UserProfileInfo.username = userTextField.text!
        UserProfileInfo.phoneNumber = phoneTextField.text!
        UserProfileInfo.password = passTextField.text!
        UserProfileInfo.email = mailTextField.text!
        UserProfileInfo.headLine = headLineTextField.text!
        UserProfileInfo.summary = summaryLabel.text!
        
        if(!self.checkFields()) {
            
        }
         else if let navController = self.navigationController {
            //Pega o usuário atual, para saber se está ou não logado.
            let user = PFUser.currentUser()
            //Cria o usuário no parse, caso nenhum usuários esteja logado!!
            if (user == nil) {
                ParseAuxiliarMethods.sharedInstance.createNewUser(UserProfileInfo.name, foto: UserProfileInfo.profileImage, titulo_profissional: UserProfileInfo.headLine, localizacao: nil, resumo: self.summaryLabel.text, username: UserProfileInfo.username, password: UserProfileInfo.password, facetime: UserProfileInfo.email, telefone: UserProfileInfo.phoneNumber, completion: { (code) -> Void in
                    
                    //Caso o username já tenha sido escolhido...
                    if (code == 202 && PFUser.currentUser() == nil) {
                        let alertController = UIAlertController(title: "Username", message: "Esse username já foi escolhido", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        self.userTextField.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.5)
                        
                        self.stopActivityIndicator()
                        
                    } else if (code == 0) {
                        let list = UserProfileInfo.getUserSkillsList()
                        
                        //Id do usuário
                        let userId = PFUser.currentUser()!.valueForKey("objectId") as! String
                        
                        //Cria a query para a classe de users.
                        let query = PFQuery(className: "_User")
                        
                        //Define que queremos fazer a query do proprio usuário, setando como parametro a key dele.
                        query.whereKey("objectId", equalTo: userId)
                        //Diz que queremos o objeto user_competencias do usuário também.
                        query.includeKey("user_competencias")
                        //pega o primeiro objeto com o id do usuário (que é obviamente o único resultado).
                        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                            if error == nil {//Caso não tenhamos erro.
                                //Carregando as especialidades do Parse.
                                let user_competencias = object!["user_competencias"] as! PFObject
                                user_competencias.setObject(SkillTable.convertTableToArray(), forKey: "competencias_defaults")
                                //Salvando a disponibilidade no Parse.
                                let schedule = Schedule.timeToArray()
                                user_competencias.setObject(schedule, forKey: "disponibilidade")
                                
                                //Pegamos os Ids de todos os temas do list.
                                let idsQuery = PFQuery(className: "Subjects")
                                idsQuery.whereKey("subject", containedIn: list as [String])
                                idsQuery.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
                                    if error == nil { //Caso tenha conseguido fazer a query.
                                        if (result != nil) {//Caso tenha resultados
                                            //result ja tem um vetor com os Subjects retornados.
                                            //Salva esse vetor nas competencias do usuário.
                                            user_competencias.setObject(result!, forKey: "competencias")
                                            user_competencias.saveInBackgroundWithBlock({ (succeded, error) -> Void in
                                                if (succeded == true) {
                                                    //Vamos agora salvar nas competencias adequadas o ID do usuário como um coaShe.
                                                    for resultado in result! { //Para cada resultado, atualizamos o vetor com os ids dos coashes e salvamos no Parse.
                                                        let subject_coaShes = resultado.objectForKey("coaShes") as! NSArray
                                                        var mentor = false
                                                        //Para cada coaShe, vamos ver se o usuário já é um coaShe no tema.
                                                        for i in 0 ... (subject_coaShes.count - 1) {
                                                            //Se o usuário já for mentor para esse tema, não vamos adicioná-lo novamente.
                                                            if (strcmp ((subject_coaShes[i] as! String), userId) == 0) {
                                                                mentor = true
                                                            }
                                                        }
                                                        if (mentor == false) {
                                                            let subject_coaShes_new = subject_coaShes.arrayByAddingObject(userId)
                                                            //Seta o novo usuário como mentor
                                                            resultado.setObject(subject_coaShes_new, forKey: "coaShes")
                                                            //Seta a nova quantidade de coaShes :D
                                                            resultado.setValue(subject_coaShes_new.count, forKey: "coachs")
                                                            resultado.saveInBackground()
                                                        }
                                                    }
                                                    
                                                } else {
                                                    //TODO: Catch do error
                                                }
                                            })
                                            
                                            
                                            
                                        }
                                        
                                    }
                                })
                                
                            } else {
                                print(error)
                            }
                        }
                        
                        navController.popViewControllerAnimated(false)
                    }
                    
                    
                    
                })
                
            } else { //Caso o usuário já esteja logado, não criando uma nova conta, vamos apenas atualizar as infos.
                //Busca o usuário e inclui o User_Profile
                print ("Usuária logada")
                //Id do usuário
                let userId = PFUser.currentUser()!.valueForKey("objectId") as! String
                
                //Cria a query para a classe de users.
                let query = PFQuery(className: "_User")
                
                //Define que queremos fazer a query do proprio usuário, setando como parametro a key dele.
                query.whereKey("objectId", equalTo: userId)
                //Diz que queremos o objeto user_competencias do usuário também.
                query.includeKey("user_competencias")
                query.includeKey("user_profile")
                //pega o primeiro objeto com o id do usuário (que é obviamente o único resultado).
                query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                    if error == nil {//Caso não tenhamos erro.
                        print ("Usuário resgatado")
                        let user_profile = object!["user_profile"] as! PFObject
                        user_profile.setValue(self.headLineTextField.text, forKey: "titulo_profissional")
                        user_profile.setValue(self.phoneTextField.text, forKey: "facetime")
                        user_profile.setValue(self.summaryLabel.text, forKey: "resumo")
                        user_profile.setValue(self.nameTextField.text, forKey: "nome")
                        user_profile.setValue(self.phoneTextField.text, forKey: "Telefone")
                        if (UserProfileInfo.profileImage != nil) {
                            let imageData = UIImagePNGRepresentation((UserProfileInfo.profileImage)!)
                            let imageFile = PFFile(name: "image.png", data: imageData!)
                            user_profile.setValue(imageFile, forKey: "foto")
                        }
                        user_profile.saveInBackground()
                        //Carregando as especialidades do Parse.
                        let user_competencias = object!["user_competencias"] as! PFObject
                        //Setar o array que fica no userDefaults
                        user_competencias.setObject(SkillTable.convertTableToArray(), forKey: "competencias_defaults")
                        //Salvando a disponibilidade no Parse.
                        let schedule = Schedule.timeToArray()
                        user_competencias.setObject(schedule, forKey: "disponibilidade")
                        //Setar o novo array de competencias (pega do parse a lista de subjects que ele marcou).
                        //Pegamos os Ids de todos os temas do list.
                        let idsQuery = PFQuery(className: "Subjects")
                        print("LISTA DE USUÁRIOS: \(self.list)")
                        idsQuery.whereKey("subject", containedIn: self.list as! [String])
                        idsQuery.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
                            if error == nil { //Caso tenha conseguido fazer a query.
                                if (result != nil) {//Caso tenha resultados
                                    //result ja tem um vetor com os Subjects retornados.
                                    //Salva esse vetor nas competencias do usuário.
                                    user_competencias.setObject(result!, forKey: "competencias")
                                    user_competencias.saveInBackgroundWithBlock({ (succeded, error) -> Void in
                                        if (succeded == true) {
                                            //Sucesso!
                                            //Vamos agora salvar nas competencias adequadas o ID do usuário como um coaShe.
                                            for resultado in result! { //Para cada resultado, atualizamos o vetor com os ids dos coashes e salvamos no Parse.
                                                let subject_coaShes = resultado.objectForKey("coaShes") as! NSArray
                                                var mentor = false
                                                //Para cada coaShe, vamos ver se o usuário já é um coaShe no tema.
                                                for i in 0 ... (subject_coaShes.count - 1) {
                                                    //Se o usuário já for mentor para esse tema, não vamos adicioná-lo novamente.
                                                    if (strcmp ((subject_coaShes[i] as! String), userId) == 0) {
                                                        mentor = true
                                                    }
                                                }
                                                if (mentor == false) {
                                                    let subject_coaShes_new = subject_coaShes.arrayByAddingObject(userId)
                                                    //Seta o novo usuário como mentor
                                                    resultado.setObject(subject_coaShes_new, forKey: "coaShes")
                                                    //Seta a nova quantidade de coaShes :D
                                                    resultado.setValue(subject_coaShes_new.count, forKey: "coachs")
                                                    resultado.saveInBackground()
                                                }
                                            }
                                            navController.popViewControllerAnimated(false)
                                        } else {
                                            //TODO: Catch do error
                                            print(error)
                                        }
                                    })
                                } else {
                                    print ("No results")
                                }
                            } else {
                                print (error)
                            }
                        })
                        
                    } else {
                        print(error)
                    }
                }
            }
    }
    
}
    
    @IBAction func cancelButtonHandler(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToProfile", sender: self)
    }

// MARK: Keyboard

func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.nameTextField.resignFirstResponder()
    self.passTextField.resignFirstResponder()
    self.userTextField.resignFirstResponder()
    self.phoneTextField.resignFirstResponder()
    self.mailTextField.resignFirstResponder()
    self.headLineTextField.resignFirstResponder()
    return true
}


func registerForKeyboardNotifications() {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self,
        selector: #selector(EditProfile2View.keyboardWillBeShown(_:)),
        name: UIKeyboardWillShowNotification,
        object: nil)
    notificationCenter.addObserver(self,
        selector: #selector(EditProfile2View.keyboardWillBeHidden(_:)),
        name: UIKeyboardWillHideNotification,
        object: nil)
}

// Called when the UIKeyboardDidShowNotification is sent.
func keyboardWillBeShown(sender: NSNotification) {
    let info: NSDictionary = sender.userInfo!
    let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
    let keyboardSize: CGSize = value.CGRectValue().size
    
    self.keyboard = keyboardSize
    if(headLineTextField.isFirstResponder()) {
        self.view.center.y -= keyboardSize.height
    }
    
}

// Cawlled when the UIKeyboardWillHideNotification is sent
func keyboardWillBeHidden(sender: NSNotification) {
    UserProfileInfo.profileImage = imageView.image
    UserProfileInfo.name = nameTextField.text!
    UserProfileInfo.username = userTextField.text!
    UserProfileInfo.phoneNumber = phoneTextField.text!
    UserProfileInfo.password = passTextField.text!
    UserProfileInfo.email = mailTextField.text!
    UserProfileInfo.headLine = headLineTextField.text!
    UserProfileInfo.summary = summaryLabel.text!
    if(headLineTextField.isFirstResponder()) {
        self.view.center.y += self.keyboard.height
    }
}

//MARK: Tap Gestures Actions

@IBAction func imageGestureHandler(sender: AnyObject) {
    
    mediaUI.mediaTypes = [kUTTypeImage as String];
    mediaUI.sourceType = UIImagePickerControllerSourceType.Camera;
    mediaUI.showsCameraControls = true
    mediaUI.allowsEditing = true;
    mediaUI.cameraCaptureMode = .Photo
    
    self.presentViewController(mediaUI, animated: true, completion: nil)
}

@IBAction func summaryGestureHandler(sender: AnyObject) {
    self.headLineTextField.resignFirstResponder()
    performSegueWithIdentifier("summaryEdit", sender: self)
}

func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    
    UserProfileInfo.profileImage = image
    self.imageView.image = image
    self.dismissViewControllerAnimated(true, completion: nil)
}

@IBAction func skillsGestureRecognizerHandler(sender: AnyObject) {
    self.performSegueWithIdentifier("toCategorySkill", sender: self)
}

@IBAction func scheduleGRHandler(sender: AnyObject) {
    self.performSegueWithIdentifier("toSchedule", sender: self)
}

@IBAction func returnToEdit(segue: UIStoryboardSegue) {
    
}
    
    ///Pinta o campo faltante de vermelho
    func paintTextFields(textField: UITextField) {
        self.nameTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.userTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.phoneTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.passTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.mailTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        textField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func paintUserAndPass() {
        self.nameTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.userTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.phoneTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.passTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.mailTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    ///Verifica se uma string eh um email valido
    func isValidEmail(str: String) -> Bool {
        /*
        print("validate emilId: \(str)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(str)
        
        return result*/
        return true
    }
    
    ///Verifica se todos os campos estão preenchidos
    func checkFields() -> Bool {
        
        if(UserProfileInfo.name == "") {
            let alertController = UIAlertController(title: "Nome", message: "Insira seu nome", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            self.paintTextFields(self.nameTextField)
            self.stopActivityIndicator()
            return false
            
        } else if(UserProfileInfo.username == "") {
            let alertController = UIAlertController(title: "Usuário", message: "Insira seu username", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            self.paintTextFields(self.userTextField)
            self.stopActivityIndicator()
            return false
            
        } else if (strlen(UserProfileInfo.username) < 4 || strlen(UserProfileInfo.password) < 4) {
            let alertController = UIAlertController(title: "Usuário", message: "O usuário e a senha precisam ter pelo menos 4 caracteres!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            self.paintUserAndPass()
            self.stopActivityIndicator()
            return false
            
        } else if(UserProfileInfo.phoneNumber == "") {
            let alertController = UIAlertController(title: "Telefone", message: "Insira seu número de telefone", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            self.paintTextFields(self.phoneTextField)
            self.stopActivityIndicator()
            return false
            
        } else if (UserProfileInfo.password == "") {
            let alertController = UIAlertController(title: "Senha", message: "Insira sua senha", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            self.paintTextFields(self.passTextField)
            self.stopActivityIndicator()
            return false
            
        } else if(UserProfileInfo.email == "") {
            let alertController = UIAlertController(title: "E-mail", message: "Insira seu e-mail", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            self.paintTextFields(self.mailTextField)
            self.stopActivityIndicator()
            return false
            
        } else if (strlen(UserProfileInfo.username) < 4) {
            let alertController = UIAlertController(title: "Username", message: "O usuário e a senha precisam ter pelo menos 4 caracteres!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            self.paintUserAndPass()
            self.stopActivityIndicator()

            return false
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "unwindToProfile" && PFUser.currentUser() == nil) {
            let vc = segue.destinationViewController as! ProfileView
            vc.unwind = true
        }
    }
    
    private func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
        self.activityIndicatorView.hidden = true
    }
    
}





