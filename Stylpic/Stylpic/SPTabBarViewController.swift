//
//  SPTabBarViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPTabBarViewController: UITabBarController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    var navController = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var z2 = self.tabBar.items![2] as UITabBarItem
        z2.image = nil
        z2.title = nil

        var itemCount = CGFloat(self.tabBar.items!.count) //default to 131.0
        
        
        var cameraButton = UIButton(frame: CGRectMake(124.0, 0.0, self.tabBar.bounds.size.width / itemCount, self.tabBar.bounds.size.height))
        cameraButton.setImage(UIImage(named: "TakePicture"), forState: UIControlState.Normal)
        cameraButton.addTarget(self, action: Selector("photoCaptureButtonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.tabBar.addSubview(cameraButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func setViewControllers(viewControllers: [AnyObject], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        
        
        var cameraButton = UIButton(frame: CGRectMake(94.0, 0.0, 131.0, self.tabBar.bounds.size.height))
        cameraButton.setImage(UIImage(named: "TakePicture"), forState: UIControlState.Normal)
        cameraButton.addTarget(self, action: Selector("photoCaptureButtonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.tabBar.addSubview(cameraButton)
    
//    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [swipeUpGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
//    [swipeUpGestureRecognizer setNumberOfTouchesRequired:1];
//    [cameraButton addGestureRecognizer:swipeUpGestureRecognizer];
    }

    func photoCaptureButtonAction(sender: AnyObject){
        println("Photo Button Pushed")
        
        var cameraDeviceAvailable = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        var photoLibraryAvailable = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        
        if (cameraDeviceAvailable && photoLibraryAvailable) {
            var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Photo", "Choose Photo")
            actionSheet.showFromTabBar(self.tabBarController?.tabBar)
        } else {
            // if we don't have at least two options, we automatically show whichever is available (camera or roll)
            self.shouldPresentPhotoCaptureController()
        }
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println("Button Index: \(buttonIndex)")
        
        if (buttonIndex == 1) {
            self.shouldStartCameraController();
        } else if (buttonIndex == 2) {
            self.shouldStartPhotoLibraryPickerController();
        }
    }
    
    func shouldPresentPhotoCaptureController() -> Bool{
        
        var presentedPhotoCaptureController = self.shouldStartCameraController()
        
        if (!presentedPhotoCaptureController) {
            presentedPhotoCaptureController = self.shouldStartPhotoLibraryPickerController()
        }
        
        return presentedPhotoCaptureController;
    }
    
    func shouldStartCameraController() -> Bool {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == false){
            return false;
        }
        
        var cameraUI = UIImagePickerController()
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
            
            if(UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear)){
                cameraUI.cameraDevice = UIImagePickerControllerCameraDevice.Rear
            }
            else if(UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)){
                cameraUI.cameraDevice = UIImagePickerControllerCameraDevice.Front
            }
        }
        else{
            return false
        }
        
        cameraUI.allowsEditing = true
        cameraUI.showsCameraControls = true
        cameraUI.delegate = self
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
        
        return true
    }
    
    func shouldStartPhotoLibraryPickerController()->Bool{
        
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)){
            return false;
        }
        
        var cameraUI = UIImagePickerController()
        
        
        //TODO: add controllersourcetype
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)){
            cameraUI.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            //cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        }
        else if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)){
            cameraUI.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            //cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        }
        else {
            return false;
        }
        
        cameraUI.allowsEditing = true;
        cameraUI.delegate = self;
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
        return true
    }
}
