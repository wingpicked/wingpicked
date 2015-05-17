//
//  SPProfileNotificationsTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/21/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPProfileNotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var unseenNotificationDot: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var profilePictureImageView: PFImageView!
    @IBOutlet weak var activityImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.unseenNotificationDot.clipsToBounds = true
        self.unseenNotificationDot.layer.cornerRadius = 3
        self.profilePictureImageView.clipsToBounds = true
        self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2.0
    }

    func setupCell(activity :SPActivity){
        label.text = activity.displayMessage()
        profilePictureImageView.file = activity.fromUser.profilePicture
        profilePictureImageView.loadInBackground(nil)
        self.unseenNotificationDot.hidden = activity.notificationViewed.boolValue
        if !activity.notificationViewed.boolValue {
            activity.notificationViewed = NSNumber( bool: true )
            activity.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    println( "set activity to viewed" )
                } else {
                    println( error )
                }
            })
        }
    }

}
