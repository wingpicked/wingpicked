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

class SPProfileViewController: UITableViewController, SPProfileToolBarViewDelegate, SPFeedViewTableViewCellDelegate, SPProfileEmptyFollowersViewDelegate, SPProfileEmptyFollowingViewDelegate, SPFeedDetailViewControllerDelegate {

    var isStaleData = true
    
    var currentViewState = SPProfileActiveViewState.Posts
        {
        didSet{
            switch oldValue{
            case .Posts:
                self.toolBarView.postsLabel.textColor = UIColor.darkGrayColor()
                self.toolBarView.postsButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                break
            case .Followers:
                self.toolBarView.followersLabel.textColor = UIColor.darkGrayColor()
                self.toolBarView.followersButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                break
            case .Following:
                self.toolBarView.followingLabel.textColor = UIColor.darkGrayColor()
                self.toolBarView.followingButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                break
            case .Notifications:
                self.toolBarView.notificationLabel.textColor = UIColor.darkGrayColor()
                self.toolBarView.notificationBellImageView.image = UIImage(named: "notification_bell")
                break
            }

            
            switch currentViewState{
            case .Posts:
                self.toolBarView.postsLabel.textColor = primaryAquaColor
                self.toolBarView.postsButton.setTitleColor(primaryAquaColor, forState: .Normal)
                break
            case .Followers:
                self.toolBarView.followersLabel.textColor = primaryAquaColor
                self.toolBarView.followersButton.setTitleColor(primaryAquaColor, forState: .Normal)
                break
            case .Following:
                self.toolBarView.followingLabel.textColor = primaryAquaColor
                self.toolBarView.followingButton.setTitleColor(primaryAquaColor, forState: .Normal)
                break
            case .Notifications:
                self.toolBarView.notificationLabel.textColor = primaryAquaColor
                self.toolBarView.notificationBellImageView.image = UIImage(named: "notification_bell_selected")
                break
            }
        }
    }
    
    let emptyStateNoItems: UIView = NSBundle.mainBundle().loadNibNamed("SPProfileEmptyItemsView", owner: nil, options: nil)[0] as! UIView
    let emptyStateFollowing: SPProfileEmptyFollowingView = NSBundle.mainBundle().loadNibNamed("SPProfileEmptyFollowingView", owner: nil, options: nil)[0] as! SPProfileEmptyFollowingView
    let emptyStateFollowers: SPProfileEmptyFollowersView = NSBundle.mainBundle().loadNibNamed("SPProfileEmptyFollowersView", owner: nil, options: nil)[0] as! SPProfileEmptyFollowersView
    
    var toolBarView : SPProfileToolBarView!
    var headerView : SPProfileHeaderView!
    
    var profileInfoViewModel = SPProfileInfo()
    var showForUser : SPUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if self.showForUser?.objectId == SPUser.currentUser()!.objectId {
            self.toolBarView = NSBundle.mainBundle().loadNibNamed("SPProfileToolBarView", owner: self, options: nil).first as! SPProfileToolBarView
            self.headerView = NSBundle.mainBundle().loadNibNamed("SPProfileHeaderView", owner: self, options: nil).first as! SPProfileHeaderView
        }
        else{
            self.toolBarView = NSBundle.mainBundle().loadNibNamed("SPProfileToolBarPublicView", owner: self, options: nil).first as! SPProfileToolBarView
            self.headerView = NSBundle.mainBundle().loadNibNamed("SPProfileHeaderOtherUserView", owner: self, options: nil).first as! SPProfileHeaderView
        }
        
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

        self.toolBarView.postsLabel.textColor = primaryAquaColor
        self.toolBarView.postsButton.setTitleColor(primaryAquaColor, forState: .Normal)

        self.emptyStateFollowers.delegate = self
        self.emptyStateFollowing.delegate = self
        self.tableView.tableFooterView = UIView()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(self.isStaleData){
            self.tableView.contentOffset = CGPointMake(0, -self.refreshControl!.frame.size.height);
            self.refreshControl!.beginRefreshing()
            self.showWithUser(showForUser)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateView() {
        self.isStaleData = true
    }
    
    func showWithUser( user: SPUser ) {
        self.showForUser = user
        self.navigationItem.title = user.spDisplayName().uppercaseString
        if self.showForUser?.objectId == SPUser.currentUser()!.objectId {
            let findFriendsButton = UIBarButtonItem(image: UIImage( named: "Icon_invite" ), style: .Plain, target: self, action: "findFriendsButtonDidTap:")
            self.navigationItem.leftBarButtonItem = findFriendsButton
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 158/255, green: 228/255, blue: 229/255, alpha: 1.0)
            
            let settingsButton = UIBarButtonItem(image: UIImage(named: "Icon_settings"), style: .Plain, target: self, action: "settingsButtonDidTap:")
            self.navigationItem.rightBarButtonItem = settingsButton
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 158/255, green: 228/255, blue: 229/255, alpha: 1.0)
        }
        
        if((user == SPUser.currentUser() && isStaleData) || user != SPUser.currentUser()){
        SPManager.sharedInstance.getProfileInfo(user, resultBlock: { (profileObject, error) -> Void in
            if(error == nil){
                if let profileObject = profileObject {
                    self.profileInfoViewModel = profileObject as SPProfileInfo
                    self.headerView.setupCell(self.profileInfoViewModel.isFollowing, user: user )
                    self.headerView.followButton.hidden = ( PFUser.currentUser()!.objectId == user.objectId)
                    self.configureEmptyStateIfNeeded()
                    self.updateToolbarUI()
                    
                    self.tableView.reloadData()
                    self.isStaleData = false
                }
            }
            else{
                println(error!.localizedDescription)
            }
            self.refreshControl?.endRefreshing()
        })
        }
        else{
            self.refreshControl?.endRefreshing()
        }
    }
    
    func configureEmptyStateIfNeeded() {
        switch currentViewState {
            case .Posts:
                if self.profileInfoViewModel.posts.count > 0 {
                    self.tableView.backgroundView = nil
                } else {
                    self.tableView.backgroundView = self.emptyStateNoItems
                }
                
                break;
            case .Followers:
                if self.profileInfoViewModel.followers.count > 0 {
                    self.tableView.backgroundView = nil
                } else {
                    self.tableView.backgroundView = self.emptyStateFollowers
                }
                
                break;
            case .Following:
                if self.profileInfoViewModel.following.count > 0 {
                    self.tableView.backgroundView = nil
                } else {
                    self.tableView.backgroundView = self.emptyStateFollowing
                }
                break;
            case .Notifications:
                self.tableView.backgroundView = nil
                break;
        }
        
    }
    
    
    func refreshTableView(){
        self.showWithUser(self.showForUser)
    }
    
    func updateToolbarUI(){
        self.toolBarView.postsButton.setTitle("\(self.profileInfoViewModel.postsCount)", forState: .Normal)
        self.toolBarView.followersButton.setTitle("\(self.profileInfoViewModel.followersCount)", forState: .Normal)
        self.toolBarView.followingButton.setTitle("\(self.profileInfoViewModel.followingCount)", forState: .Normal)
        
        if(self.toolBarView.notificationsBadge != nil){
            let badgeNum = UIApplication.sharedApplication().applicationIconBadgeNumber
            if badgeNum > 0 {
                self.toolBarView.notificationsBadge.text = "\(badgeNum)"
                self.toolBarView.notificationsBadge.hidden = false
            } else {        
                self.toolBarView.notificationsBadge.hidden = true
            }
        }
    }
    
    //MARK: Tableview Datasource and Delegate Methods
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch currentViewState {
        case .Posts:
            let cell = tableView.dequeueReusableCellWithIdentifier("SPProfilePostTableViewCell", forIndexPath: indexPath) as! SPProfilePostTableViewCell
            cell.setupWithFeedItem(profileInfoViewModel.posts[indexPath.row])
            cell.delegate = self
//            cell.profilePostDelegate = self
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
            return 158
        case .Followers, .Following, .Notifications:
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       switch currentViewState {
        case .Followers:
            let user = profileInfoViewModel.followers[indexPath.row]
            showProfileViewControllerForUser(user)
            break
        case .Following:
            let user = profileInfoViewModel.following[indexPath.row]
            showProfileViewControllerForUser(user)
            break
        case .Notifications:
            let activity:SPActivity = profileInfoViewModel.notifications[indexPath.row]
            let user = activity.fromUser
            showProfileViewControllerForUser(user)            
            break
        default:
            break
        }
    }
    
    func showProfileViewControllerForUser(user : SPUser){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("SPProfileViewController") as! SPProfileViewController
        profileViewController.showWithUser(user)
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    //MARK: SPProfile Toolbar Delegate
    func postsButtonTapped() {
        currentViewState = .Posts
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.reloadData()
        self.configureEmptyStateIfNeeded()
    }
    func followersButtonTapped() {
        currentViewState = .Followers
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.reloadData()
        self.configureEmptyStateIfNeeded()
    }
    func followingButtonTapped() {
        currentViewState = .Following
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.reloadData()
        self.configureEmptyStateIfNeeded()
    }
    func notificationsButtonTapped() {
        currentViewState = .Notifications
        self.clearNotifications()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.reloadData()
        self.configureEmptyStateIfNeeded()
    }
    
    //MARK: SPProfilePostTableViewCell Delegate Methods
    func didTapPhotoOne(feedItem: SPFeedItem) {
        var detailViewController = SPFeedDetailViewController(feedItem: feedItem, imageTapped: ImageIdentifier.ImageOne)
        detailViewController.profileDelegate = self
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    func didTapPhotoTwo(feedItem: SPFeedItem) {
        var detailViewController = SPFeedDetailViewController(feedItem: feedItem, imageTapped: ImageIdentifier.ImageTwo)
        detailViewController.profileDelegate = self
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
    
    func findFriendsButtonDidTap(sender:AnyObject?) {
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
            currentInstallation.saveEventually(nil)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("Badges", object: nil)
        self.toolBarView.notificationsBadge.hidden = true
        self.toolBarView.notificationsBadge.text = "\(UIApplication.sharedApplication().applicationIconBadgeNumber)"
        
    }
    
    
    func findFriendsButtonDidTap() {
        self.findFriendsButtonDidTap(nil)
    }

}
