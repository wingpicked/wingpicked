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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "SPClosetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SPClosetCollectionViewCell")
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "MyClosetTopBarTitle-Edit"), forBarMetrics: UIBarMetrics.Default)

        self.navigationItem.title = "MY CLOSET"
        
        var findFriendsImage = UIImage( named: "Icon_addToCloset" )
        var findFriendsButton = UIButton(frame: CGRectMake( 0,0, 20,20))
        findFriendsButton.setImage(findFriendsImage, forState: UIControlState.Normal)
        findFriendsButton.addTarget(self, action: "addImageButtonDidTap", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem( customView: findFriendsButton )
        self.imagePickerViewController.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SPManager.sharedInstance.getMyClosetItemsWithResultBlock { (someClosetPhotos, error) -> Void in
            if error != nil {
                println(error)
            } else {
                if let someClosetPhotosAgain = someClosetPhotos {
                    self.closetPhotos = someClosetPhotosAgain
                    self.collectionView.reloadData()
                    self.respondToClosetPhotosChange()
                    
                }
                
            }
        }
        
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//    }
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
        println(indexPath.row)
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
            var aClosetPhoto = self.closetPhotos![ i ]
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
        println( "addButtonDidTap" )
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takeNewAction = UIAlertAction(title: "Take New Photo", style: UIAlertActionStyle.Default) { (action) -> Void in
            println( "take new photo tapped " )
            self.overlayView.titleLabel.text = "Take a photo"
            
            self.imagePickerViewController.sourceType = .Camera
            self.imagePickerViewController.showsCameraControls = false;
            self.overlayView.delegate = self
            self.imagePickerViewController.cameraOverlayView = self.overlayView
            self.presentViewController(self.imagePickerViewController, animated: true, completion: nil)
        }
        
        let fromPhotoAlbumnAction = UIAlertAction(title: "From Photo Album", style: UIAlertActionStyle.Default) { (action) -> Void in
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
    
    func switchCameraButtonDidTap() {
        if self.imagePickerViewController.cameraDevice == .Rear {
            self.imagePickerViewController.cameraDevice = UIImagePickerControllerCameraDevice.Front
        } else {
            self.imagePickerViewController.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        }
    }
    
    //TODO: Need to check if flash exists before setting this.
    func flashButtonDidTap() {
        
        if self.imagePickerViewController.cameraFlashMode == UIImagePickerControllerCameraFlashMode.On {
            self.imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
        } else {
            self.imagePickerViewController.cameraFlashMode = .On
        }
    }
    
    func takePhotoButtonDidTap() {
        self.imagePickerViewController.takePicture()
    }
    
    func dismissCamera() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectPhotosDidTap() {
        
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let originalImage = info[ UIImagePickerControllerOriginalImage ] as! UIImage
        let squareRect = CGRectMake( 0, 0, originalImage.size.width, originalImage.size.width )
        var imageRef: CGImageRef = CGImageCreateWithImageInRect(originalImage.CGImage, squareRect);
        var squareImage = UIImage(CGImage:imageRef, scale: 1, orientation: UIImageOrientation.Right)
        
        //TODO: Comment this in when we want photos to save to album.  Really annoying right now..
        //UIImageWriteToSavedPhotosAlbum(squareImage, self, nil, nil)
        
        if let squareImage = squareImage{
            SPManager.sharedInstance.addMyClosetItemWithImage(squareImage, resultBlock: { (success, error) -> Void in
                if error == nil {
                    println( "success adding closet item" )
                    SPManager.sharedInstance.getMyClosetItemsWithResultBlock { (someClosetPhotos, error) -> Void in
                        if error != nil {
                            println(error)
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
}
