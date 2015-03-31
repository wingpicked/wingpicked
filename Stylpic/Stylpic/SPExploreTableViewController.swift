//
//  SPExploreViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPExploreTableViewController: SPBaseTableViewController {//, UITableViewDataSource, UITableViewDelegate {

    override func downloadAllImages() {
        
        SPManager.sharedInstance.getExploreItems( { (feedItems, error) -> Void in
            if(error == nil){
                self.feedItems = feedItems
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        })
    }
    
}
