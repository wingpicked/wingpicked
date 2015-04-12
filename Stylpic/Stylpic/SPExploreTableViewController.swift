//
//  SPExploreViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPExploreTableViewController: SPBaseTableViewController, UISearchBarDelegate {//, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar

    }
    
    
    override func downloadAllImages() {
        
        SPManager.sharedInstance.getExploreItems( { (feedItems, error) -> Void in
            if(error == nil){
                self.feedItems = feedItems
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        })
    }
    
    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        SPManager.sharedInstance.getUsersWithSearchTerms(searchBar.text, resultBlock: { (users, error) -> Void in
            
        })
    }
}
