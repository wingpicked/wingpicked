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
    }

    @IBAction func followButtonTouchUpInside(sender: AnyObject) {
        self.spUser!.isFollowing = NSNumber( bool: !(self.spUser!.isFollowing.boolValue) )
        updateIsFollowing(self.spUser!.isFollowing.boolValue )
        if spUser!.isFollowing.boolValue {
            // then follow user
            SPManager.sharedInstance.followUser(self.spUser, resultBlock: { (savedObject, error) -> Void in
                if error == nil {
                    println( "followed user" )
                }
            })
        } else {
            SPManager.sharedInstance.unfollowUser(self.spUser, resultBlock: { (success, error) -> Void in
                if error == nil {
                    println( "unfollowed user")
                }
            })
        }
        
    }
    
    func setupCell(user :SPUser){
        self.spUser = user
        updateIsFollowing(self.spUser!.isFollowing.boolValue)
        self.spUser?.fetchInBackgroundWithBlock({ (pfObject, error) -> Void in
            if error == nil {
                self.label.text = self.spUser!.spDisplayName()
                self.profilePictureImageView.file = self.spUser!.profilePicture
                self.profilePictureImageView.loadInBackground(nil)
            } else {
                self.label.text = ""
            }

        })

    }
    
    func updateIsFollowing(isFollowing : Bool){
        var img =  isFollowing ? UIImage(named: "Icon_following") : UIImage(named: "Icon_follow")
        followButton.setImage(img, forState: .Normal)

    }
}
