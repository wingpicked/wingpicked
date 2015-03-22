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
    
    @IBOutlet weak var imageOneLikeButton: UIButton!
    @IBOutlet weak var imageTwoLikeButton: UIButton!
    
    @IBOutlet weak var postedTimeLabel: UILabel!
    
    @IBOutlet weak var profilePictureImageView: PFImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.actualContentView.layer.cornerRadius = 3.0
        self.actualContentView.layer.shadowRadius = 2.0
        self.actualContentView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        self.actualContentView.layer.shadowOpacity = 0.3;
        
        
    }
    
    override func setupWithFeedItem(feedItem: SPFeedItem){
        super.setupWithFeedItem(feedItem) //Does a lot of heavy lifting that is in common with SPFeedViewTableViewCell and SPProfileFeedTableViewCell
        
        self.caption.text = feedItem.caption
    
        if let user = feedItem.photos?["user"] as? PFUser {
            user.fetchIfNeededInBackgroundWithBlock({ (obj, error) -> Void in
                if let profilePicture = user.objectForKey("profilePicture") as? PFFile {
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
        }
        
        if self.feedItem?.photoUserLikes == PhotoUserLikes.SecondPhotoLiked {
            imageTwoLikeButton.setImage(UIImage(named: "Icon_likes_onSelectedPhoto2"), forState: UIControlState.Normal)
            imageOneLikeButton.hidden = true
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
