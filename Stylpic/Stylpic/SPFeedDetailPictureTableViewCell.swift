//
//  SPFeedDetailPictureTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 2/8/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPFeedDetailPictureTableViewCell: SPBaseTableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timePostedLabel: UILabel!
    @IBOutlet weak var mainImageView: PFImageView!
    @IBOutlet weak var profilePictureImageView: PFImageView!
    @IBOutlet weak var percentLikedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        height = 100
    }
    
    func cellHeight() -> CGFloat{
        return height!;
    }
    
    func setupCell(feedItem : SPFeedItem, imageFile : PFFile){
        titleLabel.text = feedItem.caption
        if let timeIntervalSincePost = feedItem.timeintervalSincePost{
            timePostedLabel.text = String(timeIntervalSincePost)
        }
        else{
            timePostedLabel.text = "NA"
        }
        
        if let user = feedItem.photos?.user {
            user.fetchIfNeededInBackgroundWithBlock({ (obj, error) -> Void in
                if let profilePicture = user.profilePicture {
                    self.usernameLabel.text = user.spDisplayName()
                    self.profilePictureImageView.file = profilePicture
                    self.profilePictureImageView.loadInBackground(nil)
                }
                else {
                    self.profilePictureImageView = nil
                }
            })
        }


        mainImageView.file = imageFile
    }
}
