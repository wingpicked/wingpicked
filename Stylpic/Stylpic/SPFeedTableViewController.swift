//
//  SPFeedTableViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Parse

class SPFeedTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, SPFeedViewTableViewCellDelegate {

    //var imageDataArray : [SPImage] = [];
    var allPictureObjects : [PFObject] = [];
    var feedItems : [SPFeedItem] = [];
    
    //MARK: View Lifecycle    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup Refresh Control
        var rc = UIRefreshControl()
        rc.addTarget(self, action: Selector("downloadAllImages"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc;
       
        downloadAllImages()
 
        //self.refreshControl?.beginRefreshing()
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 52, 0)
        
        tableView.registerNib(UINib(nibName: "SPFeedViewTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedViewTableViewCell")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "TopBarWithStylpicTitle"), forBarMetrics: UIBarMetrics.Default)
    }
    
    func downloadAllImages(){

        SPManager.sharedInstance.getFeedItems(0, resultsBlock: { (feedItems, error) -> Void in
            if(error == nil){
                self.feedItems = feedItems
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedItems.count
    }

    override func tableView(tableView: UITableView , cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedViewTableViewCell", forIndexPath: indexPath) as! SPFeedViewTableViewCell
        
        var feedItem = self.feedItems[indexPath.row]
        cell.delegate = self
        cell.setupWithFeedItem(feedItem)

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 227
    }
    
    func didTapPhotoOne(feedItem: SPFeedItem) {
        var detailViewController = SPFeedDetailViewController(feedItem: feedItem, imageTapped: ImageIdentifier.ImageOne)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)

    }
    
    func didTapPhotoTwo(feedItem: SPFeedItem) {
        var detailViewController = SPFeedDetailViewController(feedItem: feedItem, imageTapped: ImageIdentifier.ImageTwo)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
