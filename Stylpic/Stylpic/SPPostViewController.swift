//
//  SPCameraFlowViewController.swift
//  Stylpic
//
//  Created by Joshua Bell on 2/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit


enum SPImageSelectionMethod {
    case Camera, Library
}

/*!
 *   @description manages the flow of choosing the two photos
*/
class SPPostViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SPCameraOverlayDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var userPhotoOne : UIImage?
    var userPhotoTwo : UIImage?
    var curImagePickerController: UIImagePickerController?
    var overlayView : SPCameraOverlay?
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.curImagePickerController = UIImagePickerController()
        self.curImagePickerController?.delegate = self
        self.curImagePickerController?.allowsEditing = false
        
        self.overlayView = NSBundle.mainBundle().loadNibNamed("SPCameraOverlay", owner: nil, options: nil)[0] as! SPCameraOverlay
        overlayView?.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.userPhotoOne = nil;
        self.userPhotoTwo = nil;
        self.captionTextField.text = ""
        self.shareButton.alpha = 1
        self.shareButton.userInteractionEnabled = true
        self.shouldStartCameraController()
    }
    
    
    func showImageSelectionChoicesActionSheet() {
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "From My Closet", "From Photo Album")
        actionSheet.showInView(self.view)
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println("Button Index: \(buttonIndex)")
        
        if (buttonIndex == 1) {
            // from my closet selected
            println( "TODO: ask for mockups of closet image selection method" )
            
        } else if (buttonIndex == 2) {
            // from camera roll selected
            let libraryPickerDidStart = self.shouldStartPhotoLibraryPickerController()
            if !libraryPickerDidStart {
                var needsPhotoAccessController = UIAlertView(title: "Error", message: "Access to Photos not granted", delegate: nil, cancelButtonTitle: "Ok")
                needsPhotoAccessController.show()
            }
        }
    }
    
    
    func shouldStartCameraController() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == false {
            self.showImageSelectionChoicesActionSheet()
            return false;
        }
        
        self.curImagePickerController?.sourceType = UIImagePickerControllerSourceType.Camera
            
        if(UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear)) {
            self.curImagePickerController?.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        } else if(UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)){
            self.curImagePickerController?.cameraDevice = UIImagePickerControllerCameraDevice.Front
        }

        
        self.overlayView?.titleLabel.text = self.userPhotoOne != nil ? "Photo 2 of 2" : "Photo 1 of 2"
        self.curImagePickerController?.cameraOverlayView = overlayView
//        self.curImagePickerController?.allowsEditing = false
        self.curImagePickerController?.showsCameraControls = false
        
//        let presentingController =
        if self.presentedViewController == nil {
            self.presentViewController(self.curImagePickerController!, animated: true, completion: nil)
        }
        
        return true
    }
    
    func shouldStartPhotoLibraryPickerController()->Bool{
        
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)){
            return false;
        }
        
        
        
        //TODO: add controllersourcetype
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)  {
            self.curImagePickerController?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            //cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        }
        else if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)){
            self.curImagePickerController?.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            //cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        }
        else {
            return false;
        }
        
        if self.presentedViewController == nil {
            self.presentViewController(self.curImagePickerController!, animated: true, completion: nil)
        }
        
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let originalImage = info[ UIImagePickerControllerOriginalImage ] as! UIImage
        println( "original image \(originalImage)" )
        let squareRect = CGRectMake( 0, 0, originalImage.size.width, originalImage.size.width )
        var imageRef: CGImageRef = CGImageCreateWithImageInRect(originalImage.CGImage, squareRect);
        var squareImage = UIImage(CGImage:imageRef, scale: 1, orientation: UIImageOrientation.Right)
        if let constUserPhotoOne = self.userPhotoOne {
            self.userPhotoTwo = squareImage;
            var editPhotoStoryboard = UIStoryboard(name: "SPEditPhotoStoryboard", bundle: nil)
            var editPhotoController = editPhotoStoryboard.instantiateViewControllerWithIdentifier("SPEditPhotoViewController") as! SPEditPhotoViewController
            self.imageViewOne.image = self.userPhotoOne
            self.imageViewTwo.image = self.userPhotoTwo
            self.dismissViewControllerAnimated(true, completion:nil)
        } else {
            self.userPhotoOne = squareImage;
            self.shouldStartCameraController()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        if self.curImagePickerController?.sourceType != UIImagePickerControllerSourceType.Camera {
            self.shouldStartCameraController()
        }
    }
    

    func selectPhotosDidTap() {
//        self.dismissViewControllerAnimated(true, completion: nil)
        self.showImageSelectionChoicesActionSheet()
    }
    
    
    func takePhotoButtonDidTap() {
        self.curImagePickerController?.takePicture()
    }
    
    
//    
    func shareAndPostPhotos( resultsBlock: PFBooleanResultBlock ) {
//        
        SPManager.sharedInstance.saveImages(self.imageViewOne.image, imageTwo: self.imageViewTwo.image) { (imageOne, imageOneThumbnail, imageTwo, imageTwoThumbnail, error) -> Void in
            if error == nil {
                var photos = SPPhotos(imageOne: imageOne!, thumbnailImageOne: imageOneThumbnail!, imageTwo: imageTwo!, thumbnailImageTwo: imageTwoThumbnail!, postCaption: self.captionTextField.text!, postingUser: SPUser.currentUser()! )
                photos.saveInBackgroundWithBlock({ (success, error) -> Void in
                    resultsBlock( success, error )
                })
            } else {
                println( error )
            }
        }
    }
    
    @IBAction func viewDidTap(sender: AnyObject) {
        self.captionTextField.resignFirstResponder()
    }
    
    @IBAction func shareButtonDidTap(sender: AnyObject) {
        println( "share button did tap" )
        self.shareButton.userInteractionEnabled = false
        self.shareButton.alpha = 0.4
        self.shareAndPostPhotos { (success, error) -> Void in
            if error == nil {
                println( success )
            } else {
                println( error )
            }
        }
    }
    
    
    
}
