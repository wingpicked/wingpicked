//
//  SPTabBarController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 4/4/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPTabBarController: UITabBarController, UITabBarControllerDelegate, UIImagePickerControllerDelegate, SPCameraOverlayDelegate, UINavigationControllerDelegate, SPPhotoConfirmationViewControllerDelegate, SPCameraClosetViewControllerDelegate {
    
    let imagePickerViewController = UIImagePickerController()
    let imagePickerViewControllerSecondPhoto = UIImagePickerController()
    
    let overlayView = NSBundle.mainBundle().loadNibNamed("SPCameraOverlay", owner: nil, options: nil)[0] as! SPCameraOverlay
    let overlayViewSecondPhoto = NSBundle.mainBundle().loadNibNamed("SPCameraOverlay", owner: nil, options: nil)[0] as! SPCameraOverlay
    
    let confirmationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SPPhotoConfirmationViewController") as! SPPhotoConfirmationViewController
    let confirmationViewControllerSecondPhoto = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SPPhotoConfirmationViewController") as! SPPhotoConfirmationViewController
    
    var centerButton : UIButton!
    
    var userPhotoOne : UIImage?
    var userPhotoTwo : UIImage?
    
    var capturedImages : [UIImage] = []
    var flashState = NSNumber( integer: UIImagePickerControllerCameraFlashMode.Off.rawValue )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundColor = UIColor(red: 25/255, green: 37/255, blue: 44/255, alpha: 1.0)
        let iconTintColor = UIColor(red: 158/255, green: 228/255, blue: 229/255, alpha: 1.0)
        let backgroundImage = UIImage(fromColor: backgroundColor, forSize: CGSizeMake(320, 49), withCornerRadius: 0)
        self.tabBar.backgroundImage = backgroundImage
        self.tabBar.translucent = false
        self.tabBar.tintColor = iconTintColor
        self.addCenterButton(UIImage(named: "Icon_post")!, highlightImage: UIImage(named: "Icon_post")!, target: self, action: Selector("buttonPressed:"))
        
        self.confirmationViewController.delegate = self
        self.confirmationViewControllerSecondPhoto.delegate = self
        self.imagePickerViewController.delegate = self
        self.imagePickerViewControllerSecondPhoto.delegate = self
        self.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfileBadgeNumber", name: "Badges", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfileBadgeNumber", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sharedPost", name: "SharedPost"  , object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.bringSubviewToFront(self.centerButton)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear( animated )
        self.updateProfileBadgeNumber()
    }
    
    func sharedPost() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            //            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func updateProfileBadgeNumber() {
        let badgeNum = UIApplication.sharedApplication().applicationIconBadgeNumber
        for viewController in self.viewControllers! as [UIViewController] {
            if viewController.restorationIdentifier == "SPProfileNavigationController" {
                if badgeNum > 0 {
                    viewController.tabBarItem.badgeValue = String( badgeNum )
                } else {
                    viewController.tabBarItem.badgeValue = nil
                }
            }
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if viewController.restorationIdentifier == "SPProfileNavigationController" {
            let profileViewController = (viewController as! UINavigationController).viewControllers[0] as! SPProfileViewController
            profileViewController.showWithUser(SPUser.currentUser()!)
        }
    }
    
    func addCenterButton(buttonImage: UIImage, highlightImage: UIImage, target:AnyObject, action:Selector){
        let button = UIButton()
        button.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleTopMargin]
        
        button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height)
        
        button.setBackgroundImage(buttonImage, forState: .Normal)
        button.setBackgroundImage(highlightImage, forState: .Highlighted)
        
        var center = self.tabBar.center;
        center.y = self.tabBar.frame.size.height / 2.0;
        button.center = center;
        
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tabBar.addSubview(button)
        self.centerButton = button;
    }
    
    func buttonPressed(sender:AnyObject){
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            let ac = UIAlertController(title: "Camera Unavailable", message: "This device doesn't appear to have a camera.  Please try using a device with a camera to access this feature.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
            ac.addAction(action)
            self.presentViewController(ac, animated: true, completion: nil)
            
            print( "camera unavailable for device")
            return;
        }
        
        
        //Reset Camera
        capturedImages = []
        overlayView.titleLabel.text = "Photo 1 of 2"
        overlayView.flashEnabled = self.flashState
        imagePickerViewController.sourceType = .Camera
        imagePickerViewController.showsCameraControls = false
        flashState = NSNumber( integer: UIImagePickerControllerCameraFlashMode.Off.rawValue )
        imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashMode(rawValue: flashState.integerValue)!
        overlayView.flashEnabled = self.flashState
        overlayView.delegate = self
        imagePickerViewController.cameraOverlayView = overlayView
        overlayView.pickingTheLastImageFromThePhotoLibrary()
        self.presentViewController(imagePickerViewController, animated: true, completion: nil)
    }
    
    func showSecondCamera() {
        overlayViewSecondPhoto.titleLabel.text = "Photo 2 of 2"
        overlayViewSecondPhoto.dismissOrBackButton.setImage(UIImage(named:"Camera arrow"), forState: UIControlState.Normal)
        overlayViewSecondPhoto.dismissOrBackButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        overlayViewSecondPhoto.dismissOrBackButton.hidden = true
        imagePickerViewControllerSecondPhoto.sourceType = .Camera
        imagePickerViewControllerSecondPhoto.showsCameraControls = false
        imagePickerViewControllerSecondPhoto.cameraFlashMode = UIImagePickerControllerCameraFlashMode(rawValue: flashState
            .integerValue )!
        overlayViewSecondPhoto.delegate = self
        overlayViewSecondPhoto.flashEnabled = self.flashState
        imagePickerViewControllerSecondPhoto.cameraOverlayView = overlayViewSecondPhoto
        imagePickerViewControllerSecondPhoto.modalTransitionStyle = .CrossDissolve
        overlayViewSecondPhoto.pickingTheLastImageFromThePhotoLibrary()
        self.confirmationViewController.presentViewController(imagePickerViewControllerSecondPhoto, animated: true, completion: nil)
        
    }
    
    //TODO: Have one place for all this common code.
    func switchCameraButtonDidTap(overlay: SPCameraOverlay) {
        if overlay == self.overlayView {
            if self.imagePickerViewController.cameraDevice == .Rear {
                self.imagePickerViewController.cameraDevice = UIImagePickerControllerCameraDevice.Front
            } else {
                self.imagePickerViewController.cameraDevice = UIImagePickerControllerCameraDevice.Rear
            }
        } else if overlay == self.overlayViewSecondPhoto {
            if self.imagePickerViewControllerSecondPhoto.cameraDevice == .Rear {
                self.imagePickerViewControllerSecondPhoto.cameraDevice = UIImagePickerControllerCameraDevice.Front
            } else {
                self.imagePickerViewControllerSecondPhoto.cameraDevice = UIImagePickerControllerCameraDevice.Rear
            }
        }
    }
    
    func flashButtonDidTap(overlay: SPCameraOverlay) {
        if overlay == self.overlayView {
            self.updateFlashWithPickerView(self.imagePickerViewController)
        } else {
            self.updateFlashWithPickerView(self.imagePickerViewControllerSecondPhoto)
            self.overlayView.flashEnabled = self.flashState
        }
    }
    
    func updateFlashWithPickerView( pickerView:UIImagePickerController ) {
        if flashState.integerValue == UIImagePickerControllerCameraFlashMode.On.rawValue {
            pickerView.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
            self.flashState = NSNumber(integer: UIImagePickerControllerCameraFlashMode.Off.rawValue)
            self.imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
        } else {
            pickerView.cameraFlashMode = UIImagePickerControllerCameraFlashMode.On
            self.flashState = NSNumber(integer: UIImagePickerControllerCameraFlashMode.On.rawValue)
            self.imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.On
        }
        
    }
    
    func selectPhotosDidTap(overlay: SPCameraOverlay) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takeNewAction = UIAlertAction(title: "From My Stuff", style: UIAlertActionStyle.Default) { (action) -> Void in
            let myClosetViewController = SPCameraClosetViewController()
            myClosetViewController.delegate = self
            //            var closetView = myClosetViewController.view
            myClosetViewController.navigationItem.rightBarButtonItem = nil
            if overlay == self.overlayView {
                self.imagePickerViewController.pushViewController(myClosetViewController, animated: true)
            } else if overlay == self.overlayViewSecondPhoto {
                self.imagePickerViewControllerSecondPhoto.pushViewController(myClosetViewController, animated: true)
            }
            
            myClosetViewController.navigationController?.setNavigationBarHidden(false, animated: false)
            
        }
        
        
        let fromPhotoAlbumnAction = UIAlertAction(title: "From Photo Album", style: UIAlertActionStyle.Default) { (action) -> Void in
            if overlay == self.overlayView {
                self.imagePickerViewController.sourceType = .PhotoLibrary
            } else if overlay == self.overlayViewSecondPhoto {
                self.imagePickerViewControllerSecondPhoto.sourceType = .PhotoLibrary
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        alertController.addAction( takeNewAction )
        alertController.addAction( fromPhotoAlbumnAction )
        alertController.addAction( cancelAction )
        if overlay == self.overlayView {
            self.imagePickerViewController.presentViewController(alertController, animated: true, completion: nil)
        } else if overlay == self.overlayViewSecondPhoto {
            self.imagePickerViewControllerSecondPhoto.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    func takePhotoButtonDidTap( overlay: SPCameraOverlay ) {
        if overlay == self.overlayView {
            self.imagePickerViewController.takePicture()
        } else if overlay == self.overlayViewSecondPhoto {
            self.imagePickerViewControllerSecondPhoto.takePicture()
        }
    }
    
    func dismissCamera( overlay: SPCameraOverlay ) {
        if overlay == self.overlayView {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if overlay == self.overlayViewSecondPhoto {
            self.confirmationViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let originalImage = info[ UIImagePickerControllerOriginalImage ] as! UIImage
        var imageOrientation = UIImageOrientation.Up
        let squareDimension = originalImage.size.width > originalImage.size.height ? originalImage.size.height : originalImage.size.width
        if ( picker.sourceType == UIImagePickerControllerSourceType.Camera ) {
            // Do something with an image from the camera
            imageOrientation = UIImageOrientation.Right
        }
        
        let photoX = (originalImage.size.width - squareDimension) / 2
        let squareRect = CGRectMake( photoX, 0, squareDimension, squareDimension )
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(originalImage.CGImage, squareRect)!;
        let squareImage = UIImage(CGImage:imageRef, scale: 1, orientation: imageOrientation )
        
        //TODO: Comment this in when we want photos to save to album.  Really annoying right now..
        //UIImageWriteToSavedPhotosAlbum(squareImage, self, nil, nil)
        capturedImages.append(squareImage)
        
        self.showConfirmationView()
        
    }
    
    func showConfirmationView() {
        if(capturedImages.count >= 2){
            var confirmView = confirmationViewControllerSecondPhoto.view // view must be created before accessed
            confirmationViewControllerSecondPhoto.photo.image = capturedImages[1]
            confirmationViewControllerSecondPhoto.nextCameraButton.hidden = true
            confirmationViewControllerSecondPhoto.nextSendButton.hidden = false
            confirmationViewControllerSecondPhoto.titleText.text = "Photo 2 of 2"
            
            //                self.imagePickerViewController.presentViewController(confirmationStoryboard, animated: true, completion: nil)
            self.imagePickerViewControllerSecondPhoto.pushViewController(confirmationViewControllerSecondPhoto, animated: true)
        } else {
            
            //            self.imagePickerViewController.pushViewController(confirmationStoryboard, animated: true)
            var confirmView = confirmationViewController.view // view must be created before accessed
            confirmationViewController.photo.image = capturedImages[0]
            //                self.imagePickerViewController.presentViewController(confirmationStoryboard, animated: true, completion: nil)
            self.imagePickerViewController.pushViewController(confirmationViewController, animated: true)
            
        }
    }
    
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if(viewController.restorationIdentifier == "SPEditPhotoViewController"){
            return false
        }
        return true
    }
    
    func nextSendButtonDidTap() {
        let postPhotoViewController = SPEditPhotoViewController(nibName:"SPEditPhotoViewController", bundle: nil)
        postPhotoViewController.image = capturedImages[0];
        postPhotoViewController.imageTwo = capturedImages[1];
        self.imagePickerViewControllerSecondPhoto.pushViewController(postPhotoViewController, animated: true)
    }
    
    func nextCameraButtonDidTap() {
        self.showSecondCamera()
    }
    
    func confirmationBackButtonDidTap() {
        if capturedImages.count <= 1 {
            self.imagePickerViewController.popViewControllerAnimated(true)
        } else {
            self.imagePickerViewControllerSecondPhoto.popViewControllerAnimated(true)
        }
        
        capturedImages.removeLast()
    }
    
    func userSelectedImage( image: UIImage ) {
        capturedImages.append(image)
        if capturedImages.count <= 1 {
            self.imagePickerViewController.popViewControllerAnimated(true)
        } else {
            self.imagePickerViewControllerSecondPhoto.popViewControllerAnimated(true)
        }        
        
        self.showConfirmationView()
    }
    
}
