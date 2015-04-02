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

    var isFollowing = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func followButtonTouchUpInside(sender: AnyObject) {
        isFollowing = !isFollowing
        updateIsFollowing(isFollowing)
    }
    
    func setupCell(user :SPUser){
        isFollowing =  user.isFollowing.boolValue
        updateIsFollowing(user.isFollowing.boolValue)
        label.text = user.spDisplayName()
        profilePictureImageView.file = user.profilePicture
        profilePictureImageView.loadInBackground(nil)
    }
    
    func updateIsFollowing(isFollowing : Bool){
        var img =  isFollowing ? UIImage(named: "Icon_following") : UIImage(named: "Icon_follow")
        followButton.setImage(img, forState: .Normal)

    }
}
