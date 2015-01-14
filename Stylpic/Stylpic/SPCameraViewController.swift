//
//  SPCameraViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Parse

class SPCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate{

    var cameraUI = UIImagePickerController()//: UIImagePickerController!
    var navController = UINavigationController()
    //var actionSheet : UIActionSheet
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//    }
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //        var testObject = PFObject(className: "TestObject")
        //        testObject["foo"] = "bar"
        //        testObject.saveInBackgroundWithBlock(nil)
        
        loadFBData()
        
        
//        var loginView = FBLoginView()
//        loginView.center = self.view.center;
//        self.view.addSubview(loginView)
        
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
    
    
    @IBAction func cameraButton(sender: AnyObject) {
//        self.presentViewController(cameraUI, animated: true, completion:nil)
        
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
    

    @IBAction func logoutButtonTouchUpInside(sender: AnyObject) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
            println("Selected Image")
            self.dismissViewControllerAnimated(true, completion: nil)
        
        var viewController = SPEditPhotoViewController(aImage: image)
        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        navController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        navController.pushViewController(viewController, animated: true)
        
        self.presentViewController(navController, animated: true, completion: nil)
        
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
                userPhoto.saveInBackgroundWithBlock({ (success, saveError) -> Void in
                    if(saveError != nil){
                        println(saveError.userInfo)
                    }
                })
            }
        }
    }
    
    

    
    
    
    
    
    func loadFBData(){
        var request = FBRequest.requestForMe()
        request.startWithCompletionHandler { (connection, result, error) -> Void in
            //TODO: Need to test this facebook user invalidation testing out.
            if let cError = error{
                if let cUserInfo = cError.userInfo{
                    if let cError = cUserInfo["error"] as? NSDictionary{
                        if let cType = cError["type"] as? String{
                            if cType == "OAuthException"{
                                println("FB Session was invalidated.")
                                //self.logoutButtonTouchUpInside(nil)
                            }
                        }
                    }
                }
                
            }
            else
            {
                var userData = result as NSDictionary
                
                var facebookID = userData["id"] as String;
                var name = userData["name"] as String;
                
                self.welcomeLabel.text = "Welcome: \(name)"
                
                var pictureURL = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1")
                
                var request = NSURLRequest(URL: pictureURL)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, connectionError) -> Void in
                    if (connectionError == nil && data != nil) {
                        // Set the image in the header imageView
                        self.profilePicImageView.image = UIImage(data: data)
                    }
                })
                
            }
        }
    }

    
}
