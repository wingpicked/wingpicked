//
//  SPCommentsSmallTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 4/5/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPCommentsSmallTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: TTTAttributedLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(commentActivity: SPActivity){
        var comment = "\(commentActivity.fromUser.spDisplayName()) | \(commentActivity.content)"
        commentLabel.text = comment
    }

    
}
