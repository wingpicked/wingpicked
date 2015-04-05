//
//  SPEditPhotoViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/12/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPEditPhotoViewController: UIViewController {

    var image : UIImage!
    var imageTwo : UIImage!
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    
    @IBOutlet weak var captionTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewOne.image = self.image
        self.imageViewTwo.image = self.imageTwo
        // Do any additional setup after loading the view.
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.captionTextfield.resignFirstResponder()
    }
}
