//
//  SPEditPhotoViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/12/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Social

class SPEditPhotoViewController: UIViewController {

    var image : UIImage!
    var imageTwo : UIImage!
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    
    @IBOutlet weak var captionTextfield: UITextField!
    var facebookShareButton: UIButton?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewOne.image = self.image
        self.imageViewTwo.image = self.imageTwo
        // Do any additional setup after loading the view.
        self.facebookShareButton = UIButton(frame: CGRectMake(37, 315, 247, 46))
        self.facebookShareButton?.setImage(UIImage(named: "facedbookShare"), forState: UIControlState.Normal)
        self.facebookShareButton?.addTarget(self, action: "facebookShareButtonDidTap", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview( self.facebookShareButton! )
        if !SLComposeViewController.isAvailableForServiceType( SLServiceTypeFacebook ) {
            self.facebookShareButton?.userInteractionEnabled = false
            self.facebookShareButton?.alpha = 0.35
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        println( self.facebookShareButton )
    }

    @IBAction func shareImages(sender: AnyObject) {
        SPManager.sharedInstance.saveAndPostImages(self.image, imageTwo: imageTwo, caption: self.captionTextfield.text) { (success, error) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        
        
//        SPManager.sharedInstance.saveImages(self.imageViewOne.image, imageTwo: self.imageViewTwo.image) { (imageOne, imageOneThumbnail, imageTwo, imageTwoThumbnail, error) -> Void in
//            if error == nil {
//                var photos = SPPhotoPair()
//                photos.imageOne = imageOne
//                photos.imageTwo = imageTwo
//                photos.thumbnailOne = imageOneThumbnail
//                photos.thumbnailTwo = imageTwoThumbnail
//                photos.caption = self.captionTextfield.text!
//                photos.user = SPUser.currentUser()
//                
//                photos.saveInBackgroundWithBlock({ (success, error) -> Void in
//                    resultsBlock( success, error )
//                })
//            } else {
//                println( error )
//            }
//            
//            self.dismissViewControllerAnimated(true, completion: nil)
//
//        }
        
    }
    
    
    func facebookShareButtonDidTap() {
        self.facebookShareButton?.userInteractionEnabled = false
        self.facebookShareButton?.alpha = 0.35
        if SLComposeViewController.isAvailableForServiceType( SLServiceTypeFacebook ) {
            let composeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            composeViewController.setInitialText(self.captionTextfield.text)
            var combinedImage = self.imageByCombiningImage(self.image, secondImage: self.imageTwo)
            composeViewController.addImage(combinedImage)
            composeViewController.addURL( NSURL(string: "http://machi.ne") )
            composeViewController.completionHandler = { (result:SLComposeViewControllerResult) in
                if result == .Done {
                    println( "shared on facebook" )
                    UIAlertView( title: "Sharing Complete", message: "You've just shared a post to facebook!", delegate: nil, cancelButtonTitle: "Ok").show()
                } else if result == .Cancelled {
                    println( "user cancelled sharing" )
                    self.facebookShareButton?.userInteractionEnabled = true
                    self.facebookShareButton?.alpha = 1
                }
            }
            self.presentViewController(composeViewController, animated: true, completion: nil)
        } else {
            UIAlertView( title: "Facebook Sharing Unavailable", message: "Sign in to facebook in the Settings app on your phone to share on facebook from Stylpic!", delegate: nil, cancelButtonTitle: "Ok").show()
            
        }
    }
    
    func imageByCombiningImage( firstImage:UIImage, secondImage:UIImage) -> UIImage? {
        var image:UIImage?;
        var width = firstImage.size.width + secondImage.size.width
        var height = firstImage.size.height > secondImage.size.height ? firstImage.size.height : secondImage.size.height
        var newImageSize:CGSize = CGSizeMake(width, height)
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.mainScreen().scale)
        firstImage.drawAtPoint(CGPointMake(0,0))
        secondImage.drawAtPoint(CGPointMake(firstImage.size.width, 0))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.captionTextfield.resignFirstResponder()
    }
}
