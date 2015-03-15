//
//  SPProfileViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPProfileViewController: UITableViewController{

    var toolBarView : UIView!
    var headerView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.headerView = NSBundle.mainBundle().loadNibNamed("SPProfileHeaderView", owner: self, options: nil).first as! SPProfileHeaderView
        self.toolBarView = NSBundle.mainBundle().loadNibNamed("SPProfileToolBarView", owner: self, options: nil).first as! SPProfileToolBarView

        toolBarView.layer.borderColor = UIColor.darkGrayColor().CGColor
        toolBarView.layer.borderWidth = 2.0
        
        tableView.tableHeaderView = self.headerView
        
        var rc = UIRefreshControl()
        rc.addTarget(self, action: Selector("refreshTableView"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc;
    }
    
    func refreshTableView(){
        println("Refreshed")
        self.refreshControl?.endRefreshing()
        
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = "What up"
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        button1.addTarget(self, action: Selector("buttonPushed"), forControlEvents: UIControlEvents.TouchUpInside)
//        view.addSubview(button1)
        return self.toolBarView
    }
    
    func buttonPushed(){
        println("Button Pushed")
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 3
//    }

    
}
