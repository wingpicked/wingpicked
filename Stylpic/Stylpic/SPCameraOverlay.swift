//
//  SPCameraOverlay.swift
//  Stylpic
//
//  Created by Joshua Bell on 2/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

@objc protocol SPCameraOverlayDelegate {
    func selectPhotosDidTap()
    func takePhotoButtonDidTap()
    func dismissCamera()
    func switchCameraButtonDidTap()
    func flashButtonDidTap()
}

class SPCameraOverlay: UIView {
   
    var delegate: SPCameraOverlayDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var squareCroppingView: UIView!
    
    @IBOutlet weak var titleBarView: UIView!
    @IBOutlet weak var flashButton: UIButton!
    
    var flashEnabled = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleBarView.bringSubviewToFront(self.flashButton)
        self.titleBarView.bringSubviewToFront(self.switchCameraButton)
    }
    
    @IBAction func selectPhotosButtonDidTap(sender: AnyObject) {
        self.delegate?.selectPhotosDidTap()
    }
    
    @IBAction func flashButtonDidTap(sender: AnyObject) {
        flashEnabled = !flashEnabled
        var flashImage = flashEnabled ? UIImage(named: "Icon_flash_on") : UIImage(named: "Icon_flash")
        self.flashButton.setImage(flashImage, forState: UIControlState.Normal)
        self.delegate?.flashButtonDidTap()
    }
    
    @IBAction func takePhotoButtonDidTap(sender: AnyObject) {
        self.delegate?.takePhotoButtonDidTap()
    }
    
    @IBAction func dismissCamera(sender: AnyObject) {
        self.delegate?.dismissCamera()
    }
    
    @IBAction func switchCameraButtonDidTap(sender: AnyObject) {
        self.delegate?.switchCameraButtonDidTap()
    }
}
