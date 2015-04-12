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

    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var commentCountButton: UIButton!
    var delegate : SPFeedDetailCollaborationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func likesButtonTapped(sender: AnyObject) {
        self.delegate?.likesButtonTapped()
    }
    @IBAction func commentsButtonTapped(sender: AnyObject) {
        self.delegate?.commentsButtonTapped()
    }
}
