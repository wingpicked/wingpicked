//
//  SPInviteFriendsTableViewController.swift
//  Stylpic
//
//  Created by Joshua Bell on 4/12/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPFindFriendsTableViewController: UITableViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SPManager.sharedInstance.getFacebookFriendsWithApp { (users, error) -> Void in
            
        }
        
        
    }
    
    
}
