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
    
    var isFollowing = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func followButtonTouchUpInside(sender: AnyObject) {
        isFollowing = !isFollowing
        updateIsFollowing(isFollowing)
    }
    
    func setupCell(following : Bool){
        isFollowing = following
        updateIsFollowing(isFollowing)
    }
    
    func updateIsFollowing(isFollowing : Bool){
        var img =  isFollowing ? UIImage(named: "Icon_following") : UIImage(named: "Icon_follow")
        followButton.setImage(img, forState: .Normal)

    }

    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
