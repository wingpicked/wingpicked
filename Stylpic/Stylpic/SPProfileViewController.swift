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

class SPProfileViewController: UITableViewController, SPProfileToolBarViewDelegate, SPFeedViewTableViewCellDelegate, SPProfilePostTableViewCellDelegate {

    var currentViewState = SPProfileActiveViewState.Posts
    var toolBarView : SPProfileToolBarView!
    var headerView : SPProfileHeaderView!
    
    var profileInfoViewModel = SPProfileInfo()
    var showForUser : SPUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView = NSBundle.mainBundle().loadNibNamed("SPProfileHeaderView", owner: self, options: nil).first as! SPProfileHeaderView
        
        self.toolBarView = NSBundle.mainBundle().loadNibNamed("SPProfileToolBarView", owner: self, options: nil).first as! SPProfileToolBarView
//        self.toolBarView = NSBundle.mainBundle().loadNibNamed("SPProfileToolBarPublicView", owner: self, options: nil).first as! SPProfileToolBarView

        
        tableView.registerNib(UINib(nibName: "SPProfilePostTableViewCell", bundle: nil), forCellReuseIdentifier: "SPProfilePostTableViewCell")
        tableView.registerNib(UINib(nibName: "SPProfileFollowTableViewCell", bundle: nil), forCellReuseIdentifier: "SPProfileFollowTableViewCell")
        tableView.registerNib(UINib(nibName: "SPProfileNotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "SPProfileNotificationsTableViewCell")

        
        self.toolBarView.delegate = self
        toolBarView.addTopBorderWithHeight(1.0, andColor: UIColor.lightGrayColor())
        toolBarView.addBottomBorderWithHeight(1.0, andColor: UIColor.lightGrayColor())
        
        tableView.tableHeaderView = self.headerView
        
        var rc = UIRefreshControl()
        rc.addTarget(self, action: Selector("refreshTableView"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc;

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateView", name: "RefreshViewControllers", object: nil)
        self.toolBarView.notificationsBadge.layer.cornerRadius = 8
        self.toolBarView.notificationsBadge.clipsToBounds = true
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateView() {
        if let showForUser = self.showForUser {
            self.showWithUser(showForUser)
        }
    }
    
    func showWithUser( user: SPUser ) {
        self.showForUser = user
        if self.showForUser?.objectId == SPUser.currentUser().objectId {
            let findFriendsButton = UIBarButtonItem(image: UIImage( named: "Icon_invite" ), style: .Plain, target: self, action: "findFriendsButtonDidTap:")
            self.navigationItem.leftBarButtonItem = findFriendsButton
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 158/255, green: 228/255, blue: 229/255, alpha: 1.0)
            
            let settingsButton = UIBarButtonItem(image: UIImage(named: "Icon_settings"), style: .Plain, target: self, action: "settingsButtonDidTap:")
            self.navigationItem.rightBarButtonItem = settingsButton
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 158/255, green: 228/255, blue: 229/255, alpha: 1.0)
        }
        
        SPManager.sharedInstance.getProfileInfo(user, resultBlock: { (profileObject, error) -> Void in
            if(error == nil){
                if let profileObject = profileObject {
                    self.profileInfoViewModel = profileObject as SPProfileInfo
                    self.headerView.setupCell(self.profileInfoViewModel.isFollowing, user: user )
                    self.headerView.followButton.hidden = ( PFUser.currentUser().objectId == user.objectId)
                    
                    self.updateToolbarUI()
                    
                    println("-----------")
                    println(self.profileInfoViewModel.followers)
                    println(self.profileInfoViewModel.following)
            
                    println(profileObject)
                    self.tableView.reloadData()
                }
            }
            else{
                println(error!.localizedDescription)
            }
        })
    }
    
    func refreshTableView(){
        self.refreshControl?.endRefreshing()
    }
    
    func updateToolbarUI(){
        self.toolBarView.postsButton.setTitle("\(self.profileInfoViewModel.postsCount)", forState: .Normal)
        self.toolBarView.followersButton.setTitle("\(self.profileInfoViewModel.followersCount)", forState: .Normal)
        self.toolBarView.followingButton.setTitle("\(self.profileInfoViewModel.followingCount)", forState: .Normal)
        let badgeNum = UIApplication.sharedApplication().applicationIconBadgeNumber
        if badgeNum > 0 {
            self.toolBarView.notificationsBadge.text = "\(badgeNum)"
            self.toolBarView.notificationsBadge.hidden = false
        } else {        
            self.toolBarView.notificationsBadge.hidden = true
        }
    }
    
    //MARK: Tableview Datasource and Delegate Methods
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch currentViewState {
        case .Posts:
            let cell = tableView.dequeueReusableCellWithIdentifier("SPProfilePostTableViewCell", forIndexPath: indexPath) as! SPProfilePostTableViewCell
            cell.setupWithFeedItem(profileInfoViewModel.posts[indexPath.row])
            cell.delegate = self
            cell.profilePostDelegate = self
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
            let cell = tableView.dequeueReusableCellWithIdentifier("SPProfileNotificationsTableViewCell", forIndexPath: indexPath) as! SPProfileNotificationsTableViewCell
//            profileInfoViewModel.notifications[indexPath.row] as! SPActivity
            cell.setupCell(profileInfoViewModel.notifications[indexPath.row])
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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch currentViewState {
        case .Posts:
            return 136
        case .Followers, .Following, .Notifications:
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
        self.clearNotifications()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.reloadData()
    }
    
    //MARK: SPProfilePostTableViewCell Delegate Methods
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
    
    func deleteFeedItem( feedItem: SPFeedItem ) {
        
        let alertController = UIAlertController(title: "Are you sure you want to delete this post?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            var feedPosts = self.profileInfoViewModel.posts
            var indexToRemove = -1
            for var i = feedPosts.count - 1; i >= 0; --i {
                var searchPost = feedPosts[ i ]
                if searchPost == feedItem {
                    indexToRemove = i
                    break
                }
            }
            
            if indexToRemove >= 0 {
                feedPosts.removeAtIndex( indexToRemove )
                SPManager.sharedInstance.removePostWithPhotoPairObjectId( feedItem.photos!.objectId )
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }

    
    func findFriendsButtonDidTap( sender:AnyObject ) {
        var findFriendsController = SPFindFriendsTableViewController()
        self.navigationController?.pushViewController(findFriendsController, animated: true)
    }
    
    func settingsButtonDidTap(sender: AnyObject!){
        println("HI!")
        
        let storyboard = UIStoryboard(name: "SPSettingsStoryboard", bundle: nil)
        let settingsNavigationController = storyboard.instantiateViewControllerWithIdentifier("SPSettingsStoryboard") as! UINavigationController
        self.presentViewController(settingsNavigationController, animated: true, completion: nil)
    }

    
    func clearNotifications(){
        let currentInstallation = PFInstallation.currentInstallation()
        if(currentInstallation.badge != 0){
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("Badges", object: nil)
        self.toolBarView.notificationsBadge.hidden = true
        self.toolBarView.notificationsBadge.text = "\(UIApplication.sharedApplication().applicationIconBadgeNumber)"
        
    }
}
