//
//  ProfileView2ViewController.swift
//  coaSHE
//
//  Created by Sidney Orlovski Nogueira on 1/20/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit
import Parse

class ProfileView2ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var disponibilidade = NSArray()
    
    @IBOutlet weak var botaoDisponibilidade: UIButton!
    
    //Essa variável dirá se devemos pegar os dados diretamente do usuário ou é de um outro usuário
    var isFromSelf = false
    
    //Essa variável terá os dados que devem preencher os dados da tela, caso não seja do próprio usuário.
    var coaShe_data: String = ""
    
    //Essa variável terá as infos que vão preencher os dados na tela de
    let defaults = NSUserDefaults.standardUserDefaults()
    var list = UserProfileInfo.getUserSkillsList()
    
    // Vai guardar o facetime do cidadão.
    var facetime = ""
    // - MARK: Outlets
    
    //ActivityIndicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    //Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var resumeLabel: UILabel!
    
    //Profile Image
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    //TextField
    @IBOutlet weak var textField: UITextView!
    
    //Views
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var queroUmCoaSheView: UIView!
    
    //Buttons
    @IBOutlet weak var queroUmcoaShe: UIButton!
    //@IBOutlet weak var logout: UIButton!
    
    //Variável que decide se devemos ir direto para as configurações (caso o usuário não esteja logado, por exemplo).
    var goConfig: Bool = false
    
    override func viewWillDisappear(animated: Bool) {
        self.textField.disableAligment()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicatorView.alpha = 0.5
        self.activityIndicatorView.layer.cornerRadius = self.activityIndicatorView.frame.height/4
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        self.botaoDisponibilidade.backgroundColor = Styles.salmaoApoio
        self.botaoDisponibilidade.layer.cornerRadius = 5
        self.botaoDisponibilidade.clipsToBounds = true
        
        // Se não é o próprio perfil
        if (isFromSelf == false) {
            //self.navigationItem.setLeftBarButtonItem(nil, animated: true)
            queroUmcoaShe.layer.cornerRadius = 5
            queroUmcoaShe.clipsToBounds = true
        } else {// Se é o próprio perfil, esconde a barra com o botão que liga com o facetime.
            queroUmCoaSheView.hidden = true
            self.botaoDisponibilidade.hidden = true
        }
        
        queroUmcoaShe.layer.cornerRadius = 5
        queroUmcoaShe.clipsToBounds = true
        
        profileView.layer.borderWidth = 0.3
        collectionView.layer.borderWidth = 0.3
        view.layer.borderWidth = 0.3
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if(goConfig) {
            performSegueWithIdentifier("editProfile", sender: self)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        textField.alignToTop()
        
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = super.view.frame.height * 1/22
        profileImageView.clipsToBounds = true

        self.list = UserProfileInfo.getUserSkillsList()
        self.collectionView.reloadData()
        if (isFromSelf == false) {
            
            self.startActivityIndicator()
            
            let query = PFQuery(className: "_User")
            query.whereKey("objectId", equalTo: coaShe_data)
            query.includeKey("user_profile")
            query.includeKey("user_competencias")
            query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    let user_profile = object!["user_profile"] as! PFObject
                    self.nameLabel.text = user_profile.objectForKey("nome") as? String
                    self.headLineLabel.text = user_profile.objectForKey("titulo_profissional") as? String
                    self.facetime = (user_profile.objectForKey("facetime") as? String)!
                    //Carrega a imagem do parse e coloca no lugar adequado :D
                    let userImageFile = user_profile["foto"] as? PFFile
                    if (userImageFile != nil) {
                        userImageFile!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                            if (error == nil) {
                                if let imageData = imageData {
                                    let image = UIImage(data: imageData)
                                    self.profileImageView.image = image
                                }
                            }
                        })
                    }
                    self.textField.text = user_profile.objectForKey("resumo") as? String
                    
                    //Carregando as especialidades do Parse.
                    let user_competencias = object!["user_competencias"] as! PFObject
                    
                    //Array com os ponteiros para as competencias do usuário.
                    let user_competencias_list = user_competencias.objectForKey("competencias") as! NSArray
                    
                    
                    //Salva os ids das especialidades do usuário em uma lista, para carregarmos do parse.
                    let lista = NSMutableArray()
                    
                    for i in 0 ... (user_competencias_list.count - 1) {
                        lista.insertObject((user_competencias_list[i].valueForKey("objectId") as! String), atIndex: 0)
                    }
                    
                    //Busca no parse as especialidades.
                    let query2 = PFQuery(className: "Subjects")
                    query2.whereKey("objectId", containedIn: lista as [AnyObject])
                    query2.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                        if (error == nil) {
                            //TODO: caca aqui
                            self.list.removeAll()
                            
                            for result in results! {
                                self.list.append(result.valueForKey("subject") as! String)
                                self.collectionView.reloadData()
                                
                                self.stopActivityIndicator()
                            }
                        } else {
                            //TODO: CATH DO ERROR
                        }
                    })
                    
                    // MARK: disponibilidade
                    self.disponibilidade = user_competencias.objectForKey("disponibilidade") as! NSArray
                    
                } else {
                    print("Aqui está o erro:::\(error)")
                }
            }
            
            
        } else if (!goConfig) {
            
            self.startActivityIndicator()
            
            //Id do usuário logado agora
            let userId = PFUser.currentUser()!.valueForKey("objectId") as! String
            
            let query = PFQuery(className: "_User")
            query.whereKey("objectId", equalTo: userId)
            query.includeKey("user_profile")
            query.includeKey("user_competencias")
            query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    let user_profile = object!["user_profile"] as! PFObject
                    self.nameLabel.text = user_profile.objectForKey("nome") as? String
                    self.headLineLabel.text = user_profile.objectForKey("titulo_profissional") as? String
                    self.facetime = (user_profile.objectForKey("facetime") as? String)!
                    //Carrega a imagem do parse e coloca no lugar adequado :D
                    let userImageFile = user_profile["foto"] as? PFFile
                    if (userImageFile != nil) {
                        userImageFile!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                            if (error == nil) {
                                if let imageData = imageData {
                                    let image = UIImage(data: imageData)
                                    self.profileImageView.image = image
                                }
                            }
                        })
                    }
                    self.textField.text = user_profile.objectForKey("resumo") as? String
                    
                    //Carregando as especialidades do Parse.
                    let user_competencias = object!["user_competencias"] as! PFObject
                    //Array com os ponteiros para as competencias do usuário.
                    let user_competencias_list = user_competencias.objectForKey("competencias") as! NSArray
                    
                    self.list.removeAll()
                    for i in 0 ... (user_competencias_list.count - 1) {
                        self.list.append(user_competencias_list[i].objectForKey("subject") as! String)
                        
                    }
                    
                    self.collectionView.reloadData()
                    
                    self.stopActivityIndicator()
                    
                } else {
                    print(error)
                }
            }
            
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField.setContentOffset(CGPointZero, animated: false)
    }
    
    // MARK: CollectionView
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! skillView
        
        cell.label.text = self.list[indexPath.row]
        //cell.imageView.image = UIImage(named: "desk1")
        cell.imageView.alpha = 0.5
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20,
            height: (collectionView.frame.height-20)/8)//7/24)
    }
    
    // - MARK: Button actions
    
    //Função que faz a ligação no facetime. Só faz se não for o perfil do próprio usuário.
    @IBAction func queroUmCoashe(sender: AnyObject) {
        
        if(ScheduleController.validTime(self.disponibilidade)) {
            let call = "facetime://\(facetime)"
            if (PFUser.currentUser() != nil) {
                
                let alert = UIAlertController(title: "Mentora disponivel!", message: "Iniciar chamada de video?", preferredStyle: UIAlertControllerStyle.Alert)
                let coaSheAction = UIAlertAction(title: "Iniciar", style: .Default) {(action) in
                    if let facetimeURL:NSURL = NSURL(string:call) {
                        let application:UIApplication = UIApplication.sharedApplication()
                        if (application.canOpenURL(facetimeURL)) {
                            application.openURL(facetimeURL);
                        }
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancelar", style: .Default) {(action) in
                    
                }
                alert.addAction(coaSheAction)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: { () -> Void in
                })
                
            } else {
                let alert = UIAlertController(title: "Ops!", message: "Você precisa estar Logada!", preferredStyle: UIAlertControllerStyle.Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                }
                alert.addAction(OKAction)
                self.presentViewController(alert, animated: false, completion: { () -> Void in
                    
                })
            }
        } else {
            let alert = UIAlertController(title: "Mentora indisponível", message: "Verifique a disponibilidade de horários antes de fazer uma chamada", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
            }
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: { () -> Void in
                
            })
        }
        
    }
    
    
    @IBAction func logoutHandler(sender: AnyObject) {
        defaults.setInteger(1, forKey: "gogoSubjects")
        
        //self.textField.disableAligment()
        PFUser.logOut()
        Status.loggedIn = false
        
        performSegueWithIdentifier("unwindToSignIn", sender: self)
        
    }
    
    @IBAction func returnToProfile(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "unwindToSignIn") {
            let vc = segue.destinationViewController as! SignInView
            vc.unwind = true
            vc.pass = false
        } else if(segue.identifier == "toDisponibilidade") {
            let vc = segue.destinationViewController as! DisponibilidadeView
            vc.disponibilidade = self.disponibilidade
            
        }
    }
    
    func startActivityIndicator() {
        //Activity indicator
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        self.activityIndicatorView.hidden = false
        
        self.queroUmcoaShe.enabled = false
        self.botaoDisponibilidade.enabled = false
    }
    
    func stopActivityIndicator() {
        //Activity indicator
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
        self.activityIndicatorView.hidden = true
        
        self.queroUmcoaShe.enabled = true
        self.botaoDisponibilidade.enabled = true
    }
    
}

//
extension UITextView {
    func alignToTop() {
        self.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        self.contentOffset = CGPointMake(0.0, 0.0)
    }
    
    func disableAligment() {
        self.removeObserver(self, forKeyPath: "contentSize")
    }
    
}



