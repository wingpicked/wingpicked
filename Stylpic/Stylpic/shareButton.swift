//
//  SPCameraOverlay.swift
//  Stylpic
//
//  Created by Joshua Bell on 2/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

protocol SPCameraOverlayDelegate {
    func selectPhotosDidTap()
    func takePhotoButtonDidTap()
}

class SPCameraOverlay: UIView {
   
    var delegate: SPCameraOverlayDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var squareCroppingView: UIView!
    
    @IBAction func selectPhotosButtonDidTap(sender: AnyObject) {
        self.delegate?.selectPhotosDidTap()
    }
    
    @IBAction func takePhotoButtonDidTap(sender: AnyObject) {
        self.delegate?.takePhotoButtonDidTap()
    }
}
