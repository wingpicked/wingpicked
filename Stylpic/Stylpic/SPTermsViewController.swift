//
//  SPTermsViewController.swift
//  Wingpicked
//
//  Created by Neil Bhargava on 6/5/16.
//  Copyright © 2016 Neil Bhargava. All rights reserved.
//

import UIKit

class SPTermsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSBundle.mainBundle().URLForResource("terms", withExtension: "html")
        if let url = url {
            self.webView.loadRequest(NSURLRequest(URL: url))
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .Plain, target: self, action: #selector(SPTermsViewController.dismissViewController))
    }
    
    func dismissViewController(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
