//
//  CoaSheSelectionViewController.swift
//  coaSHE
//
//  Created by Sidney Orlovski Nogueira on 12/1/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit
import Parse

class CoaSheSelectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Tema atual.
    var subject:PFObject = PFObject(className: "Subjects")
    
    //CoaShes para esse tema.
    var coaShes = []
    //Usuário atual.
    let currentUser = PFUser.currentUser()
    
    //índice da coaShe que foi clicada.
    var coaSheClicked = 0
    
    //CollectionView que vai mostrar as coaShes disponíveis.
    @IBOutlet weak var coaShesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Seta o dataSource da collection view para a própria classe
        coaShesCollectionView.dataSource = self
        coaShesCollectionView.delegate = self
        //Seta algumas coisas da collection view (dimensões)
        
        coaShes = subject.objectForKey("coaShes") as! NSArray
        //Vamos remover o elemento que contem o próprio usuário, se ele estiver presente. (Caso o usuário esteja logado)
        if (PFUser.currentUser() != nil) {
            let new_coaShes :NSMutableArray = []
            let user_id = self.currentUser?.valueForKey("objectId")as! String
            for coashe in coaShes {
                let coashe_string = coashe as! String
                if (strcmp(coashe_string, (user_id)) != 0) {
                    new_coaShes.insertObject(coashe_string, atIndex: 0)
                }
            }
            self.coaShes = new_coaShes
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func  viewDidAppear(animated: Bool) {
        
        if(coaShes.count == 0) {
            let alert = UIAlertController(title: "Ops!", message: "Ainda não existem mentoras para este tema", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                self.performSegueWithIdentifier("unwindToSubjects", sender: self)
            }
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: { () -> Void in
                
            })
        } //Fim di if
        
    }
    
    //MARK: - Collection View Methods.
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("coaSheCell", forIndexPath: indexPath) as! CoaSheCollectionViewCell

        //Coloca os dados da foto e do label do jeito correto.
        //Cria query para pegar os users cujos ids estão no array do Subject
        let query = PFQuery(className: "_User")
        let coashe_ID = coaShes[indexPath.row]
        query.whereKey("objectId", equalTo: coashe_ID)
        query.includeKey("user_profile")
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if error == nil {
                let user_profile = object!["user_profile"] as! PFObject
                
                //Seta o nome e cargo da coaShe.
                cell.coaSheNameLabel.text = user_profile["nome"] as! String!
                cell.coaSheCargoLabel.text = user_profile["titulo_profissional"] as! String!
                //Ajusta a altura dos textos.
                //cell.TopAdjustmentConstraintForName.constant = cell.coaShePicture.frame.height*2/10
                //cell.TopAdjustmentConstraintForCargo.constant = cell.coaShePicture.frame.height/10
                
                let userImageFile = user_profile["foto"] as? PFFile
                if (userImageFile != nil) {
                    userImageFile!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            if let imageData = imageData {
                                let image = UIImage(data: imageData)
                                cell.coaShePicture.image = image
                            }
                        }
                    })
                
                }
            } else {
                print(error)
            }
        }
        
        //Deixa a foto redondinha :D
        cell.coaShePicture.layer.masksToBounds = false
        cell.coaShePicture.layer.cornerRadius = self.coaShesCollectionView.frame.width/16
        cell.coaShePicture.clipsToBounds = true
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        coaSheClicked = indexPath.row
        // TODO: ver isso ae
        performSegueWithIdentifier("coaSheProfileSegue", sender: self)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coaShes.count//subject.objectForKey("coaShes")!.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        return CGSize(width: self.view.frame.width*0.68, height: self.view.frame.height*0.65)
        
        return CGSize(width: self.coaShesCollectionView.frame.width - 20 ,height: (self.coaShesCollectionView.frame.height/4) + 10)
        
    }
    
    
    //MARK: - Segue Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "coaSheProfileSegue") {
            let segue_view = segue.destinationViewController as! ProfileView2ViewController
            segue_view.isFromSelf = false
            segue_view.coaShe_data = coaShes[coaSheClicked] as! String
        }
        
    }
    

    // MARK: - Navigation

    
  
    // MARK: - Crop de imagens em círculos.
    
    //Primeiro corta a imagem como um quadrado, para fazer futuramento um círculo
    static func cropToSquare(image originalImage: UIImage) -> UIImage {
        
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage!)
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        
        return image
    }
    
    //Transforma uma imagem quadrada em um círculo!
    static func makeCircularImage( originalImage: UIImage, borderWidth: CGFloat, borderColor: CGColor ) -> UIImageView {
        
        let imageView = UIImageView(image: originalImage)
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = borderColor
        return imageView
    }
    
}
