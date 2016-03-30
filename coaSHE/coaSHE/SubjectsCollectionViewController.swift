//
//  SubjectsCollectionViewController.swift
//  coaSHE
//
//  Created by Sidney Orlovski Nogueira on 11/24/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit
import Parse

class SubjectsCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var pass: Bool = false
    
    @IBOutlet weak var titleButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    //Vetor com os subjects que vão popular as células.
    var subjects = [PFObject]()
    
    //Parametro contendo o grande tema dos subjects a serem mostrados.
    var bigSubject = "Linguagem de Programação"
    
    //Variável que vai armazenar a informação de que célula deve ser passada para a segue que mostra um subject específico.
    var indexPathClicked = 0
    
    //Constraint da margem à esquerda
    @IBOutlet weak var leadingMargin: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewTopLayoutGuide: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Activity indicator
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        self.activityIndicatorView.hidden = false
        
        //Seta o tema padrão para "Todos"
//        self.navigationController?.navigationBar.topItem?.title = self.bigSubject
        self.navigationController?.navigationBar.translucent = true
        
        //Adiciona um botão no centro da navigation Bar.
        let button =  UIButton(type: .Custom)
        button.frame = CGRectMake(0, 0, 120, 40) as CGRect
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitle(" " + self.bigSubject + " ⌵ ", forState: UIControlState.Normal)
        button.backgroundColor = Styles.roxoCoashe
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(SubjectsCollectionViewController.clickOnButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = button
        
        //Recarrega os dados da collection view.
        // Pegamos do parse a lista de temas a serem apresentados na collection view, e salva essa lista no vetor subjects.
        // Usaremos isso para popular nossa collectionView :D.
        ParseAuxiliarMethods.sharedInstance.retrieveAllFromClass("Subjects", queryParameter: "bigTema", queryKey: bigSubject, sortingParameter: nil, ascendingOrder: nil, completion: { (retrieveObjects) -> Void in
            if retrieveObjects != nil {
                self.subjects = retrieveObjects!
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.activityIndicatorView.hidden = true
            }
        })

    }
    
    func clickOnButton (button: UIButton) {
        performSegueWithIdentifier("choseSubject", sender: self)
    }
    
    // MARK: Collection View
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath) as! CardCollectionViewCell
        
        //Para o efeito de carousel, é preciso colocar a primeira célula tanto na primeira posição quanto na ultima.
        //Esse trecho de código coloca a primeira célula na ultima posição.
        if (indexPath.row == subjects.count)&&(subjects.count != 0) { //Se estivermos inserindo a ultima célula.
            
            //Coloca a imagem adequada no lugar.
            let nome = self.subjects[0].valueForKey("backgroundImageName") as! String
            cell.subjectImage.image = UIImage(named: nome)
            
            //Coloca o título adequado no label correto
            let subject = self.subjects[0].valueForKey("subject") as! String
            cell.subjectTitle_text.text = subject
            
            //Coloca a grande área no local adequado
            let area = self.subjects[0].valueForKey("bigTema") as! String
            cell.subjectClassLabel.text = area
            
            let avaiable = self.subjects[0].valueForKey("coachs") as! Int
            cell.coachsAvaiableLabel.text = String(avaiable)
            
            let finished = self.subjects[0].valueForKey("finished") as! Int
            cell.finishedMentoringLabel.text = String(finished)
            
            //Verifica o tamanho da tela e deixa o tamanho da fonte adequado.
            if (self.view.frame.width > 600) {
                cell.finishedMentoringText.font = UIFont(name: (cell.finishedMentoringText?.font.fontName)!, size: 14)
                cell.coachsAvaiableText.font = UIFont(name: (cell.coachsAvaiableText?.font?.fontName)!, size: 14)
            }
            
            
        } else if (subjects.count != 0) {
            //Coloca a imagem adequada no lugar.
            let nome = self.subjects[indexPath.row].valueForKey("backgroundImageName") as! String
            cell.subjectImage.image = UIImage(named: nome)
            
            //Coloca o título adequado no label correto
            let subject = self.subjects[indexPath.row].valueForKey("subject") as! String
            cell.subjectTitle_text.text = subject
            
            //Coloca a grande área no local adequado
            let area = self.subjects[indexPath.row].valueForKey("bigTema") as! String
            cell.subjectClassLabel.text = area
            
            let avaiable = self.subjects[indexPath.row].valueForKey("coachs") as! Int
            cell.coachsAvaiableLabel.text = String(avaiable)
            
            let finished = self.subjects[indexPath.row].valueForKey("finished") as! Int
            cell.finishedMentoringLabel.text = String(finished)
            
            //Verifica o tamanho da tela e deixa o tamanho da fonte adequado.
            if (self.view.frame.width > 600) {
                cell.finishedMentoringText.font = UIFont(name: (cell.finishedMentoringText?.font?.fontName)!, size: 14)
                cell.coachsAvaiableText.font = UIFont(name: (cell.coachsAvaiableText?.font?.fontName)!, size: 14)
            }
            
        }
        //let finished = self.subjects[indexPath.row].valueForKey("bigTema")
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width*0.8/**0.73*/, height: self.collectionView.frame.height)//*0.70)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //Calcula quanto scroll foi dado para chegar ao fim da lista. (Tamanho de uma célula X quantidade de células)
        let contentOffsetWhenFullyScrolled = ((Float(self.collectionView.frame.width)*0.48)) * Float(self.subjects.count)
        
        //Se tiver totalmente deslocado para a direita, imediatamente desloca para a esquerda sem animação.
        if (Float(scrollView.contentOffset.x) == contentOffsetWhenFullyScrolled) {
            let indexPath = NSIndexPath(index: 0)
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
            
        }
        
        
    }
    
    //Função que muda para a tela do tema escolhido
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        indexPathClicked = indexPath.row
        performSegueWithIdentifier("cardSelect", sender: nil)
        
    }
    
    //Função do botão para selecionar o grande tema.
    @IBAction func subjectChoseAction(sender: AnyObject) {
        //performSegueWithIdentifier("choseSubject", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicatorView.alpha = 0.5
        self.activityIndicatorView.layer.cornerRadius = self.activityIndicatorView.frame.height/4
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //Esconde a barra de rolagem da collection view.
        self.collectionView.showsHorizontalScrollIndicator = false
        
        //Definição de constraints para ajeitar os coisos de um jeito massa.
        self.leadingMargin.constant = self.view.frame.width*(0.05882) - 20
        //Distancia da collectionView do topo da view.
        self.collectionViewTopLayoutGuide.constant = (self.navigationController?.navigationBar.frame.height)! + 20
        
        let flow = UICollectionViewFlowLayout()
        
        //Define a direção de scroll horizontalmente.
        flow.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        //Define a distância entre duas células da collection view
//        flow.minimumLineSpacing = self.view.frame.width/10.2
        flow.minimumInteritemSpacing = self.view.frame.width/10.2
        
        
        self.collectionView.setCollectionViewLayout(flow, animated: false)
        
        
        // faço com que o bigTema apareça como label do botão de escolher temas
        //titleButton.setTitle(bigSubject, forState: UIControlState.Normal)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Se a segue for a quando clicar em um card
        if (segue.identifier == "cardSelect") {
            let destinySegue = segue.destinationViewController as! CoaSheSelectionViewController
            destinySegue.subject = self.subjects[indexPathClicked]
        }
        
        if(self.pass && segue.identifier == "subjectsToSignIn") {
            let vc = segue.destinationViewController as! SignInView
            vc.pass = true
        }
        if (segue.identifier == "showOwnProfile") {
            let vc = segue.destinationViewController as! ProfileNavController
            vc.coaShe = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func returnToSubjects(segue: UIStoryboardSegue) {
        
    }


}
