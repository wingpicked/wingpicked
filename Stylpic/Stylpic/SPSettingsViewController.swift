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
        self.navigationItem.title = "SETTINGS"
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    @IBAction func logoutButtonDidTap(sender: AnyObject) {
        print("logged out!")
        PFUser.logOut()
        
        UIApplication.sharedApplication().unregisterForRemoteNotifications()
        //TODO: Maybe rework and have a singleton reference to the login controller rather trying to find it by bubblng thru the modal hierarchy.
//        self.dismissViewControllerAnimated(false, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("showLoginScreen", object: nil)

    }
    
    func dismissButtonDidTap(sender : AnyObject!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
