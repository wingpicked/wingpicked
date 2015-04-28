//
//  SPFeedTableViewController.swift
//  Stylpic
//
//  Created by Joshua Bell on 3/25/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPFeedTableViewController: SPBaseTableViewController, SPFeedEmptyStateViewDelegate {

    override func downloadAllImages(){        
        SPManager.sharedInstance.getFeedItems(0, resultsBlock: { (feedItems, error) -> Void in
            if(error == nil){
                self.feedItems = feedItems
                self.tableView.reloadData()
                self.isStaleData = false
            }
            self.refreshControl?.endRefreshing()
        })
    }
    
    func findFriendsButtonDidTap() {
        let findFriendsController = SPFindFriendsTableViewController()
        let navigationController = UINavigationController(rootViewController: findFriendsController)
        let backItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismissFindFriendsController")
        findFriendsController.navigationItem.leftBarButtonItem = backItem
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

    func dismissFindFriendsController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
