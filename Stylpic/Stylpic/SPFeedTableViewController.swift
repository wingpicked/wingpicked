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
                
                var eachObject = objects[i] as PFObject
                var theImage = eachObject["imageFile"] as PFFile
                var imageData = theImage.getData()
                var image = UIImage(data: imageData)
                
                var fCaption = ""
                if let theCaption = eachObject["caption"] as? String{
                    fCaption = theCaption
                }
                else{
                    fCaption = "Empty Caption"
                }

                var spImage = SPImage(caption:fCaption, image: image)
                
                self.imageDataArray.append(spImage)
            }
            self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as SPFeedViewTableViewCell

//        cell.textLabel?.text = "Cell \(indexPath.row)"
        cell.pictureImageView.image = imageDataArray[indexPath.row].image
        cell.caption.text = imageDataArray[indexPath.row].caption
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
