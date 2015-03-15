//
//  SPFeedViewTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

protocol SPFeedViewTableViewCellDelegate {
    func didTapPhotoOne(feedItem : SPFeedItem)
    func didTapPhotoTwo(feedItem : SPFeedItem)
}

class SPFeedViewTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: PFImageView!
    @IBOutlet weak var caption: UILabel!
    
    @IBOutlet weak var actualContentView: UIView!
    
    @IBOutlet weak var imageOneLikeButton: UIButton!
    @IBOutlet weak var imageTwoLikeButton: UIButton!
    @IBOutlet weak var pictureImageView2: PFImageView!
    
    @IBOutlet weak var postedTimeLabel: UILabel!
    
    @IBOutlet weak var imageOnePercentLabel: UILabel!
    @IBOutlet weak var imageOneLikeLabel: UILabel!
    @IBOutlet weak var imageOneCommentLabel: UILabel!
    
    @IBOutlet weak var imageTwoPercentLabel: UILabel!
    @IBOutlet weak var imageTwoLikeLabel: UILabel!
    @IBOutlet weak var imageTwoCommentLabel: UILabel!
    
    var feedItem : SPFeedItem?
    
    var delegate : SPFeedViewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.actualContentView.layer.cornerRadius = 3.0
        self.actualContentView.layer.shadowRadius = 2.0
        self.actualContentView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        self.actualContentView.layer.shadowOpacity = 0.3;
        
        pictureImageView.userInteractionEnabled = true
        pictureImageView2.userInteractionEnabled = true
        var tap1 = UITapGestureRecognizer(target: self, action: Selector("imageOneTapped:"))
        pictureImageView.addGestureRecognizer(tap1)
        var tap2 = UITapGestureRecognizer(target: self, action: Selector("imageTwoTapped:"))
        pictureImageView2.addGestureRecognizer(tap2)

        
    }
    
    func setupWithFeedItem(feedItem: SPFeedItem){
        self.feedItem = feedItem
        self.caption.text = feedItem.caption
        
        self.pictureImageView.file = feedItem.photos?.objectForKey("imageOne") as! PFFile
        self.pictureImageView2.file = feedItem.photos?.objectForKey("imageTwo") as! PFFile
        self.pictureImageView2.loadInBackground(nil)
        self.pictureImageView.loadInBackground(nil)

        self.imageOnePercentLabel.text = NSString( format:"%.1f", feedItem.percentageLikedOne ) as String
        self.imageTwoPercentLabel.text = NSString( format:"%.1f", feedItem.percentageLikedTwo ) as String
        self.imageOneLikeLabel.text =  String(feedItem.likesCountOne)
        self.imageTwoLikeLabel.text =  String(feedItem.likesCountTwo)
        self.imageOneCommentLabel.text =  String( feedItem.commentsCountOne )
        self.imageTwoCommentLabel.text =  String( feedItem.commentsCountTwo )
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
            
            self.feedItem?.photoUserLikes = PhotoUserLikes.SecondPhotoLiked
        } else {
            UIAlertView(title: "Already liked", message: "You already liked a photo in this post", delegate: nil, cancelButtonTitle: "Ok" ).show()
        }
    }
    
    func imageOneTapped(sender: AnyObject) {
        if let feedItem = self.feedItem {
            self.delegate?.didTapPhotoOne(feedItem)
        }
    }
    func imageTwoTapped(sender: AnyObject) {
        if let feedItem = self.feedItem {
            self.delegate?.didTapPhotoTwo(feedItem)
        }
    }
    
}
