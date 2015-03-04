//
//  SPExploreViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPExploreViewController: UIViewController {//, UITableViewDataSource, UITableViewDelegate {

    var tableViewController : SPPhotosQueryTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "tableViewController"){
            tableViewController = segue.destinationViewController as! SPPhotosQueryTableViewController
        }
    }
}
