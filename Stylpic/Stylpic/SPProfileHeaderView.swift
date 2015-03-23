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
        
        if self.isFollowing {
            SPManager.sharedInstance.followUser(self.user, resultBlock: { (savedObject, error) -> Void in
                println( "followed user with \(error)" )
                
            })
        } else {
            SPManager.sharedInstance.unfollowUser(self.user, resultBlock: { (savedObject, error) -> Void in
                println( "unfollowed user with error \(error)" )
                
            })
        }
    }
    
    func setupCell(following : Bool, user: SPUser ){
        self.isFollowing = following
        updateIsFollowing(isFollowing)
        self.user = user
        self.profilePictureImageView.file = user["profilePicture"] as! PFFile
        self.profilePictureImageView.loadInBackground(nil)
        
        
    }
    
    func updateIsFollowing(isFollowing : Bool){
        var text = isFollowing ? "Following" : "Follow"
        followButton.setTitle(text, forState: .Normal)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
