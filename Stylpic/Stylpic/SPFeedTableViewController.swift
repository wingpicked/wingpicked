//
//  SPFeedTableViewController.swift
//  Stylpic
//
//  Created by Joshua Bell on 3/25/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPFeedTableViewController: SPBaseTableViewController {

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
    

}
