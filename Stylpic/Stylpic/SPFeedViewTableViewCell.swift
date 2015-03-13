//
//  SPFeedViewTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPFeedViewTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: PFImageView!
    @IBOutlet weak var caption: UILabel!
    
    @IBOutlet weak var actualContentView: UIView!
    
    @IBOutlet weak var imageOneLikeButton: UIButton!
    @IBOutlet weak var imageTwoLikeButton: UIButton!
    @IBOutlet weak var pictureImageView2: PFImageView!
    
    @IBOutlet weak var postedTimeLabel: UILabel!
    
    @IBOutlet weak var imageOnePercentLabel: UILabel!
    @IBOutlet weak var imageOneLikeLabel: UILabel!
    @IBOutlet weak var imageOneCommentLabel: UILabel!
    
    @IBOutlet weak var imageTwoPercentLabel: UILabel!
    @IBOutlet weak var imageTwoLikeLabel: UILabel!
    @IBOutlet weak var imageTwoCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.actualContentView.layer.cornerRadius = 3.0
        self.actualContentView.layer.shadowRadius = 2.0
        self.actualContentView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        self.actualContentView.layer.shadowOpacity = 0.3;
    }
    @IBAction func imageOneLiked(sender: AnyObject) {
        imageOneLikeButton.setImage(UIImage(named: "Icon_likes_onSelectedPhoto2"), forState: UIControlState.Normal)
        imageTwoLikeButton.hidden = true
        
    }

    @IBAction func imageTwoLiked(sender: AnyObject) {
        imageTwoLikeButton.setImage(UIImage(named: "Icon_likes_onSelectedPhoto2"), forState: UIControlState.Normal)
        imageOneLikeButton.hidden = true
    }
    
}
