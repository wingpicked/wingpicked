//
//  SPFeedDetailPictureTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 2/8/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPFeedDetailPictureTableViewCell: SPBaseTableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timePostedLabel: UILabel!
    @IBOutlet weak var mainImageView: PFImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var percentLikedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        height = 100
    }
    
    func cellHeight() -> CGFloat{
        return height!;
    }
    
    func setupCell(imageFile : PFFile){
        mainImageView.file = imageFile
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
