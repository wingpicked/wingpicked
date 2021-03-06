//
//  SPClosetViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPClosetViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SPClosetDetailViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SPCameraOverlayDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var closetPhotos : [SPClosetPhoto]? //= [PFFile]()
    var lastTappedRow = 0
    let imagePickerViewController = UIImagePickerController()
    let overlayView = NSBundle.mainBundle().loadNibNamed("SPCameraOverlay", owner: nil, options: nil)[0] as! SPCameraOverlay
    let emptyState: UIView = NSBundle.mainBundle().loadNibNamed("SPClosetEmptyStateView", owner: nil, options: nil)[0] as! UIView
    let rc = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "SPClosetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SPClosetCollectionViewCell")
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "MyClosetTopBarTitle-Edit"), forBarMetrics: UIBarMetrics.Default)

        self.navigationItem.title = "MY STUFF"
        
        let findFriendsImage = UIImage( named: "Icon_addToCloset" )
        let findFriendsButton = UIButton(frame: CGRectMake( 0,0, 20,20))
        findFriendsButton.setImage(findFriendsImage, forState: UIControlState.Normal)
        findFriendsButton.addTarget(self, action: "addImageButtonDidTap", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem( customView: findFriendsButton )
        self.imagePickerViewController.delegate = self

        
        rc.addTarget(self, action: Selector("refreshCollectionView"), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.addSubview(rc)
        self.overlayView.photoLibraryButton.hidden = true

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.collectionView.contentOffset = CGPointMake(0, -self.rc.frame.size.height);
        self.rc.beginRefreshing()
        self.refreshCollectionView()
        
    }
    
    func refreshCollectionView(){
        SPManager.sharedInstance.getMyClosetItemsWithResultBlock { (someClosetPhotos, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if let someClosetPhotosAgain = someClosetPhotos {
                    self.closetPhotos = someClosetPhotosAgain
                    self.collectionView.reloadData()
                    self.respondToClosetPhotosChange()
                    
                }
                
            }
            self.rc.endRefreshing()
        }
    }
    
    func respondToClosetPhotosChange() {
        if let someClosetPhotosAgain = self.closetPhotos {
            if someClosetPhotosAgain.count <= 0 {
                self.emptyState.frame = self.view.frame
                self.view.addSubview( self.emptyState )
            } else {
                if self.emptyState.superview != nil {
                    self.emptyState.removeFromSuperview()
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(0, 16)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SPClosetCollectionViewCell", forIndexPath: indexPath) as! SPClosetCollectionViewCell
        
        if let closetPhotos = self.closetPhotos {
            let closetPhoto = closetPhotos[indexPath.row]
            let aFile = closetPhoto.photo.photoThumbnail
            cell.setupWithPFFile( aFile )
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.closetPhotos != nil ? self.closetPhotos!.count : 0;
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.lastTappedRow = indexPath.row
//        var detailViewController = SPClosetDetailViewController( aPFFile: self.pfFiles![indexPath.row] )
//        self.navigationController?.pushViewController(detailViewController, animated: true)
        self.performSegueWithIdentifier("SPClosetDetailViewController", sender: self);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Make sure your segue name in storyboard is the same as this line
        if segue.identifier == "SPClosetDetailViewController" {
            // Get reference to the destination view controller
            let viewController = segue.destinationViewController as! SPClosetDetailViewController
            
            // Pass any objects to the view controller here, like...
            let closetPhoto = self.closetPhotos![self.lastTappedRow]
            viewController.delegate = self
            viewController.setupWithClosetPhoto( closetPhoto )
        }
    }
    
    func removeClosetPhoto( closetPhoto: SPClosetPhoto ) {
        var indexToRemove = -1
        for var i = self.closetPhotos!.count - 1; i >= 0; --i {
            let aClosetPhoto = self.closetPhotos![ i ]
            if aClosetPhoto.objectId == closetPhoto.objectId {
                indexToRemove = i
                break
            }
        }
        
        if indexToRemove >= 0 {
            self.closetPhotos?.removeAtIndex( indexToRemove )
            SPManager.sharedInstance.removeClosetPhoto( closetPhoto )
            self.collectionView.reloadData()
        }
    }

    func addImageButtonDidTap() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takeNewAction = UIAlertAction(title: "Take New Photo", style: UIAlertActionStyle.Default) { (action) -> Void in
            if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
                let ac = UIAlertController(title: "Camera Unavailable", message: "This device doesn't appear to have a camera.  Please try using a device with a camera to access this feature.", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
                ac.addAction(action)
                self.presentViewController(ac, animated: true, completion: nil)
                print( "camera unavailable for device")
                return;
            }
            
            self.overlayView.titleLabel.text = ""
            
            self.imagePickerViewController.sourceType = .Camera
            self.imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
            self.imagePickerViewController.showsCameraControls = false;
            self.overlayView.delegate = self
            self.overlayView.flashEnabled = NSNumber(integer: UIImagePickerControllerCameraFlashMode.Off.rawValue)
            self.imagePickerViewController.cameraOverlayView = self.overlayView
            self.presentViewController(self.imagePickerViewController, animated: true, completion: nil)
        }
        
        let fromPhotoAlbumnAction = UIAlertAction(title: "From Photo Album", style: UIAlertActionStyle.Default) { (action) -> Void in
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
    
    func switchCameraButtonDidTap(overlay: SPCameraOverlay) {
        if self.imagePickerViewController.cameraDevice == .Rear {
            self.imagePickerViewController.cameraDevice = UIImagePickerControllerCameraDevice.Front
        } else {
            self.imagePickerViewController.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        }
    }
    
    //TODO: Need to check if flash exists before setting this.
    func flashButtonDidTap(overlay: SPCameraOverlay) {
        
        if self.imagePickerViewController.cameraFlashMode == UIImagePickerControllerCameraFlashMode.On {
            self.imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
//            self.overlayView.flashButton.setImage(UIImage(named:"Icon_flash"), forState:UIControlState.Normal)
        } else {
            self.imagePickerViewController.cameraFlashMode = .On
//            self.overlayView.flashButton.setImage(UIImage(named:"Icon_flash_on"), forState:UIControlState.Normal)
        }
    }
    
    func takePhotoButtonDidTap(overlay: SPCameraOverlay) {
        self.imagePickerViewController.takePicture()
    }
    
    func dismissCamera( overlay: SPCameraOverlay ) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectPhotosDidTap(overlay: SPCameraOverlay) {
        
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
        SPManager.sharedInstance.addMyClosetItemWithImage(squareImage, resultBlock: { (success, error) -> Void in
            if error == nil {
                SPManager.sharedInstance.getMyClosetItemsWithResultBlock { (someClosetPhotos, error) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        if let someClosetPhotosAgain = someClosetPhotos {
                            self.closetPhotos = someClosetPhotosAgain
                            self.collectionView.reloadData()
                            self.respondToClosetPhotosChange()
                        }
                        
                    }
                }
            }
        })
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
