//
//  TermsViewController.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 01/02/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var termsWebView: UIWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadTermsHTML()
        
        
    }
    
    
    func loadTermsHTML() {
        
        //Load the HTML file from resources
        guard let path = NSBundle.mainBundle().pathForResource("termos e condies de uso", ofType: "html") else {
                return
        }
        
        let url = NSURL(fileURLWithPath: path)
        
        if let data = NSData(contentsOfURL: url) {
            
            termsWebView.loadHTMLString(NSString(data: data,
                encoding: NSUTF8StringEncoding) as! String, baseURL: nil)
            
        }
    }

    @IBAction func backButtonHandler(sender: AnyObject) {
        
        performSegueWithIdentifier("toStart", sender: self)
        
    }
    
}
