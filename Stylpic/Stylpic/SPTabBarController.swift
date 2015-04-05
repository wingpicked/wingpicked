//
//  SPTabBarController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 4/4/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPTabBarController: UITabBarController, UITabBarDelegate, UIImagePickerControllerDelegate, SPCameraOverlayDelegate, UINavigationControllerDelegate {

    let imagePickerViewController = UIImagePickerController()
    let overlayView = NSBundle.mainBundle().loadNibNamed("SPCameraOverlay", owner: nil, options: nil)[0] as! SPCameraOverlay
    
    var tabBarHidden = false
    var centerButton : UIButton?
    
    var userPhotoOne : UIImage?
    var userPhotoTwo : UIImage?
    
    var capturedImages : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var backgroundColor = UIColor(red: 25/255, green: 37/255, blue: 44/255, alpha: 1.0)
        var iconTintColor = UIColor(red: 158/255, green: 228/255, blue: 229/255, alpha: 1.0)
        var backgroundImage = UIImage(fromColor: backgroundColor, forSize: CGSizeMake(320, 49), withCornerRadius: 0)
        self.tabBar.backgroundImage = backgroundImage
        self.tabBar.tintColor = iconTintColor
        self.addCenterButton(UIImage(named: "Icon_post")!, highlightImage: UIImage(named: "Icon_post")!, target: self, action: Selector("buttonPressed:"))
        
        for vc in self.viewControllers as! [UIViewController]{
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        }

        self.imagePickerViewController.delegate = self
    }

    func addCenterButton(buttonImage: UIImage, highlightImage: UIImage, target:AnyObject, action:Selector){
        var button = UIButton()
        button.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | .FlexibleLeftMargin | .FlexibleBottomMargin | .FlexibleTopMargin
        
        
        button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height)
        
        button.setBackgroundImage(buttonImage, forState: .Normal)
        button.setBackgroundImage(highlightImage, forState: .Highlighted)
        
        var heightDifference : CGFloat = buttonImage.size.height - self.tabBar.frame.size.height;
        if (heightDifference < 0) {
            button.center = self.tabBar.center;
        } else {
            var center = self.tabBar.center;
            center.y = center.y - heightDifference/2.0;
            button.center = center;
        }
        
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(button)
        self.centerButton = button;

    }
    
    func buttonPressed(sender:AnyObject){
        
        //Reset Camera
        capturedImages = []
        overlayView.titleLabel.text = "Photo \(capturedImages.count + 1) of 2"
        
        imagePickerViewController.sourceType = .Camera
        imagePickerViewController.showsCameraControls = false;
        overlayView.delegate = self
        imagePickerViewController.cameraOverlayView = overlayView
        
        self.presentViewController(imagePickerViewController, animated: true, completion: nil)
    }

    
    
    func selectPhotosDidTap() {
            println("A")
    }
    func takePhotoButtonDidTap() {
        self.imagePickerViewController.takePicture()
    }
    
    func dismissCamera() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let originalImage = info[ UIImagePickerControllerOriginalImage ] as! UIImage
        let squareRect = CGRectMake( 0, 0, originalImage.size.width, originalImage.size.width )
        var imageRef: CGImageRef = CGImageCreateWithImageInRect(originalImage.CGImage, squareRect);
        var squareImage = UIImage(CGImage:imageRef, scale: 1, orientation: UIImageOrientation.Right)
        
        //TODO: Comment this in when we want photos to save to album.  Really annoying right now..
        //UIImageWriteToSavedPhotosAlbum(squareImage, self, nil, nil)
        
        if let squareImage = squareImage{
            capturedImages.append(squareImage)
        }
        
        overlayView.titleLabel.text = "Photo \(capturedImages.count + 1) of 2"
        
        if(capturedImages.count >= 2){
            var postPhotoViewController = SPEditPhotoViewController(nibName:"SPEditPhotoViewController", bundle: nil)
            postPhotoViewController.image = capturedImages[0];
            postPhotoViewController.imageTwo = capturedImages[1];
            self.imagePickerViewController.pushViewController(postPhotoViewController, animated: true)
        }
    }

}