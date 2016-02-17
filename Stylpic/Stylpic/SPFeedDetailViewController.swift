//
//  SPFeedDetailViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 2/8/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

@objc protocol SPFeedDetailViewControllerDelegate {
    optional func deleteFeedItem( feedItem: SPFeedItem )
}

let kCommentsCount = 4

class SPFeedDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SPLikeCommentButtonViewDelegate, SPCommentsSmallTableViewCellDelegate, SPFeedDetailCollaborationTableViewCellDelegate, SPFeedDetailPictureTableViewCellDelegate, SPCommentsViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    var imageFile : PFFile!
    var feedItem: SPFeedItem!
    var imageTapped : ImageIdentifier!
    var profileDelegate : SPFeedDetailViewControllerDelegate?
    var commentsCount = 0
    var commentsToDisplay = 0
    
    init(feedItem : SPFeedItem, imageTapped: ImageIdentifier) {
        self.imageTapped = imageTapped
        self.feedItem = feedItem
        
        
        var imageTapedKey = "photoTwo"
        if imageTapped == ImageIdentifier.ImageOne {
            imageTapedKey = "photoOne"
        }
        
        let photo = self.feedItem.photos?.objectForKey(imageTapedKey) as! SPPhoto
        
        self.imageFile = photo.photo
        super.init(nibName: "SPFeedDetailViewController", bundle: nil)

        self.commentsCount = self.feedItem.commentsCountOne
        if self.imageTapped == ImageIdentifier.ImageTwo {
            self.commentsCount = self.feedItem.commentsCountTwo
        }
        commentsToDisplay = self.commentsCount > kCommentsCount ? kCommentsCount : self.commentsCount

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reloadTableView(){
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "PHOTO"
        
        self.tableView.registerNib(UINib(nibName: "SPFeedDetailPictureTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailPictureTableViewCell")
        self.tableView.registerNib(UINib(nibName:"SPCommentsSmallTableViewCell", bundle: nil), forCellReuseIdentifier: "SPCommentsSmallTableViewCell")
        self.tableView.registerNib(UINib(nibName: "SPFeedDetailCollaborationTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailCollaborationTableViewCell")
        self.tableView.registerNib(UINib(nibName: "SPLikeCommentButtonView", bundle: nil), forCellReuseIdentifier: "SPLikeCommentButtonView")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableView", name: "RefreshViewControllers", object: nil)
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        self.tableView.estimatedRowHeight = 23
        self.setupFollowButton()

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let usersOwnPhotoPair = self.feedItem.photos?.user.objectId == PFUser.currentUser()!.objectId

        //TODO: Refactor this to get a base cell or something out of here so there isn't duplicate code.
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailPictureTableViewCell", forIndexPath: indexPath) as! SPFeedDetailPictureTableViewCell
            cell.setupCell(self.feedItem, imageFile: imageFile)
            cell.delegate = self
            //cell.setupCell(imageFile)
            return cell
        }
        else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("SPLikeCommentButtonView", forIndexPath: indexPath) as! SPLikeCommentButtonView
            cell.delegate = self
            cell.setupCell(self.imageTapped, feedItem: self.feedItem)
            
            if usersOwnPhotoPair {
                cell.deleteButton.hidden = false
            }
            else{
                cell.deleteButton.hidden = true
            }
            
            return cell
        }
        else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailCollaborationTableViewCell", forIndexPath: indexPath) as! SPFeedDetailCollaborationTableViewCell

            cell.delegate = self
            
            let noPhotoLiked = self.feedItem.photoUserLikes == PhotoUserLikes.NoPhotoLiked
            
            
            let hiddenFlag = !usersOwnPhotoPair && noPhotoLiked
            cell.percentageLabel.hidden = hiddenFlag
            cell.likeCountButton.hidden = hiddenFlag
            cell.commentCountButton.hidden = hiddenFlag
            cell.heartIcon.hidden = hiddenFlag
            cell.percentIcon.hidden = hiddenFlag

            if(self.commentsCount < kCommentsCount){
                cell.commentCountButton.hidden = true
            }
                
                if self.imageTapped == ImageIdentifier.ImageOne{
                    let likeVerbiage = self.feedItem.likesCountOne == 1 ? "Like" : "Likes"
                    cell.percentageLabel.text = "\(self.feedItem.percentageLikedOne) Percent"
                    cell.likeCountButton.setTitle("\(self.feedItem.likesCountOne) \(likeVerbiage)", forState: .Normal)
                    cell.commentCountButton.setTitle("View all \(self.feedItem.commentsCountOne) comments", forState: .Normal)
                    cell.commentCountButton.hidden = feedItem.commentsCountOne < 4
                    
                }
                if self.imageTapped == ImageIdentifier.ImageTwo {
                    let likeVerbiage2 = self.feedItem.likesCountTwo == 1 ? "Like" : "Likes"
                    cell.percentageLabel.text = "\(self.feedItem.percentageLikedTwo) Percent"
                    cell.likeCountButton.setTitle("\(self.feedItem.likesCountTwo) \(likeVerbiage2)", forState: .Normal)
                    cell.commentCountButton.setTitle("View all \(self.feedItem.commentsCountTwo) comments", forState: .Normal)
                    cell.commentCountButton.hidden = feedItem.commentsCountTwo < 4
                }
            return cell
        }
        else // indexPath.row > 1 && indexPath.row < 2 + commentsCount){
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("SPCommentsSmallTableViewCell", forIndexPath: indexPath) as! SPCommentsSmallTableViewCell
            cell.delegate = self
            
            //TODO: Refactor the photo pair model to consist of two individual entities
            var comments = []
            if self.imageTapped == ImageIdentifier.ImageTwo{
                comments = self.feedItem.comments.sortedCommentsPhotoTwo
            }
            if self.imageTapped == ImageIdentifier.ImageOne {
                comments = self.feedItem.comments.sortedCommentsPhotoOne
            }
            
            // was indexPath.row - 3 
            let requestedRow = indexPath.row - 3
            if requestedRow < comments.count && 0 < comments.count {
                cell.setupCell(comments[requestedRow] as! SPActivity)
            }
            return cell
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsToDisplay + 3 //for three static cells
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 382
        }
        else if(indexPath.row == 1) {
            return 44
        }
        else if (indexPath.row == 2){
            if commentsCount >= 4 {
                return 42
            } else {
                return 23
            }
        }
        else{
            return UITableViewAutomaticDimension
        }
        
    }
    
    
    func setupFollowButton() {
        
        if self.feedItem.photos?.user.objectId != SPUser.currentUser()!.objectId {
            let followButtonName = self.feedItem.isCurrentUserFollowing ? "Button_following_NavBar" : "Button_follow_NavBar"
            let rightButtonImageView = UIImageView(image:UIImage(named:followButtonName))
            rightButtonImageView.frame = CGRectMake(0,0,90, 25)
            rightButtonImageView.userInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: "followButtonDidTap")
            rightButtonImageView.addGestureRecognizer(tapRecognizer)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButtonImageView)
            
        }
    }
    
    //MARK - LikeCommentButton Delegate Methods
    func likeButtonTapped() {
        var activityType : ActivityType!
        if(imageTapped == ImageIdentifier.ImageOne){
            activityType = ActivityType.LikeImageOne
            feedItem.photoUserLikes = PhotoUserLikes.FirstPhotoLiked
            feedItem.likesCountOne++
            feedItem.percentageLikedOne = (feedItem.likesCountOne / (feedItem.likesCountOne + feedItem.likesCountTwo)) * 100
        }
        if(imageTapped == ImageIdentifier.ImageTwo){
            activityType = ActivityType.LikeImageTwo
            feedItem.photoUserLikes = PhotoUserLikes.SecondPhotoLiked
            feedItem.likesCountTwo++
            feedItem.percentageLikedTwo  = (feedItem.likesCountTwo / (feedItem.likesCountOne + feedItem.likesCountTwo)) * 100
        }
        
        self.tableView.reloadData()
        
        SPManager.sharedInstance.likePhoto(activityType, photoPair: self.feedItem?.photos) { (success, error) -> Void in
            if(error == nil){
                
                NSNotificationCenter.defaultCenter().postNotificationName("RefreshViewControllers", object: nil)
            }
        }

    }
    
    func commentButtonTapped() {
        let commentsViewController = self.createCommentsViewController()
        commentsViewController.keyboardPresentedOnLoad = true
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
    
    func commentsButtonTapped() {
        let commentsViewController = self.createCommentsViewController()
        commentsViewController.keyboardPresentedOnLoad = false
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }

    func createCommentsViewController() -> SPCommentsViewController {
        let commentsViewController = SPCommentsViewController()
        commentsViewController.setup(self.feedItem, imageTapped:self.imageTapped)
        commentsViewController.hidesBottomBarWhenPushed = true
        commentsViewController.delegate = self
        return commentsViewController

    }

    
    //MARK - SPFeedDetailCollaboration Delegate Methods
    func likesButtonTapped() {
        let likesViewController = SPLikesViewController(nibName: "SPLikesViewController", bundle: nil)
        likesViewController.imageTapped = self.imageTapped
        likesViewController.feedItem = self.feedItem
        likesViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(likesViewController, animated: true)
    }
    
    func didSelectComment(user: SPUser) {
        self.showUserProfile(user)
    }
    
    func followButtonDidTap() {
        if self.feedItem.isCurrentUserFollowing {
            SPManager.sharedInstance.unfollowUser(self.feedItem.photos?.user, resultBlock: { (success, error) -> Void in
                if(error != nil){
                    print(error?.localizedDescription)
                }
            })
        } else {
            SPManager.sharedInstance.followUser(self.feedItem.photos?.user, resultBlock: { (success, error) -> Void in
                if(error != nil){
                    print(error?.localizedDescription)
                }
            })
        }
        
        self.feedItem.isCurrentUserFollowing = !self.feedItem.isCurrentUserFollowing
        self.setupFollowButton()
    }
    
    func deleteButtonDidTap() {
        let alertController = UIAlertController(title: "Are you sure you want to delete this post?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { (action) -> Void in
                SPManager.sharedInstance.removePostWithPhotoPairObjectId(self.feedItem.photos!.objectId!, resultBlock: { (success, error) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("RefreshViewControllers", object: nil)
                    self.navigationController?.popViewControllerAnimated(true)
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didTapUserProfile() {
        if let user = feedItem.photos?["user"] as? SPUser {
            self.showUserProfile(user)
        }

    }
    
    func showUserProfile(user: SPUser){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("SPProfileViewController") as! SPProfileViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
        profileViewController.showWithUser(user)
    }
    
    func didAddCommentToPhotoOne(comment: SPActivity) {
        self.commentsCount = self.feedItem.commentsCountOne
        commentsToDisplay = self.commentsCount > kCommentsCount ? kCommentsCount : self.commentsCount
        self.reloadTableView()
    }
    func didAddCommentToPhotoTwo(comment: SPActivity) {
        self.commentsCount = self.feedItem.commentsCountTwo
        commentsToDisplay = self.commentsCount > kCommentsCount ? kCommentsCount : self.commentsCount
        self.reloadTableView()
    }
    

}
