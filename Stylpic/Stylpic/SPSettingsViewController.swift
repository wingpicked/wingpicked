//
//  SPSettingsViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 4/25/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPSettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let dismissButton = UIBarButtonItem(title: "Dismiss", style: .Plain, target: self, action: "dismissButtonDidTap:")
        self.navigationItem.leftBarButtonItem = dismissButton
        
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    @IBAction func logoutButtonDidTap(sender: AnyObject) {
        println("logged out!")
    }
    
    func dismissButtonDidTap(sender : AnyObject!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
