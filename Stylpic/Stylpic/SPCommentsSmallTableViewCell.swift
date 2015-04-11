//
//  SPCommentsSmallTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 4/5/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

protocol SPCommentsSmallTableViewCellDelegate {
    func didSelectComment(user: SPUser)
}

class SPCommentsSmallTableViewCell: UITableViewCell, TTTAttributedLabelDelegate {

    @IBOutlet weak var commentLabel: TTTAttributedLabel!
    var currentUser : SPUser?
    var delegate : SPCommentsSmallTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentLabel.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(commentActivity: SPActivity){
        var comment : NSString = "\(commentActivity.fromUser.spDisplayName()) | \(commentActivity.content)"
        commentLabel.text = comment as String
        
        var range = comment.rangeOfString(commentActivity.fromUser.spDisplayName())
        currentUser = commentActivity.fromUser
        commentLabel.addLinkToURL(NSURL(string: "action://show-user"), withRange: range)
        
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        if(url.scheme!.hasPrefix("action")){
            if(url.host!.hasPrefix("show-user")){
                println("SHOW USER!")
                
                if let currentUser = self.currentUser{
                    self.delegate?.didSelectComment(currentUser)
                }
                
            }
            else {
                println("Unhandled action")
            }
        }
    }
    

    
}
