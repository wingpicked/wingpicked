//
//  SPPhotosQueryTableViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/3/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPPhotosQueryTableViewController: PFQueryTableViewController {

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
            // The className to query on
            self.parseClassName = "Foo";
        
            // The key of the PFObject to display in the label of the default cell style
            self.textKey = "text";
            
            // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
            // self.imageKey = @"image";
            
            // Whether the built-in pull-to-refresh is enabled
            self.pullToRefreshEnabled = true;
            
            // Whether the built-in pagination is enabled
            self.paginationEnabled = true;
            
            // The number of objects to show per page
            self.objectsPerPage = 25;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

//    override func queryForTable() -> PFQuery! {
//        return PFQuery(className: "className")
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PFTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PFTableViewCell
        cell.textLabel!.text = "hi"
        return cell
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
    }
}
