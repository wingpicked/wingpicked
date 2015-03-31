//
//  SPClosetCollectionViewCell.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/4/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPClosetCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: PFImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWithPFFile( pfFile: PFFile ) {
        self.imageView.file = pfFile
        self.imageView.loadInBackground(nil)
    }

}
