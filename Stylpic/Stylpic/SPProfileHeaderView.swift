//
//  SPProfileHeaderView.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/15/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPProfileHeaderView: UIView {

    @IBOutlet weak var profilePictureImageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.height / 2
        profilePictureImageView.layer.masksToBounds = true
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
