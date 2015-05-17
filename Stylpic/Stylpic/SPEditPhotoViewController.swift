//
//  SPEditPhotoViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/12/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Social

class SPEditPhotoViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, SPCameraOverlayDelegate, UINavigationControllerDelegate {

    var image : UIImage!
    var imageTwo : UIImage!
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    
    var replaceImage = ImageIdentifier.ImageOne
    let imagePickerViewController = UIImagePickerController()
    let overlayView = NSBundle.mainBundle().loadNibNamed("SPCameraOverlay", owner: nil, options: nil)[0] as! SPCameraOverlay
    
    @IBOutlet weak var captionTextfield: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        var imageOneTapRecogniser = UITapGestureRecognizer(target: self, action: "imageOneDidTap")
        imageOneTapRecogniser.delegate = self
        self.imageViewOne.image = self.image
        self.imageViewOne.addGestureRecognizer(imageOneTapRecogniser)
        
        var imageTwoTapRecogniser = UITapGestureRecognizer(target: self, action: "imageTwoDidTap")
        imageTwoTapRecogniser.delegate = self
        self.imageViewTwo.image = self.imageTwo
        self.imageViewTwo.addGestureRecognizer(imageTwoTapRecogniser)
        
        self.imageViewOne.layer.cornerRadius = 5.0
        self.imageViewOne.clipsToBounds = true
        self.imageViewTwo.layer.cornerRadius = 5.0
        self.imageViewTwo.clipsToBounds = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let backImage = UIImage(named: "Button_back_black" );
        let backButton = UIButton(frame: CGRect(x: 18, y: 19, width: 15, height: 24))
        backButton.setImage(backImage, forState: UIControlState.Normal)
        backButton.addTarget(self, action: "dismissViewController:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPostFlowButtonDidTap")
        
        let fbSharePhotoButton = FBSDKShareButton(frame: CGRectMake(37, 315, 247, 46)) //TODO: Autolayout this frame
        let fbPhoto1 = FBSDKSharePhoto(image: self.image, userGenerated: true)
        let fbPhoto2 = FBSDKSharePhoto(image: self.imageTwo, userGenerated: true)
        let fbContent = FBSDKSharePhotoContent()
        fbContent.photos = [fbPhoto1, fbPhoto2]

        fbSharePhotoButton.shareContent = fbContent;
        self.view.addSubview(fbSharePhotoButton)
        
        self.imagePickerViewController.delegate = self
    }
    
    func cancelPostFlowButtonDidTap() {
        let cancelPostSheet = UIAlertController(title: "Are you sure you want to cancel your post?", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takeNewAction = UIAlertAction(title: "Cancel Post", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            //            println( "take new photo tapped " )
             NSNotificationCenter.defaultCenter().postNotificationName("SharedPost", object: nil)
        }
        
        
        let cancelAction = UIAlertAction(title: "Nevermind", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        cancelPostSheet.addAction( takeNewAction )
        cancelPostSheet.addAction( cancelAction )
        
        self.presentViewController(cancelPostSheet, animated: true, completion: nil)
        
    }
    
    func dismissViewController(sender: AnyObject!){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func shareImages(sender: UIButton) {
        sender.userInteractionEnabled = false
        sender.alpha = 0.4
        var captionStringWithoutWhitespace = self.captionTextfield.text.stringByTrimmingCharactersInSet( NSCharacterSet.whitespaceCharacterSet())
        if (captionStringWithoutWhitespace as NSString).length > 0 {
            SPManager.sharedInstance.saveAndPostImages(self.image, imageTwo: imageTwo, caption: self.captionTextfield.text) { (success, error) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("SharedPost", object: nil)
                
            }
        } else {
            UIAlertView(title: "Comment missing", message: "You must include a comment to share", delegate: nil, cancelButtonTitle: "Ok").show()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.captionTextfield.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imageOneDidTap() {
        println( "didtapimageone" )
        self.replaceImage = ImageIdentifier.ImageOne
        self.promptForReplacementChoice()
    }
    
    func imageTwoDidTap() {
        println( "didtapImageTwo" )
        self.replaceImage = ImageIdentifier.ImageTwo
        self.promptForReplacementChoice()
    }
    
    func switchCameraButtonDidTap(overlay: SPCameraOverlay) {
        if self.imagePickerViewController.cameraDevice == .Rear {
            self.imagePickerViewController.cameraDevice = UIImagePickerControllerCameraDevice.Front
        } else {
            self.imagePickerViewController.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        }
    }
    
    func flashButtonDidTap(overlay: SPCameraOverlay) {
        if self.imagePickerViewController.cameraFlashMode == UIImagePickerControllerCameraFlashMode.On {
           self.imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
        } else {
            self.imagePickerViewController.cameraFlashMode = .On
        }
    }
    
    func selectPhotosDidTap(overlay: SPCameraOverlay) {
        println("A")
    }
    func takePhotoButtonDidTap(overlay: SPCameraOverlay) {
        self.imagePickerViewController.takePicture()
    }
    
    func dismissCamera( overlay: SPCameraOverlay ) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func promptForReplacementChoice() {
        let alertController = UIAlertController(title: "Replace photo by:", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takeNewAction = UIAlertAction(title: "Taking New Photo", style: UIAlertActionStyle.Default) { (action) -> Void in
            println( "take new photo tapped " )
            self.overlayView.titleLabel.text = "Replace"
            
            self.imagePickerViewController.sourceType = .Camera
            self.imagePickerViewController.showsCameraControls = false;
            self.overlayView.delegate = self
            self.imagePickerViewController.cameraOverlayView = self.overlayView
            self.presentViewController(self.imagePickerViewController, animated: true, completion: nil)
        }
        
        let fromPhotoAlbumnAction = UIAlertAction(title: "Selecting From Photo Album", style: UIAlertActionStyle.Default) { (action) -> Void in
            println( "photo albumn did select")
            self.imagePickerViewController.sourceType = .PhotoLibrary
            self.presentViewController( self.imagePickerViewController, animated: true, completion: nil )
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        alertController.addAction( takeNewAction )
        alertController.addAction( fromPhotoAlbumnAction )
        alertController.addAction( cancelAction )
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let originalImage = info[ UIImagePickerControllerOriginalImage ] as! UIImage
        var imageOrientation = UIImageOrientation.Up
        let squareDimension = originalImage.size.width > originalImage.size.height ? originalImage.size.height : originalImage.size.width
        if ( picker.sourceType == UIImagePickerControllerSourceType.Camera ) {
            // Do something with an image from the camera
            imageOrientation = UIImageOrientation.Right
        }

        let photoX = (originalImage.size.width - squareDimension) / 2
        let squareRect = CGRectMake( photoX, 0, squareDimension, squareDimension )
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(originalImage.CGImage, squareRect);
        let squareImage = UIImage(CGImage:imageRef, scale: 1, orientation: imageOrientation )
        
        //TODO: Comment this in when we want photos to save to album.  Really annoying right now..
        //UIImageWriteToSavedPhotosAlbum(squareImage, self, nil, nil)
        
        if let squareImage = squareImage{
            if replaceImage == .ImageOne {
                self.imageViewOne.image = squareImage
                self.image = squareImage
            } else {
                // must be image two
                self.imageViewTwo.image = squareImage
                self.imageTwo = squareImage
            }
        }
        
        self.dismissCamera( SPCameraOverlay() )
    }
}
