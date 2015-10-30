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
    let curImagePickerController = UIImagePickerController()
    var overlayView : SPCameraOverlay?
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.curImagePickerController.delegate = self
        self.curImagePickerController.allowsEditing = false
        
        self.overlayView = NSBundle.mainBundle().loadNibNamed("SPCameraOverlay", owner: nil, options: nil)[0] as? SPCameraOverlay
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
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "From My Closet", "From Photo Album")
        actionSheet.showInView(self.view)
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1) {
            // from my closet selected
            print( "TODO: ask for mockups of closet image selection method" )
            
        } else if (buttonIndex == 2) {
            // from camera roll selected
            let libraryPickerDidStart = self.shouldStartPhotoLibraryPickerController()
            if !libraryPickerDidStart {
                let needsPhotoAccessController = UIAlertView(title: "Error", message: "Access to Photos not granted", delegate: nil, cancelButtonTitle: "Ok")
                needsPhotoAccessController.show()
            }
        }
    }
    
    
    func shouldStartCameraController() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == false {
            self.showImageSelectionChoicesActionSheet()
            return false;
        }
        
        self.curImagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            
        if(UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear)) {
            self.curImagePickerController.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        } else if(UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)){
            self.curImagePickerController.cameraDevice = UIImagePickerControllerCameraDevice.Front
        }

        
        self.overlayView?.titleLabel.text = self.userPhotoOne != nil ? "Photo 2 of 2" : "Photo 1 of 2"
        self.curImagePickerController.cameraOverlayView = overlayView
        self.curImagePickerController.showsCameraControls = false
        self.curImagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.On
        if self.presentedViewController == nil {
            self.presentViewController(self.curImagePickerController, animated: true, completion: nil)
        }
        
        return true
    }
    
    func shouldStartPhotoLibraryPickerController()->Bool{
        
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)){
            return false;
        }
        
        //TODO: add controllersourcetype
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)  {
            self.curImagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        }
        else if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)){
            self.curImagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        }
        else {
            return false;
        }
        
        if self.presentedViewController == nil {
            self.presentViewController(self.curImagePickerController, animated: true, completion: nil)
        }
        
        return true
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
        if let _ = self.userPhotoOne {
            self.userPhotoTwo = squareImage;
//            let editPhotoStoryboard = UIStoryboard(name: "SPEditPhotoStoryboard", bundle: nil)
//            _ = editPhotoStoryboard.instantiateViewControllerWithIdentifier("SPEditPhotoViewController") as! SPEditPhotoViewController
            self.imageViewOne.image = self.userPhotoOne
            self.imageViewTwo.image = self.userPhotoTwo
            self.dismissViewControllerAnimated(true, completion:nil)
        } else {
            self.userPhotoOne = squareImage;
            self.shouldStartCameraController()
        }
    }
    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        if self.curImagePickerController.sourceType != UIImagePickerControllerSourceType.Camera {
//            self.shouldStartCameraController()
//        }
//    }
    
    func switchCameraButtonDidTap(overlay: SPCameraOverlay) {
        if self.curImagePickerController.cameraDevice == .Rear {
            self.curImagePickerController.cameraDevice = UIImagePickerControllerCameraDevice.Front
        } else {
            self.curImagePickerController.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        }
    }
    
    func flashButtonDidTap(overlay: SPCameraOverlay) {
        if self.curImagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashMode.On {
            self.curImagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
        } else {
            self.curImagePickerController.cameraFlashMode = .On
        }
    }
    
    func selectPhotosDidTap(overlay: SPCameraOverlay) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        self.showImageSelectionChoicesActionSheet()
    }
    
    
    func takePhotoButtonDidTap(overlay: SPCameraOverlay) {
        self.curImagePickerController.takePicture()
    }
    
    @IBAction func viewDidTap(sender: AnyObject) {
        self.captionTextField.resignFirstResponder()
    }
    
    func dismissCamera( overlay: SPCameraOverlay ) {
    }
    
    
}
