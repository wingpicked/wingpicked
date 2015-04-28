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
                if self.feedItems.count == 0 {
                    if self.view.viewWithTag(1) == nil {
                        var overlayView = NSBundle.mainBundle().loadNibNamed("SPFeedEmptyStateView", owner: nil, options: nil)[0] as! SPFeedEmptyStateView
                        overlayView.tag = 1
                        overlayView.delegate = self
                        self.view.addSubview(overlayView)
                    }
                } else {
                    let emptyStateView = self.view.viewWithTag(1)
                    emptyStateView?.removeFromSuperview()
                    self.tableView.reloadData()
                }
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
