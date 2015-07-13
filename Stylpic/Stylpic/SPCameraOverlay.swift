//
//  SPCameraOverlay.swift
//  Stylpic
//
//  Created by Joshua Bell on 2/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import AssetsLibrary

@objc protocol SPCameraOverlayDelegate {
    func selectPhotosDidTap(overlay: SPCameraOverlay)
    func takePhotoButtonDidTap(overlay: SPCameraOverlay)
    func dismissCamera( overlay: SPCameraOverlay )
    func switchCameraButtonDidTap(overlay: SPCameraOverlay)
    func flashButtonDidTap(overlay: SPCameraOverlay)
}

class SPCameraOverlay: UIView {
   
    var delegate: SPCameraOverlayDelegate?
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var squareCroppingView: UIView!
    
    @IBOutlet weak var dismissOrBackButton: UIButton!
    @IBOutlet weak var titleBarView: UIView!
    @IBOutlet weak var flashButton: UIButton!
    
    var flashEnabled = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleBarView.bringSubviewToFront(self.flashButton)
        self.titleBarView.bringSubviewToFront(self.switchCameraButton)
//        self.pickingTheLastImageFromThePhotoLibrary()
        
        photoLibraryButton.layer.cornerRadius = 5.0
        photoLibraryButton.clipsToBounds = true

    }
    
    @IBAction func selectPhotosButtonDidTap(sender: AnyObject) {
        self.delegate?.selectPhotosDidTap(self)
    }
    
    @IBAction func flashButtonDidTap(sender: AnyObject) {
        flashEnabled = !flashEnabled
        var flashImage = flashEnabled ? UIImage(named: "Icon_flash_on") : UIImage(named: "Icon_flash")
        self.flashButton.setImage(flashImage, forState: UIControlState.Normal)
        self.delegate?.flashButtonDidTap(self)
    }
    
    @IBAction func takePhotoButtonDidTap(sender: AnyObject) {
        self.delegate?.takePhotoButtonDidTap(self)
    }
    
    @IBAction func dismissCamera(sender: AnyObject) {
        self.delegate?.dismissCamera( self )
    }
    
    @IBAction func switchCameraButtonDidTap(sender: AnyObject) {
        self.delegate?.switchCameraButtonDidTap(self)
    }
    
    func pickingTheLastImageFromThePhotoLibrary() {
        let assetsLibrary: ALAssetsLibrary = ALAssetsLibrary()
        assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos,
            usingBlock: { (let group: ALAssetsGroup!, var stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                if (group != nil) {
                    // Be sure to filter the group so you only get photos
                    group.setAssetsFilter(ALAssetsFilter.allPhotos())
                    
                    group.enumerateAssetsWithOptions(NSEnumerationOptions.Reverse,
                        usingBlock: { (let asset: ALAsset!,
                            let index: Int,
                            var stop: UnsafeMutablePointer<ObjCBool>)
                            -> Void in
                            if(asset != nil) {
                                /*
                                Returns a CGImage representation of the asset.
                                Using the fullResolutionImage uses the original image which — depending on the
                                device's orientation when taking the photo — could leave you with an upside down,
                                or -90° image. To get the modified, but optimised image for this, use
                                fullScreenImage instead.
                                */
                                // let myCGImage: CGImage! = asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue()
                                
                                /*
                                Returns a CGImage of the representation that is appropriate for displaying full
                                screen.
                                */
//                                 let myCGImage: CGImage! = asset.defaultRepresentation().fullScreenImage().takeUnretainedValue()
                                
                                /* Returns a thumbnail representation of the asset. */
                                let myCGImage: CGImage! = asset.thumbnail().takeUnretainedValue()
                                
                                // Here we set the image included in the UIImageView
                                self.photoLibraryButton.setImage(UIImage(CGImage: myCGImage), forState: UIControlState.Normal)
                                stop.memory = ObjCBool(true)
                            }
                    })
                }
                
                stop.memory = ObjCBool(false)
            })
            { (let error: NSError!) -> Void in
                println("A problem occurred: \(error.localizedDescription)")
        }
    }
}
