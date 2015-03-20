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
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    var isFollowing = false

    override func layoutSubviews() {
        super.layoutSubviews()
        profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.height / 2
        profilePictureImageView.layer.masksToBounds = true
    }
    @IBAction func didTapFollowButton(sender: AnyObject) {
        self.isFollowing = !self.isFollowing
        updateIsFollowing(self.isFollowing)
        
    }
    
    func setupCell(following : Bool){
        self.isFollowing = following
        updateIsFollowing(isFollowing)
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
