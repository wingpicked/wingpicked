//
//  SPTabBarController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 4/4/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPTabBarController: UITabBarController, UITabBarControllerDelegate, UITabBarDelegate, UIImagePickerControllerDelegate, SPCameraOverlayDelegate, UINavigationControllerDelegate, SPPhotoConfirmationViewControllerDelegate, SPCameraClosetViewControllerDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var backgroundColor = UIColor(red: 25/255, green: 37/255, blue: 44/255, alpha: 1.0)
        var iconTintColor = UIColor(red: 158/255, green: 228/255, blue: 229/255, alpha: 1.0)
        var backgroundImage = UIImage(fromColor: backgroundColor, forSize: CGSizeMake(320, 49), withCornerRadius: 0)
        self.tabBar.backgroundImage = backgroundImage
        self.tabBar.translucent = false
        self.tabBar.tintColor = iconTintColor
        self.addCenterButton(UIImage(named: "Icon_post")!, highlightImage: UIImage(named: "Icon_post")!, target: self, action: Selector("buttonPressed:"))
        
        for vc in self.viewControllers as! [UIViewController]{
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        }

        self.confirmationViewController.delegate = self
        self.confirmationViewControllerSecondPhoto.delegate = self
        self.imagePickerViewController.delegate = self
        self.imagePickerViewControllerSecondPhoto.delegate = self
        self.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfileBadgeNumber", name: "Badges", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfileBadgeNumber", name: UIApplicationDidBecomeActiveNotification, object: nil)
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
    
    func updateProfileBadgeNumber() {
        var badgeNum = UIApplication.sharedApplication().applicationIconBadgeNumber
        for viewController in self.viewControllers as! [UIViewController] {
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
            var profileViewController = (viewController as! UINavigationController).viewControllers[0] as! SPProfileViewController
            profileViewController.showWithUser(SPUser.currentUser()!)
        }
    }
    
    func addCenterButton(buttonImage: UIImage, highlightImage: UIImage, target:AnyObject, action:Selector){
        var button = UIButton()
        button.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | .FlexibleLeftMargin | .FlexibleBottomMargin | .FlexibleTopMargin
        
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
        
        //Reset Camera
        capturedImages = []
        overlayView.titleLabel.text = "Photo 1 of 2"
        
        imagePickerViewController.sourceType = .Camera
        imagePickerViewController.showsCameraControls = false;
        overlayView.delegate = self
        imagePickerViewController.cameraOverlayView = overlayView
        overlayView.pickingTheLastImageFromThePhotoLibrary()
        self.presentViewController(imagePickerViewController, animated: true, completion: nil)
    }
    
    func showSecondCamera() {
        overlayViewSecondPhoto.titleLabel.text = "Photo 2 of 2"
        
        imagePickerViewControllerSecondPhoto.sourceType = .Camera
        imagePickerViewControllerSecondPhoto.showsCameraControls = false;
        overlayViewSecondPhoto.delegate = self
        imagePickerViewControllerSecondPhoto.cameraOverlayView = overlayViewSecondPhoto
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
            if self.imagePickerViewController.cameraFlashMode == UIImagePickerControllerCameraFlashMode.On {
                self.imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
            } else {
                self.imagePickerViewController.cameraFlashMode = .On
            }
        } else if overlay == self.overlayViewSecondPhoto {

            if self.imagePickerViewControllerSecondPhoto.cameraFlashMode == UIImagePickerControllerCameraFlashMode.On {
                self.imagePickerViewControllerSecondPhoto.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
            } else {
                self.imagePickerViewControllerSecondPhoto.cameraFlashMode = .On
            }
        }
    }
    
    func selectPhotosDidTap(overlay: SPCameraOverlay) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takeNewAction = UIAlertAction(title: "From My Closet", style: UIAlertActionStyle.Default) { (action) -> Void in
            let myClosetViewController = SPCameraClosetViewController()
            myClosetViewController.delegate = self
            var closetView = myClosetViewController.view
            myClosetViewController.navigationItem.rightBarButtonItem = nil
            if overlay == self.overlayView {
                self.imagePickerViewController.pushViewController(myClosetViewController, animated: true)
            } else if overlay == self.overlayViewSecondPhoto {
                self.imagePickerViewControllerSecondPhoto.pushViewController(myClosetViewController, animated: true)
            }
            
            myClosetViewController.navigationController?.setNavigationBarHidden(false, animated: false)

        }
        
        
        let fromPhotoAlbumnAction = UIAlertAction(title: "From Photo Album", style: UIAlertActionStyle.Default) { (action) -> Void in
            println( "photo albumn did select")
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
        
        self.showConfirmationView()

    }
    
    func showConfirmationView() {
        if(capturedImages.count >= 2){
            var confirmView = confirmationViewControllerSecondPhoto.view
            confirmationViewControllerSecondPhoto.photo.image = capturedImages[1]
            confirmationViewControllerSecondPhoto.nextCameraButton.hidden = true
            confirmationViewControllerSecondPhoto.nextSendButton.hidden = false
            confirmationViewControllerSecondPhoto.titleText.text = "Photo 2 of 2"
            
            //                self.imagePickerViewController.presentViewController(confirmationStoryboard, animated: true, completion: nil)
            self.imagePickerViewControllerSecondPhoto.pushViewController(confirmationViewControllerSecondPhoto, animated: true)
        } else {
            
            //            self.imagePickerViewController.pushViewController(confirmationStoryboard, animated: true)
            var confirmView = confirmationViewController.view
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
        var postPhotoViewController = SPEditPhotoViewController(nibName:"SPEditPhotoViewController", bundle: nil)
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
