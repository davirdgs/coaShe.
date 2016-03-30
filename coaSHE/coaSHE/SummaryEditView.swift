//
//  SummaryEditView.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 09/12/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit

class SummaryEditView: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    // MARK: Buttons outlets
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.alignToTop()
        textView.text = UserProfileInfo.summary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //textView.setContentOffset(CGPointZero, animated: false)
    }
    
    // MARK: Button handlers
    
    @IBAction func saveButtonHandler(sender: AnyObject) {
        
        UserProfileInfo.summary = self.textView.text
        self.textView.disableAligment()
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func cancelButtonHandler(sender: AnyObject) {
        self.textView.disableAligment()
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }

}
