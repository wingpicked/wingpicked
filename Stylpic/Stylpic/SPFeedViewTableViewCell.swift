//
//  SPFeedViewTableViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPFeedViewTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var caption: UILabel!
    
    @IBOutlet weak var actualContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.actualContentView.layer.cornerRadius = 5.0
        self.actualContentView.layer.shadowRadius = 5.0
        self.actualContentView.layer.shadowOffset = CGSizeMake(0.0, 5.0);
        self.actualContentView.layer.shadowOpacity = 0.5;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
