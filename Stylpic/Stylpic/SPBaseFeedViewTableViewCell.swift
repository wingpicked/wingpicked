//
//  SPBaseFeedViewTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/19/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

protocol SPFeedViewTableViewCellDelegate {
    func didTapPhotoOne(feedItem : SPFeedItem)
    func didTapPhotoTwo(feedItem : SPFeedItem)
    func didRequestUserProfile( feedItem: SPFeedItem )
}

class SPBaseFeedViewTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: PFImageView!
    @IBOutlet weak var pictureImageView2: PFImageView!
    
    @IBOutlet weak var imageOnePercentLabel: UILabel!
//    @IBOutlet weak var imageOneLikeLabel: UILabel!
//    @IBOutlet weak var imageOneCommentLabel: UILabel!
    
    @IBOutlet weak var imageTwoPercentLabel: UILabel!
//    @IBOutlet weak var imageTwoLikeLabel: UILabel!
//    @IBOutlet weak var imageTwoCommentLabel: UILabel!
    
    var feedItem : SPFeedItem?
    var delegate : SPFeedViewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pictureImageView.userInteractionEnabled = true
        pictureImageView2.userInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: Selector("imageOneTapped:"))
        pictureImageView.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: Selector("imageTwoTapped:"))
        pictureImageView2.addGestureRecognizer(tap2)
    }

    func setupWithFeedItem(feedItem: SPFeedItem){

        self.feedItem = feedItem
        self.pictureImageView.image = nil
        self.pictureImageView2.image = nil
        self.pictureImageView.file = feedItem.photos?.photoOne.photo
        self.pictureImageView2.file = feedItem.photos?.photoTwo.photo
        self.pictureImageView.loadInBackground { (uiimage, error) -> Void in
            if error == nil {
                self.pictureImageView.image = uiimage
            }
        }

        self.pictureImageView2.loadInBackground { (uiimage, error) -> Void in
            if error == nil {
                self.pictureImageView2.image = uiimage 
            }
        }
        
        self.imageOnePercentLabel.text = NSString( format:"%d", feedItem.percentageLikedOne ) as String
        self.imageTwoPercentLabel.text = NSString( format:"%d", feedItem.percentageLikedTwo ) as String
//        self.imageOneLikeLabel.text =  String(feedItem.likesCountOne)
//        self.imageTwoLikeLabel.text =  String(feedItem.likesCountTwo)
//        self.imageOneCommentLabel.text =  String( feedItem.commentsCountOne )
//        self.imageTwoCommentLabel.text =  String( feedItem.commentsCountTwo )
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
