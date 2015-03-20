//
//  SPProfileViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

enum SPProfileActiveViewState {
    case Posts
    case Followers
    case Following
    case Notifications
}

class SPProfileViewController: UITableViewController, SPProfileToolBarViewDelegate{

    var currentViewState = SPProfileActiveViewState.Posts
    var toolBarView : SPProfileToolBarView!
    var headerView : SPProfileHeaderView!
    
    var profileInfoViewModel = SPProfileInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView = NSBundle.mainBundle().loadNibNamed("SPProfileHeaderView", owner: self, options: nil).first as! SPProfileHeaderView
        self.toolBarView = NSBundle.mainBundle().loadNibNamed("SPProfileToolBarView", owner: self, options: nil).first as! SPProfileToolBarView
        tableView.registerNib(UINib(nibName: "SPProfilePostTableViewCell", bundle: nil), forCellReuseIdentifier: "SPProfilePostTableViewCell")
        tableView.registerNib(UINib(nibName: "SPProfileFollowTableViewCell", bundle: nil), forCellReuseIdentifier: "SPProfileFollowTableViewCell")

        self.toolBarView.delegate = self
        toolBarView.addTopBorderWithHeight(1.0, andColor: UIColor.lightGrayColor())
        toolBarView.addBottomBorderWithHeight(1.0, andColor: UIColor.lightGrayColor())
        
        tableView.tableHeaderView = self.headerView
        
        var rc = UIRefreshControl()
        rc.addTarget(self, action: Selector("refreshTableView"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc;
        
    }
    
    func refreshTableView(){
        self.refreshControl?.endRefreshing()
    }
    
    //MARK: Tableview Datasource and Delegate Methods
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch currentViewState {
        case .Posts:
            let cell = tableView.dequeueReusableCellWithIdentifier("SPProfilePostTableViewCell", forIndexPath: indexPath) as! SPProfilePostTableViewCell
            cell.setupCell(profileInfoViewModel.posts[indexPath.row])
            return cell
        case .Followers:
            let cell = tableView.dequeueReusableCellWithIdentifier("SPProfileFollowTableViewCell", forIndexPath: indexPath) as! SPProfileFollowTableViewCell
            cell.setupCell(profileInfoViewModel.followers[indexPath.row])
            return cell
        case .Following:
            let cell = tableView.dequeueReusableCellWithIdentifier("SPProfileFollowTableViewCell", forIndexPath: indexPath) as! SPProfileFollowTableViewCell
            cell.setupCell(profileInfoViewModel.following[indexPath.row])
            return cell
        case .Notifications:
            let cell = tableView.dequeueReusableCellWithIdentifier("SPProfileFollowTableViewCell", forIndexPath: indexPath) as! SPProfileFollowTableViewCell
            //cell.setupCell(profileInfoViewModel.notifications[indexPath.row])
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentViewState {
        case .Posts:
            return profileInfoViewModel.posts.count
        case .Followers:
            return profileInfoViewModel.followers.count
        case .Following:
            return profileInfoViewModel.following.count
        case .Notifications:
            return profileInfoViewModel.notifications.count
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.toolBarView
    }
    
    func buttonPushed(){
        println("Button Pushed")
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch currentViewState {
        case .Posts:
            return 136
        case .Followers:
            return 44
        case .Following:
            return 64
        case .Notifications:
            return 44
        }
    }
    
    //MARK: SPProfile Toolbar Delegate
    func postsButtonTapped() {
        currentViewState = .Posts
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.reloadData()
    }
    func followersButtonTapped() {
        currentViewState = .Followers
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.reloadData()
    }
    func followingButtonTapped() {
        currentViewState = .Following
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.reloadData()
    }
    func notificationsButtonTapped() {
        currentViewState = .Notifications
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.reloadData()
    }
    
    
}
