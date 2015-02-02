//
//  SPTabBarViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPTabBarViewController: UITabBarController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITabBarControllerDelegate {
    
    var navController = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.delegate = self
    }

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {

        if((viewControllers as [UIViewController])[2] == viewController){
            self.photoCaptureButtonAction()
            return false
        }
        return true
    }
    
    func photoCaptureButtonAction(){
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
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Selected Image")
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//        var viewController = SPEditPhotoViewController(aImage: image)
//        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        
//        navController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        navController.pushViewController(viewController, animated: true)
//        
//        self.presentViewController(navController, animated: true, completion: nil)
        
        var imageData = UIImageJPEGRepresentation(image, 0.05)
        self.uploadImage(imageData)
    }
    
    func uploadImage(imageData : NSData) {
        var imageFile = PFFile(name: "Image.jpg", data: imageData)
        
        // Save PFFile
        
        imageFile.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if(error == nil){
                var userPhoto = PFObject(className: "UserPhoto")
                userPhoto.setObject(imageFile, forKey: "imageFile")
                userPhoto.setObject("This is a hardcoded caption", forKey: "caption")
                userPhoto.saveInBackgroundWithBlock({ (success, saveError) -> Void in
                    if(saveError != nil){
                        println(saveError.userInfo)
                    }
                })
            }
        }
    }
}
