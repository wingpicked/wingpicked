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

class SPFeedDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SPLikeCommentButtonViewDelegate, SPCommentsSmallTableViewCellDelegate, SPFeedDetailCollaborationTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var imageFile : PFFile!
    var feedItem: SPFeedItem!
    var imageTapped : ImageIdentifier!
    var tableViewFooterView : SPLikeCommentButtonView!
    var showDeleteButton = false
    var profileDelegate : SPFeedDetailViewControllerDelegate?
    var commentsCount = 0
    
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
    }
    
    required init(coder aDecoder: NSCoder) {
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

        if self.showDeleteButton {
            self.tableViewFooterView.deleteButton.hidden = false
        }
        self.setupFollowButton()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO: Refactor this to get a base cell or something out of here so there isn't duplicate code.
        println("--Index Path: \(indexPath.row)")
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailPictureTableViewCell", forIndexPath: indexPath) as! SPFeedDetailPictureTableViewCell
            cell.setupCell(self.feedItem, imageFile: imageFile)
            //cell.setupCell(imageFile)
            return cell
        }
        else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailCollaborationTableViewCell", forIndexPath: indexPath) as! SPFeedDetailCollaborationTableViewCell

            cell.delegate = self
            
            let noPhotoLiked = self.feedItem.photoUserLikes == PhotoUserLikes.NoPhotoLiked
            let usersOwnPhotoPair = self.feedItem.photos?.user.objectId == PFUser.currentUser()!.objectId
            
            if(!usersOwnPhotoPair && noPhotoLiked){
                cell.percentageLabel.hidden = true
                cell.likeCountButton.hidden = true
                cell.commentCountButton.hidden = true
            }
            else{
                if self.imageTapped == ImageIdentifier.ImageOne{
                    cell.percentageLabel.text = "\(self.feedItem.percentageLikedOne)%"
                    cell.likeCountButton.setTitle("\(self.feedItem.likesCountOne) likes", forState: .Normal)
                    cell.commentCountButton.setTitle("view all \(self.feedItem.commentsCountOne) comments", forState: .Normal)
                }
                if self.imageTapped == ImageIdentifier.ImageTwo {
                    cell.percentageLabel.text = "\(self.feedItem.percentageLikedTwo)%"
                    cell.likeCountButton.setTitle("\(self.feedItem.likesCountTwo) likes", forState: .Normal)
                    cell.commentCountButton.setTitle("view all \(self.feedItem.commentsCountTwo) comments", forState: .Normal)
                }
            }
            return cell
        }
        else if(indexPath.row > 1 && indexPath.row < 2 + commentsCount){
            println("--\(commentsCount)")
            let cell = tableView.dequeueReusableCellWithIdentifier("SPCommentsSmallTableViewCell", forIndexPath: indexPath) as! SPCommentsSmallTableViewCell
            cell.delegate = self
            
            //TODO: Refactor the photo pair model to consist of two individual entities
            var comments = []
            if self.imageTapped == ImageIdentifier.ImageTwo{
                comments = self.feedItem.comments.commentsPhotoTwo
            }
            if self.imageTapped == ImageIdentifier.ImageOne {
                comments = self.feedItem.comments.commentsPhotoOne
            }
            
            cell.setupCell(comments[indexPath.row - 2] as! SPActivity)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SPLikeCommentButtonView", forIndexPath: indexPath) as! SPLikeCommentButtonView
            cell.delegate = self
            cell.setupCell(self.imageTapped, feedItem: self.feedItem)
            return cell
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsCount + 3 //for three static cells
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 382
        }
        else if(indexPath.row == 1){
            return 54
        }
        else if(indexPath.row > 1 && indexPath.row < 2 + commentsCount){
            return 23
        }
        else{
            return 44
        }
        
    }
    
    func setupFollowButton() {
        
        if self.feedItem.photos?.user.objectId != SPUser.currentUser()!.objectId {
            var followButtonName = self.feedItem.isCurrentUserFollowing ? "Button_following_NavBar" : "Button_follow_NavBar"
            var rightButtonImageView = UIImageView(image:UIImage(named:followButtonName))
            rightButtonImageView.frame = CGRectMake(0,0,90, 25)
            rightButtonImageView.userInteractionEnabled = true
            var tapRecognizer = UITapGestureRecognizer(target: self, action: "followButtonDidTap")
            rightButtonImageView.addGestureRecognizer(tapRecognizer)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButtonImageView)
            
        }
    }
    
    func showAllComments() {
        var commentsViewController = SPCommentsViewController()
        commentsViewController.setup(self.feedItem, imageTapped:self.imageTapped)
        commentsViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
    
    //MARK - LikeCommentButton Delegate Methods
    func likeButtonTapped() {
        println("Like Button Tapped")
    }
    
    func commentButtonTapped() {
        println("Comment Button Tapped")
        self.showAllComments()
    }

    //MARK - SPFeedDetailCollaboration Delegate Methods
    func likesButtonTapped() {
        let likesViewController = SPLikesViewController(nibName: "SPLikesViewController", bundle: nil)
        likesViewController.imageTapped = self.imageTapped
        likesViewController.feedItem = self.feedItem
        likesViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(likesViewController, animated: true)
    }
    
    func commentsButtonTapped() {
        showAllComments()
    }
    
    func didSelectComment(user: SPUser) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("SPProfileViewController") as! SPProfileViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
        profileViewController.showWithUser(user)
    }
    
    func followButtonDidTap() {
        if self.feedItem.isCurrentUserFollowing {
            SPManager.sharedInstance.unfollowUser(self.feedItem.photos?.user, resultBlock: { (success, error) -> Void in
                println( "unfollowed User" )
            })
        } else {
            SPManager.sharedInstance.followUser(self.feedItem.photos?.user, resultBlock: { (success, error) -> Void in
                println( "followed User" )
            })
        }
        
        self.feedItem.isCurrentUserFollowing = !self.feedItem.isCurrentUserFollowing
        self.setupFollowButton()
    }
    
    func deleteButtonDidTap() {
        self.profileDelegate?.deleteFeedItem!(self.feedItem)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
}
