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
        
//        tableViewController.tableView.delegate = self
//        tableViewController.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
//        
//        cell.textLabel!.text = "Hey"
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "tableViewController"){
            tableViewController = segue.destinationViewController as! SPPhotosQueryTableViewController
//            tvc.tableView.delegate = self
//            tvc.tableView.dataSource = self
        }
        
    }

}
