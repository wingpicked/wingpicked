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
        
        //self.feedItem.addObserver(self, forKeyPath: "commentsCountTwo", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
//        self.imageFile = PFFile() //TODO: Place default image here.
//        self.feedItem = SPFeedItem()
//        self.imageTapped = ImageIdentifier.ImageOne
        super.init(coder: aDecoder)
    }
    
//    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
//        if(keyPath == "commentsCountTwo"){
//            println("hi")
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "PHOTO"
        
        self.tableView.registerNib(UINib(nibName: "SPFeedDetailPictureTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailPictureTableViewCell")
        self.tableView.registerNib(UINib(nibName:"SPCommentsSmallTableViewCell", bundle: nil), forCellReuseIdentifier: "SPCommentsSmallTableViewCell")
        self.tableView.registerNib(UINib(nibName: "SPFeedDetailCollaborationTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailCollaborationTableViewCell")
        self.tableViewFooterView = NSBundle.mainBundle().loadNibNamed("SPLikeCommentButtonView", owner: self, options: nil).first as! SPLikeCommentButtonView
        println(self.tableViewFooterView)
        if self.showDeleteButton {
            self.tableViewFooterView.deleteButton.hidden = false
        }
        self.setupFollowButton()
        self.setupLikeCommentButtonView()

        
        self.tableViewFooterView.delegate = self
        self.tableViewFooterView.userInteractionEnabled = true
        tableViewFooterView.userInteractionEnabled = true
//        self.tableView.tableFooterView = tableViewFooterView
        //self.tableView.tableFooterView!.frame = CGRectMake(0, 0, 320, 100)
    }
    
    func setupLikeCommentButtonView(){
        var likeImage : UIImage!
        if self.imageTapped == ImageIdentifier.ImageOne{
            if(self.feedItem.photoUserLikes == PhotoUserLikes.FirstPhotoLiked){
              likeImage = UIImage(named: "likeafterclick")
            }
            else if(self.feedItem.photoUserLikes == PhotoUserLikes.NoPhotoLiked){
                likeImage = UIImage(named: "like")
            }
            else{
                likeImage = UIImage(named: "nolike")
            }
        }
        if self.imageTapped == ImageIdentifier.ImageTwo{
            if(self.feedItem.photoUserLikes == PhotoUserLikes.SecondPhotoLiked){
                likeImage = UIImage(named: "likeafterclick")
            }
            else if(self.feedItem.photoUserLikes == PhotoUserLikes.NoPhotoLiked){
                likeImage = UIImage(named: "like")
            }
            else{
                likeImage = UIImage(named: "nolike")
            }
        }
        
        self.tableViewFooterView.likeButton.setImage(likeImage, forState: .Normal)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO: Refactor this to get a base cell or something out of here so there isn't duplicate code.
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
        else {
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
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var comments = self.feedItem.comments.commentsPhotoTwo
        if self.imageTapped == ImageIdentifier.ImageOne {
            comments = self.feedItem.comments.commentsPhotoOne
        }

        return comments.count + 2 //for two static cells
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 382
        }
        else if(indexPath.row == 1){
            return 54
        }
        else{
            return 23
        }
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.tableViewFooterView;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 27.0
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
    
    
}
