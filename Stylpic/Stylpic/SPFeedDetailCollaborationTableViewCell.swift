//
//  SPFeedDetailCollaborationTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 4/5/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

protocol SPFeedDetailCollaborationTableViewCellDelegate{
    func likesButtonTapped()
    func commentsButtonTapped()
}

class SPFeedDetailCollaborationTableViewCell: UITableViewCell {

    var delegate : SPFeedDetailCollaborationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likesButtonTapped(sender: AnyObject) {
        self.delegate?.likesButtonTapped()
    }
    @IBAction func commentsButtonTapped(sender: AnyObject) {
        self.delegate?.commentsButtonTapped()
    }
}
