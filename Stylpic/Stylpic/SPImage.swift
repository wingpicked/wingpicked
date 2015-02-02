//
//  SPImage.swift
//  Stylpic
//
//  Created by Neil Bhargava on 2/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPImage: NSObject {
    var caption = "Default Caption"
    var image : UIImage?
    
    init(caption: String, image: UIImage) {
        self.caption = caption
        self.image = image
        super.init()
    }
}
