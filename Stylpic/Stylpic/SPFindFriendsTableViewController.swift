//
//  SPInviteFriendsTableViewController.swift
//  Stylpic
//
//  Created by Joshua Bell on 4/12/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPFindFriendsTableViewController: UITableViewController {
   
    var facebookFriendsUsingApp: [SPUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "SPProfileFollowTableViewCell", bundle: nil), forCellReuseIdentifier: "SPProfileFollowTableViewCell")
        self.title = "ADD FRIENDS"

        SPManager.sharedInstance.getFacebookFriendsWithApp { (facebookFriends, error) -> Void in
            self.facebookFriendsUsingApp = facebookFriends
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 0
        if let facebookFriends = self.facebookFriendsUsingApp {
            numRows = facebookFriends.count
        }

        return numRows
    }
    
 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SPProfileFollowTableViewCell", forIndexPath: indexPath) as! SPProfileFollowTableViewCell
        var user = self.facebookFriendsUsingApp?[indexPath.row]
        cell.setupCell( user! )
        return cell
    }
}
