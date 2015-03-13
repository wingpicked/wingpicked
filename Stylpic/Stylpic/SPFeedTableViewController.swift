//
//  SPFeedTableViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Parse

class SPFeedTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    //var imageDataArray : [SPImage] = [];
    var allPictureObjects : [PFObject] = [];
    var feedItems : [SPFeedItem] = [];
    
    //MARK: View Lifecycle    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SPManager.sharedInstance.getFeedItems(0, resultsBlock: { (feedItems, error) -> Void in
            self.feedItems = feedItems
            self.tableView.reloadData()
        })

        
        
        //downloadAllImages()
        
        //Setup Refresh Control
//        var rc = UIRefreshControl()
//        rc.addTarget(self, action: Selector("downloadAllImages"), forControlEvents: UIControlEvents.ValueChanged)
//        self.refreshControl = rc;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 52, 0)
        
        tableView.registerNib(UINib(nibName: "SPFeedViewTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedViewTableViewCell")
    }
    
//    func downloadAllImages(){
//        var query = PFQuery(className: "UserPhoto")
//        
//        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//            self.refreshControl?.endRefreshing()
//            //self.imageDataArray.removeAll(keepCapacity: false)
//
//            if(error == nil){
//                self.allPictureObjects = objects as! [PFObject]
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //return imageDataArray.count
        
        //return allPictureObjects.count
        return self.feedItems.count
    }

    override func tableView(tableView: UITableView , cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedViewTableViewCell", forIndexPath: indexPath) as! SPFeedViewTableViewCell

            
        //var o = self.allPictureObjects[indexPath.row] as PFObject
        
        var feedItem = self.feedItems[indexPath.row]

        cell.caption.text = feedItem.caption
        
        cell.pictureImageView.file = feedItem.photos.objectForKey("imageOne") as! PFFile
        cell.pictureImageView2.file = feedItem.photos.objectForKey("imageTwo") as! PFFile
        cell.pictureImageView2.loadInBackground(nil)
        cell.pictureImageView.loadInBackground(nil)

//        var f = o["imageFile"] as? PFFile
//        var f2 = o["imageFile2"] as? PFFile
//        var caption = o["caption"] as? String
//        if let f = f, f2 = f2, caption = caption {
//            cell.pictureImageView.file = f
//            cell.pictureImageView2.file = f2
//            cell.pictureImageView.loadInBackground(nil)
//            cell.pictureImageView2.loadInBackground(nil)
//            cell.caption.text = caption
//        }

        
        

        
//        cell.textLabel?.text = "Cell \(indexPath.row)"
        //cell.pictureImageView.image = imageDataArray[indexPath.row].image
        //cell.caption.text = imageDataArray[indexPath.row].caption
        // Configure the cell...

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var detailViewController = SPFeedDetailViewController(imageFile: self.feedItems[indexPath.row].photos.objectForKey("imageOne") as! PFFile) 
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

}
