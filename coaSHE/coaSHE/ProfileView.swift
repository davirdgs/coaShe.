//
//  ProfileView.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 02/12/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit
import Parse

class ProfileView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var activityIndicatorView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var unwind: Bool = false
    
    // - MARK: Variáveis usadas para dados do parse
    
    
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
    
    //Navegation Bar
    //@IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var configButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var purpleView: UIView!
    
    
    //Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headLineLabel: UILabel!
    //@IBOutlet weak var resumeLabel: UILabel!
    
    //Profile Image
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var pictureBackView: UIImageView!
    //@IBOutlet weak var backProfileImageView: UIImageView!
    
    //TextField
    @IBOutlet weak var textField: UITextView!
    
    //Views
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topProfileView: UIView!
    //@IBOutlet weak var queroUmCoaSheView: UIView!
    @IBOutlet weak var disponibilidadeView: UIView!
    
    //Buttons
    @IBOutlet weak var queroUmcoaShe: UIButton!
    //@IBOutlet weak var logout: UIButton!
    
    //Disponidilidade view
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backDayButton: UIButton!
    @IBOutlet weak var nestDayButton: UIButton!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    //Variável que decide se devemos ir direto para as configurações (caso o usuário não esteja logado, por exemplo).
    var goConfig: Bool = false
    override func viewWillDisappear(animated: Bool) {
        self.textField.disableAligment()
    }
    
    override func viewDidAppear(animated: Bool) {
        if(self.unwind) {
            self.unwind = false
            performSegueWithIdentifier("unwindToSignIn", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        self.purpleView.backgroundColor = Styles.roxoCoashe
        self.purpleView.alpha = 0.7
        
        pictureBackView.alpha = 0.4
        
        segControl.tintColor = Styles.azulEscuro
        segControl.layer.cornerRadius = segControl.layer.frame.height/2
        segControl.layer.borderWidth = 1
        segControl.layer.borderColor = Styles.azulEscuro.CGColor
        segControl.layer.masksToBounds = true
        
        profileImageView.layer.cornerRadius = profileImageView.layer.frame.height/2
        profileImageView.layer.masksToBounds = true
        
        textField.hidden = false
        disponibilidadeView.hidden = true
        collectionView.hidden = true
        
        queroUmcoaShe.backgroundColor = Styles.verdeCoashe
        queroUmcoaShe.layer.cornerRadius = queroUmcoaShe.layer.frame.height/4
        queroUmcoaShe.layer.masksToBounds = true
        //
        
        self.startActivityIndicator()
        
        self.activityIndicatorView.alpha = 0.5
        self.activityIndicatorView.layer.cornerRadius = self.activityIndicatorView.frame.height/4
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        // Se não é o próprio perfil
        if (isFromSelf == true) {
            queroUmcoaShe.hidden = true
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if(goConfig) {
            performSegueWithIdentifier("editProfile", sender: self)
        }
        
        //Disponibilidade view
        self.topView.backgroundColor = Styles.roxoCoashe
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //print(PFUser.currentUser())
        textField.alignToTop()
        
        self.list = UserProfileInfo.getUserSkillsList()

        collectionView.reloadData()
        
        // Se não é o próprio perfil
        if (isFromSelf == false) {
            //Esconde o botão de editar o perfil, já que o usuário não pode editar um perfil que não o seu.
            //MARK: TODO
            self.navigationItem.rightBarButtonItem = nil
            
            //Esconde o botão de logOut, já que não podemos deslogar o perfil de outro usuário, ou mesmo deslogar o próprio perfil ao visualizar o perfil de outro usuário.
            //self.logoutButton.hidden = true
            
            
        } else {// Se é o próprio perfil, esconde a barra com o botão que liga com o facetime.
            self.queroUmcoaShe.hidden = true
            
            //Só carrega as especialidades do próprio usuário se estivermos carregando os perfis dele, oras.
            self.list = UserProfileInfo.getUserSkillsList()
            collectionView.reloadData()
        }
        
        self.list = UserProfileInfo.getUserSkillsList()
        self.collectionView.reloadData()
        
        if (isFromSelf == false) {
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
                                    UserProfileInfo.profileImage = image
                                }
                            }
                            self.stopActivityIndicator()
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
                    
                } else {
                    print("Aqui está o erro:::\(error)")
                }
            }

            
        } else if ((!goConfig || isFromSelf == true)&&(PFUser.currentUser() != nil)) {
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
                                    UserProfileInfo.profileImage = image
                                    
                                    self.stopActivityIndicator()
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
                    
                    
                } else {
                    print(error)
                }
            }
            
            
        }
    
    }
    
    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField.setContentOffset(CGPointZero, animated: false)
    }
*/
    // MARK: CollectionView
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        self.list = UserProfileInfo.getUserSkillsList()
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("skillCell", forIndexPath: indexPath) as! skillView
        
        cell.label.text = self.list[indexPath.row]
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
            height: (collectionView.frame.height-20)/8)
    }
    
    func startActivityIndicator() {
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        self.activityIndicatorView.hidden = false
        
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
        self.activityIndicatorView.hidden = true
        
    }
    
    // - MARK: Button actions
    
    @IBAction func configButtonHandler(sender: AnyObject) {
        self.isFromSelf = true
        self.performSegueWithIdentifier("editProfile", sender: self)
    }
    
    //Função que faz a ligação no facetime. Só faz se não for o perfil do próprio usuário.
    @IBAction func queroUmCoashe(sender: AnyObject) {
        let call = "facetime://\(facetime)"
        if let facetimeURL:NSURL = NSURL(string:call) {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(facetimeURL)) {
                application.openURL(facetimeURL);
            }
        }
        
    
    }
    
    
    @IBAction func logoutHandler(sender: AnyObject) {
        defaults.setInteger(1, forKey: "gogoSubjects")
        
        //self.textField.disableAligment()
        UserProfileInfo.name = ""
        UserProfileInfo.email = ""
        UserProfileInfo.headLine = ""
        UserProfileInfo.username = ""
        UserProfileInfo.summary = ""
        UserProfileInfo.profileImage = UIImage(named: "missingProfile")
        
        defaults.removeObjectForKey("name")
        defaults.removeObjectForKey("email")
        defaults.removeObjectForKey("headline")
        defaults.removeObjectForKey("time")
        defaults.removeObjectForKey("summary")
        defaults.removeObjectForKey("time")
        
        SkillTable.setSkillTable()
        
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
        }
    }
    
    @IBAction func segControlHandler(sender: AnyObject) {
        
        if(segControl.selectedSegmentIndex == 0) {
            textField.hidden = false
            disponibilidadeView.hidden = true
            collectionView.hidden = true
            
        } else if(segControl.selectedSegmentIndex == 1) {
            textField.hidden = true
            disponibilidadeView.hidden = true
            collectionView.hidden = false
            
        } else if(segControl.selectedSegmentIndex == 2) {
            textField.hidden = true
            disponibilidadeView.hidden = false
            collectionView.hidden = true
            
        }
        
    }
    
    //Disponibilidade view
    
    
    
}


