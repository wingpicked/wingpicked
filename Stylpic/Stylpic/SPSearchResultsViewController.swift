//
//  SPSearchResultsViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 4/12/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPSearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var searchBar : UISearchBar!
    var searchResults : [SPUser] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "SPFeedDetailCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailCommentTableViewCell")
        
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.placeholder = "Search for a user..."
        self.title = "SEARCH"
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailCommentTableViewCell", forIndexPath: indexPath) as! SPFeedDetailCommentTableViewCell
        cell.setupCellWithUser(self.searchResults[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("SPProfileViewController") as! SPProfileViewController
        profileViewController.showWithUser(searchResults[indexPath.row])
        self.navigationController?.pushViewController(profileViewController, animated: true)


    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        SPManager.sharedInstance.getUsersWithSearchTerms(searchBar.text, resultBlock: { (users, error) -> Void in
            
            if(error == nil){
                if let users = users{
                    self.searchResults = users
                    self.tableView.reloadData()
                }
            }
        })
        
        self.dismissKeyboard(searchBar)
    }

    func dismissKeyboard(sender: AnyObject?){
        searchBar.resignFirstResponder()
    }


}
