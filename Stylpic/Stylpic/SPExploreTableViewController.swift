//
//  SPExploreViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPExploreTableViewController: SPBaseTableViewController, UISearchBarDelegate {//, UITableViewDataSource, UITableViewDelegate {

    var searchBar : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        self.tableView.tableHeaderView = searchBar
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.tableView.addGestureRecognizer(tapGestureRecognizer)
        
        self.navigationItem.title = "EXPLORE"
    }
    
    
    func dismissKeyboard(sender: AnyObject?){
        searchBar.resignFirstResponder()
    }
    
    override func downloadAllImages() {
        
        SPManager.sharedInstance.getExploreItems( { (feedItems, error) -> Void in
            if(error == nil){
                self.feedItems = feedItems
                self.tableView.reloadData()
                self.isStaleData = false
            }
            self.refreshControl?.endRefreshing()
        })
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {

        let searchResultsViewController = SPSearchResultsViewController(nibName: "SPSearchResultsViewController", bundle: nil)
        searchResultsViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        let nc = UINavigationController(rootViewController: searchResultsViewController)
        self.presentViewController(nc, animated: true, completion: nil)
        
        return false
    }
}
