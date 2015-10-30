 //
//  SPProfileFollowTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/19/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPProfileFollowTableViewCell: UITableViewCell {

    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var profilePictureImageView: PFImageView!

//    var isFollowing = false
    var spUser: SPUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profilePictureImageView.clipsToBounds = true
        self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2.0
    }

    @IBAction func followButtonTouchUpInside(sender: AnyObject) {
        self.spUser!.isFollowing = NSNumber( bool: !(self.spUser!.isFollowing.boolValue) )
        updateIsFollowing(self.spUser!.isFollowing.boolValue )
        if spUser!.isFollowing.boolValue {
            // then follow user
            SPManager.sharedInstance.followUser(self.spUser, resultBlock: { (savedObject, error) -> Void in
                if error == nil {
                }
            })
        } else {
            SPManager.sharedInstance.unfollowUser(self.spUser, resultBlock: { (success, error) -> Void in
                if error == nil {
                }
            })
        }
        
    }
    
    func setupCell(user :SPUser){
        self.spUser = user
        updateIsFollowing(self.spUser!.isFollowing.boolValue)
        label.text = self.spUser!.spDisplayName()
        profilePictureImageView.file = self.spUser!.profilePicture
        profilePictureImageView.loadInBackground(nil)
    }
    
    func updateIsFollowing(isFollowing : Bool){
        let img =  isFollowing ? UIImage(named: "Icon_following") : UIImage(named: "Icon_follow")
        followButton.setImage(img, forState: .Normal)

    }
}
