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
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        height = 200
    }
    
    func setupCell(comment: String){
        commentLabel.text = comment
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
