//
//  SPProfileNotificationsTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/21/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPProfileNotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var profilePictureImageView: PFImageView!
    @IBOutlet weak var activityImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(activity :SPActivity){
//        var a = activity.objectForKey("fromUser") as! PFUser
//        var fromUser = activity.fromUser as! SPUser
//        label.text = activity.displayMessage()
//        profilePictureImageView.file = a.profilePicture
//        profilePictureImageView.loadInBackground(nil)
    }

}
