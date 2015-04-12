//
//  SPFeedDetailCommentTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 2/8/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPFeedDetailCommentTableViewCell: SPBaseTableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: PFImageView!
    var commentActivity: SPActivity?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //height = 200
    }
    
    func setupCell(commentActivity: SPActivity){
        self.commentActivity = commentActivity
        commentLabel.text = commentActivity.content
        profilePictureImageView.file = commentActivity.fromUser.profilePicture
        profilePictureImageView.loadInBackground(nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
