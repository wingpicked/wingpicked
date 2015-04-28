//
//  SPProfileHeaderView.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/15/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPProfileHeaderView: UIView {

    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var profilePictureImageView: PFImageView!
    
    var isFollowing = false
    var user: SPUser?
    
//    var delegate: SPProfileHeaderViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.height / 2
        profilePictureImageView.layer.masksToBounds = true
    }
    @IBAction func didTapFollowButton(sender: AnyObject) {
        self.isFollowing = !self.isFollowing
        updateIsFollowing(self.isFollowing)
        self.followButton.userInteractionEnabled = false
        
        if self.isFollowing {
            SPManager.sharedInstance.followUser(self.user, resultBlock: { (savedObject, error) -> Void in
                println( "followed user with \(error)" )
                self.followButton.userInteractionEnabled = true
            })
        } else {
            SPManager.sharedInstance.unfollowUser(self.user, resultBlock: { (savedObject, error) -> Void in
                println( "unfollowed user with error \(error)" )
                self.followButton.userInteractionEnabled = true                
            })
        }
    }
    
    func setupCell(following : Bool, user: SPUser ){
        self.isFollowing = following
        updateIsFollowing(self.isFollowing)
        self.user = user
        self.profilePictureImageView.file = user["profilePicture"] as! PFFile
        self.profilePictureImageView.loadInBackground(nil)
        
        
    }
    
    func updateIsFollowing(isFollowing : Bool){
//        var text = isFollowing ? "Following" : "Follow"
//        followButton.setTitle(text, forState: .Normal)
        var img = isFollowing ? UIImage(named: "Button_following") : UIImage(named: "Button_follow")
        followButton.setImage(img, forState: .Normal)
    }
}
