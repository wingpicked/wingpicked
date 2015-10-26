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
    //@IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var userDisplayNameButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.actualContentView.layer.cornerRadius = 3.0
        self.actualContentView.layer.shadowRadius = 1.0
        self.actualContentView.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        self.actualContentView.layer.shadowOpacity = 0.2
//        let shadowFrame = actualContentView.layer.bounds
//        let shadowPath = UIBezierPath(rect: shadowFrame).CGPath
//        actualContentView.layer.shadowPath = shadowPath; //performance
        
        profilePictureImageView.userInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: "userInfoDidTap:")
        profilePictureImageView.addGestureRecognizer(tap1)
        
        self.postedTimeLabel.preferredMaxLayoutWidth = 72
        self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.width / 2.0
        self.profilePictureImageView.clipsToBounds = true
    }
    
    override func setupWithFeedItem(feedItem: SPFeedItem){
        super.setupWithFeedItem(feedItem) //Does a lot of heavy lifting that is in common with SPFeedViewTableViewCell and SPProfileFeedTableViewCell
        
        self.caption.text = feedItem.caption
    
        if let user = feedItem.photos?["user"] as? SPUser {
            user.fetchIfNeededInBackgroundWithBlock({ (obj, error) -> Void in
                if let profilePicture = user.profilePicture {
                    self.userDisplayNameButton.setTitle(user.spDisplayName(), forState: .Normal)
                    self.profilePictureImageView.file = profilePicture
                    self.profilePictureImageView.loadInBackground(nil)
                }
                else {
                    self.profilePictureImageView = nil
                }
            })
        }

        if self.feedItem?.photoUserLikes == PhotoUserLikes.FirstPhotoLiked {
            imageOneLikeButton.setImage(UIImage(named: "Icon_likeheartwithborder_feed"), forState: UIControlState.Normal)
            imageTwoLikeButton.hidden = true
            imageOneLikeButton.hidden = false
        } else if self.feedItem?.photoUserLikes == PhotoUserLikes.SecondPhotoLiked {
            imageTwoLikeButton.setImage(UIImage(named: "Icon_likeheartwithborder_feed"), forState: UIControlState.Normal)
            imageTwoLikeButton.hidden = false
            imageOneLikeButton.hidden = true
        } else {
            imageTwoLikeButton.setImage(UIImage(named: "Button_like_feed"), forState: UIControlState.Normal)
            imageOneLikeButton.setImage(UIImage(named: "Button_like_feed"), forState: UIControlState.Normal)
            imageTwoLikeButton.hidden = false
            imageOneLikeButton.hidden = false            
        }
        
        let noPhotoLiked = self.feedItem?.photoUserLikes == PhotoUserLikes.NoPhotoLiked
        let usersOwnPhotoPair = self.feedItem?.photos?.user.objectId == PFUser.currentUser()!.objectId
        statsArea.hidden = !usersOwnPhotoPair && noPhotoLiked
        
        if let timeIntervalSincePost = feedItem.timeintervalSincePost{
            postedTimeLabel.text = String(timeIntervalSincePost)
        }
        else{
            postedTimeLabel.text = "NA"
        }
        
        postedTimeLabel.sizeToFit()
    }
    
    
    @IBAction func userInfoDidTap( sender: AnyObject ) {
        if let feedItem = self.feedItem {
            self.delegate?.didRequestUserProfile(feedItem)
        }
    }
    
    
    @IBAction func imageOneLiked(sender: AnyObject) {
        print( "in imageOneliked" )
        if self.feedItem?.photoUserLikes == PhotoUserLikes.NoPhotoLiked {
            imageOneLikeButton.setImage(UIImage(named: "Icon_likeheartwithborder_feed"), forState: UIControlState.Normal)
            imageTwoLikeButton.hidden = true

            SPManager.sharedInstance.likePhoto(ActivityType.LikeImageOne, photoPair: self.feedItem?.photos) { (success, error) -> Void in
                if success {
                    print( "saving like was a success" )
                } else {
                    print( "save like failed" )
                }
                
                if error != nil {
                    print( error )
                }
            }
            
            self.feedItem?.photoUserLikes = PhotoUserLikes.FirstPhotoLiked
            self.feedItem?.likesCountOne++
            self.imageOneLikeLabel.text = "\(self.feedItem?.likesCountOne)"
            self.updatePercentages()
            statsArea.hidden = false
        } else {
            UIAlertView(title: "Already liked", message: "You already liked a photo in this post", delegate: nil, cancelButtonTitle: "Ok" ).show()
        }
    }

    @IBAction func imageTwoLiked(sender: AnyObject) {
        print( "in imageTwoliked" )
        if self.feedItem?.photoUserLikes == PhotoUserLikes.NoPhotoLiked {
            self.imageTwoLikeButton.setImage(UIImage(named: "Icon_likeheartwithborder_feed"), forState: UIControlState.Normal)
            self.imageOneLikeButton.hidden = true
            SPManager.sharedInstance.likePhoto(ActivityType.LikeImageTwo, photoPair: self.feedItem?.photos) { (success, error) -> Void in
                if success {
                    print( "saving like was a success" )
                } else {
                    print( "save like failed" )
                }
                
                if error != nil {
                    print( error )
                }
            }
            if let feedItem = self.feedItem {
                
                feedItem.photoUserLikes = PhotoUserLikes.SecondPhotoLiked
                feedItem.likesCountTwo++
                self.imageTwoLikeLabel.text = "\(feedItem.likesCountTwo)"
            }
            
            self.updatePercentages()
            statsArea.hidden = false
        } else {
            UIAlertView(title: "Already liked", message: "You already liked a photo in this post", delegate: nil, cancelButtonTitle: "Ok" ).show()
        }
    }
    
    func updatePercentages() {
        if let feedItem = self.feedItem {
            let totalLikes = Double(feedItem.likesCountOne + feedItem.likesCountTwo)
            feedItem.percentageLikedOne = Int(100 * Double(feedItem.likesCountOne) / totalLikes)
            feedItem.percentageLikedTwo = Int(100 * Double(feedItem.likesCountTwo) / totalLikes)
            self.imageOnePercentLabel.text = NSString( format:"%d", Int(feedItem.percentageLikedOne) ) as String
            self.imageTwoPercentLabel.text = NSString( format:"%d", Int(feedItem.percentageLikedTwo ) ) as String
        }
        
    }
    
    
}
