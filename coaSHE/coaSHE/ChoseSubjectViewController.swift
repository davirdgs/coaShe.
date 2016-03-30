//
//  ChoseSubjectViewController.swift
//  coaSHE
//
//  Created by Sidney Orlovski Nogueira on 12/1/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit
import Parse

class ChoseSubjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var temasTableView: UITableView!
    var clicked_button = ""
    
    // elementos que populam a Table View
    var temas : [String] = ["Carreira Acadêmica", "Desenvolvimento Pessoal", "Design", "Empreendedorismo", "Linguagem de Programação", "Mercado de Trabalho"]
    var imagens : [String] = ["carreira_academica_icon", "desenvolvimento_pessoal_icon", "design_icon", "empreendedorismo_icon", "linguagem_de_programacao_icon", "mercado_de_trabalho_icon"]
    
    
    // MARK: view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // qual classe é responsável por implementar esses métodos
        self.temasTableView.delegate = self
        self.temasTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        /*
        if(PFUser.currentUser() != nil) {
            performSegueWithIdentifier("toEditProfile", sender: self)
        }
        */
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    //Método que passa pra view adequada qual deve ser o grande tema a ser mostrado
    @IBAction func selectSubject(sender: AnyObject) {
        //Passa o título do botão como parâmetro.
        clicked_button = sender.currentTitle!!
        let view_controller_anterior = self.navigationController?.viewControllers.first as! SubjectsCollectionViewController
        view_controller_anterior.bigSubject = clicked_button
        self.navigationController?.popViewControllerAnimated(false)
        //performSegueWithIdentifier("presentSubjects", sender: nil)
    }
    
    //Esse método vai passar o parametro adequado para a segue destino (Que vai carregar os dados do Parse).
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let targetSegue = segue.destinationViewController as! SubjectsCollectionViewController
        targetSegue.bigSubject = clicked_button
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = temasTableView.dequeueReusableCellWithIdentifier("TemasCell") as! TemasCellTableViewCell
        
        cell.nomeDoTema.setTitle(temas[indexPath.row], forState: .Normal)
        cell.imagemDoTema.image = UIImage(named: imagens[indexPath.row])
        
        return cell
    }
    
}
