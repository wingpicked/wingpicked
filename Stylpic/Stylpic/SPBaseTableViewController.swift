//
//  SPFeedTableViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Parse

class SPBaseTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, SPFeedViewTableViewCellDelegate {

    //var imageDataArray : [SPImage] = [];
    var allPictureObjects : [PFObject] = [];
    var feedItems : [SPFeedItem] = [];
    var isStaleData = true
    
    //MARK: View Lifecycle    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup Refresh Control
        var rc = UIRefreshControl()
        rc.addTarget(self, action: Selector("downloadAllImages"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc;
       
        downloadAllImages()
         
        tableView.registerNib(UINib(nibName: "SPFeedViewTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedViewTableViewCell")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "TopBarWithStylpicTitle"), forBarMetrics: UIBarMetrics.Default)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateViewController", name: "RefreshViewControllers", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     
        if(self.isStaleData){
            self.tableView.contentOffset = CGPointMake(0, -self.refreshControl!.frame.size.height);
            self.refreshControl!.beginRefreshing()
            self.downloadAllImages()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateViewController() {
        self.isStaleData = true
    }
    
    func downloadAllImages(){
        //Override by subclasses.
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
        self.navigationController?.pushViewController(detailViewController, animated: true)

    }
    
    func didTapPhotoTwo(feedItem: SPFeedItem) {
        var detailViewController = SPFeedDetailViewController(feedItem: feedItem, imageTapped: ImageIdentifier.ImageTwo)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didRequestUserProfile( feedItem: SPFeedItem ) {
        if let user = feedItem.photos?["user"] as? SPUser {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = storyboard.instantiateViewControllerWithIdentifier("SPProfileViewController") as! SPProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
            profileViewController.showWithUser(user)
        }
        
    }

}
