//
//  SPLikesTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 4/11/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPLikesTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func followButtonTapped(sender: AnyObject) {
        println("Follow button tapped")
    }
    
    func setupCell(activity : SPActivity){
        self.usernameLabel.text = activity.fromUser.spDisplayName()
    }
}
