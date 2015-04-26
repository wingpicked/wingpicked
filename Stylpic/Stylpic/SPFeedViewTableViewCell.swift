//
//  SPFeedViewTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit


class SPFeedViewTableViewCell: SPBaseFeedViewTableViewCell {

//    @IBOutlet weak var pictureImageView: PFImageView!
//    @IBOutlet weak var pictureImageView2: PFImageView!
//
//    @IBOutlet weak var imageOnePercentLabel: UILabel!
//    @IBOutlet weak var imageOneLikeLabel: UILabel!
//    @IBOutlet weak var imageOneCommentLabel: UILabel!
//    
//    @IBOutlet weak var imageTwoPercentLabel: UILabel!
//    @IBOutlet weak var imageTwoLikeLabel: UILabel!
//    @IBOutlet weak var imageTwoCommentLabel: UILabel!
    
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var actualContentView: UIView!
    
    @IBOutlet weak var statsArea: UIView!
    @IBOutlet weak var imageOneLikeButton: UIButton!
    @IBOutlet weak var imageTwoLikeButton: UIButton!
    
    @IBOutlet weak var postedTimeLabel: UILabel!
    
    @IBOutlet weak var profilePictureImageView: PFImageView!
    @IBOutlet weak var userDisplayName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.actualContentView.layer.cornerRadius = 3.0
        self.actualContentView.layer.shadowRadius = 2.0
        self.actualContentView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        self.actualContentView.layer.shadowOpacity = 0.3;
        
        profilePictureImageView.userInteractionEnabled = true
        var tap1 = UITapGestureRecognizer(target: self, action: "userInfoDidTap:")
        profilePictureImageView.addGestureRecognizer(tap1)
        
        userDisplayName.userInteractionEnabled = true
        var tap2 = UITapGestureRecognizer(target: self, action: "userInfoDidTap:")
        userDisplayName.addGestureRecognizer(tap2)
    }
    
    override func setupWithFeedItem(feedItem: SPFeedItem){
        super.setupWithFeedItem(feedItem) //Does a lot of heavy lifting that is in common with SPFeedViewTableViewCell and SPProfileFeedTableViewCell
        
        self.caption.text = feedItem.caption
    
        if let user = feedItem.photos?["user"] as? SPUser {
            user.fetchIfNeededInBackgroundWithBlock({ (obj, error) -> Void in
                if let profilePicture = user.profilePicture {
                    self.userDisplayName.text = user.spDisplayName()
                    self.profilePictureImageView.file = profilePicture
                    self.profilePictureImageView.loadInBackground(nil)
                }
                else {
                    self.profilePictureImageView = nil
                }
            })
        }

        if self.feedItem?.photoUserLikes == PhotoUserLikes.FirstPhotoLiked {
            imageOneLikeButton.setImage(UIImage(named: "Icon_likes_onSelectedPhoto2"), forState: UIControlState.Normal)
            imageTwoLikeButton.hidden = true
            imageOneLikeButton.hidden = false
        } else if self.feedItem?.photoUserLikes == PhotoUserLikes.SecondPhotoLiked {
            imageTwoLikeButton.setImage(UIImage(named: "Icon_likes_onSelectedPhoto2"), forState: UIControlState.Normal)
            imageTwoLikeButton.hidden = false
            imageOneLikeButton.hidden = true
        } else {
            imageTwoLikeButton.setImage(UIImage(named: "Button_like_feed"), forState: UIControlState.Normal)
            imageOneLikeButton.setImage(UIImage(named: "Button_like_feed"), forState: UIControlState.Normal)
            imageTwoLikeButton.hidden = false
            imageOneLikeButton.hidden = false            
        }
        
        let noPhotoLiked = self.feedItem?.photoUserLikes == PhotoUserLikes.NoPhotoLiked
        let usersOwnPhotoPair = self.feedItem?.photos?.user.objectId == PFUser.currentUser().objectId
        statsArea.hidden = !usersOwnPhotoPair && noPhotoLiked
        
        if let timeIntervalSincePost = feedItem.timeintervalSincePost{
            postedTimeLabel.text = String(timeIntervalSincePost)
        }
        else{
            postedTimeLabel.text = "NA"
        }
    }
    
    
    func userInfoDidTap( sender: AnyObject ) {
        if let feedItem = self.feedItem {
            self.delegate?.didRequestUserProfile(feedItem)
        }
    }
    
    
    @IBAction func imageOneLiked(sender: AnyObject) {
        println( "in imageOneliked" )
        if self.feedItem?.photoUserLikes == PhotoUserLikes.NoPhotoLiked {
            imageOneLikeButton.setImage(UIImage(named: "Icon_likes_onSelectedPhoto2"), forState: UIControlState.Normal)
            imageTwoLikeButton.hidden = true

            SPManager.sharedInstance.likePhoto(ActivityType.LikeImageOne, photoPair: self.feedItem?.photos) { (success, error) -> Void in
                if success {
                    println( "saving like was a success" )
                } else {
                    println( "save like failed" )
                }
                
                if error != nil {
                    println( error )
                }
            }
            
            self.feedItem?.photoUserLikes = PhotoUserLikes.FirstPhotoLiked
            self.feedItem?.likesCountOne++
            self.imageOneLikeLabel.text = "\(self.feedItem?.likesCountOne)"
            self.updatePercentages()
        } else {
            UIAlertView(title: "Already liked", message: "You already liked a photo in this post", delegate: nil, cancelButtonTitle: "Ok" ).show()
        }
    }

    @IBAction func imageTwoLiked(sender: AnyObject) {
        println( "in imageTwoliked" )
        if self.feedItem?.photoUserLikes == PhotoUserLikes.NoPhotoLiked {
            self.imageTwoLikeButton.setImage(UIImage(named: "Icon_likes_onSelectedPhoto2"), forState: UIControlState.Normal)
            self.imageOneLikeButton.hidden = true
            SPManager.sharedInstance.likePhoto(ActivityType.LikeImageTwo, photoPair: self.feedItem?.photos) { (success, error) -> Void in
                if success {
                    println( "saving like was a success" )
                } else {
                    println( "save like failed" )
                }
                
                if error != nil {
                    println( error )
                }
            }
            if let feedItem = self.feedItem {
                
                feedItem.photoUserLikes = PhotoUserLikes.SecondPhotoLiked
                feedItem.likesCountTwo++
                self.imageTwoLikeLabel.text = "\(feedItem.likesCountTwo)"
            }
            
            self.updatePercentages()
        } else {
            UIAlertView(title: "Already liked", message: "You already liked a photo in this post", delegate: nil, cancelButtonTitle: "Ok" ).show()
        }
    }
    
    func updatePercentages() {
        if let feedItem = self.feedItem {
            var totalLikes = Double(feedItem.likesCountOne + feedItem.likesCountTwo)
            feedItem.percentageLikedOne = 100.0 * Double(feedItem.likesCountOne) / totalLikes
            feedItem.percentageLikedTwo = 100.0 * Double(feedItem.likesCountTwo) / totalLikes
            self.imageOnePercentLabel.text = NSString( format:"%.1f", feedItem.percentageLikedOne ) as String
            self.imageTwoPercentLabel.text = NSString( format:"%.1f", feedItem.percentageLikedTwo ) as String
        }
        
    }
    
    
}
