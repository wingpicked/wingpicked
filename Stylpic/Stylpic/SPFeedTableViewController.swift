//
//  SPFeedTableViewController.swift
//  Stylpic
//
//  Created by Joshua Bell on 3/25/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPFeedTableViewController: SPBaseTableViewController {

    let overlayView: SPFeedEmptyStateView = NSBundle.mainBundle().loadNibNamed("SPFeedEmptyStateView", owner: nil, options: nil)[0] as! SPFeedEmptyStateView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(fromColor: navigationBarColor, forSize: CGSizeMake(320, 64), withCornerRadius: 0.0), forBarMetrics: UIBarMetrics.Default)
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let titleView = UIView(frame: CGRectMake(16,0, 288, 64))
        let titleLabel = UILabel(frame: CGRectMake(0,4, 288, 44))
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont(name: "Lobster1.4", size: 28)
        titleLabel.textAlignment = NSTextAlignment.Center
        //titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "Stylpic"
        titleView.addSubview(titleLabel)
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.translucent = false
    }
    
    override func downloadAllImages(){
        
        SPManager.sharedInstance.getFeedItems(0, resultsBlock: { (feedItems, error) -> Void in
            if(error == nil){
                self.feedItems = feedItems
                if self.feedItems.count == 0 {
                    if self.overlayView.superview == nil {
                        self.overlayView.tag = 1
                        //self.overlayView.delegate = self
                        self.view.addSubview(self.overlayView)
                    }
                } else {
                    self.overlayView.removeFromSuperview()
                    self.tableView.reloadData()
                }
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
