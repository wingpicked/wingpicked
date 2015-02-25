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

    var imageDataArray : [SPImage] = [];

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadAllImages()
        
        //Setup Refresh Control
        var rc = UIRefreshControl()
        rc.addTarget(self, action: Selector("downloadAllImages"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 52, 0)
    }
    
    func downloadAllImages(){
        var query = PFQuery(className: "UserPhoto")
        
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            self.refreshControl?.endRefreshing()
            self.imageDataArray.removeAll(keepCapacity: false)

            if(error == nil)
         {
//            println("Successfully retrieved %d photos.", objects.count);
            
            
            //TODO: Refactor this out to a manager	
            // Iterate over all images and get the data from the PFFile
            for (var i = 0; i < objects.count; i++) {
                
                var eachObject = objects[i] as! PFObject
                var theImage = eachObject["imageFile"] as! PFFile

                theImage.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    var imageData = data
                    var image = UIImage(data: imageData)
                    
                    var fCaption = ""
                    if let theCaption = eachObject["caption"] as? String{
                        fCaption = theCaption
                    }
                    else{
                        fCaption = "Empty Caption"
                    }
                    
                    var spImage = SPImage(caption:fCaption, image: image!)
                    self.imageDataArray.append(spImage)
                    self.tableView.reloadData() //TODO: Refactor this out so its not called every time there is an image.
                })
            }

        }
        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return imageDataArray.count
    }

    override func tableView(tableView: UITableView , cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SPFeedViewTableViewCell

//        cell.textLabel?.text = "Cell \(indexPath.row)"
        cell.pictureImageView.image = imageDataArray[indexPath.row].image
        cell.caption.text = imageDataArray[indexPath.row].caption
        // Configure the cell...

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var detailViewController = SPFeedDetailViewController(image: imageDataArray[indexPath.row].image!)
        //self.presentViewController(detailViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

}
