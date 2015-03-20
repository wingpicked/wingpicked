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
    
    var profileInfo : SPProfileInfo?
    
    //var dataArray : [String] = []
    var dataArray : [AnyObject] = []
    let array1 = ["Hey", "Whats", "UP"]
    let array2 = ["SUP ARRAY 2!", "Yee", "This is fo followers"]
    
    var profileInfoViewModel = SPProfileInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
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
        
        self.dataArray = array1
    }
    
    func refreshTableView(){
        println("Refreshed")
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
            cell.setupCell(profileInfoViewModel.followers[indexPath.row].isFollowing)
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SPProfileFollowTableViewCell", forIndexPath: indexPath) as! SPProfileFollowTableViewCell
            cell.setupCell(profileInfoViewModel.followers[indexPath.row].isFollowing)
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
            return 11
        case .Followers:
            return 22
        case .Following:
            return 33
        case .Notifications:
            return 44
        }
//        if(array1 == dataArray){
//            return 136
//        }
//        else if (array2 == dataArray){
//            return 44
//        }
//        else{
//            return 64
//        }
    }

    
    //MARK: SPProfile Toolbar Delegate
    func postsButtonTapped() {
        println("posts")
        currentViewState = .Posts
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        dataArray = array1
        self.tableView.reloadData()
    }
    func followersButtonTapped() {
        println("followers")
        currentViewState = .Followers
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        dataArray = array2
        self.tableView.reloadData()
    }
    func followingButtonTapped() {
        println("following")
        dataArray = ["hey"]
        self.tableView.reloadData()
    }
    func notificationsButtonTapped() {
        println("notif")
    }
    
    
}
