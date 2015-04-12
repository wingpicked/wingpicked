//
//  SPProfilePostTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/15/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

protocol SPProfilePostTableViewCellDelegate : class {
    func deleteFeedItem( feedItem: SPFeedItem )
}

class SPProfilePostTableViewCell: SPBaseFeedViewTableViewCell {
    @IBOutlet weak var statsArea: UIView!

    @IBOutlet weak var optionsButton: UIButton!
    //Overrides will go here if any.. currently this implementation matches up exactly with the SPBaseFeedViewTableViewCell...
    
    weak var profilePostDelegate : SPProfilePostTableViewCellDelegate?
    
    override func setupWithFeedItem(feedItem: SPFeedItem){
        super.setupWithFeedItem(feedItem) //Does a lot of heavy lifting that is in common with SPFeedViewTableViewCell and SPProfileFeedTableViewCell
        
        let noPhotoLiked = self.feedItem?.photoUserLikes == PhotoUserLikes.NoPhotoLiked
        let viewingOwnProfile = self.feedItem?.photos?.user.objectId == PFUser.currentUser().objectId
        let hideUI = !viewingOwnProfile && noPhotoLiked
        self.statsArea.hidden = hideUI
    }
    @IBAction func optionsButtonTapped(sender: AnyObject) {
        self.profilePostDelegate?.deleteFeedItem( self.feedItem! )
    }
}
