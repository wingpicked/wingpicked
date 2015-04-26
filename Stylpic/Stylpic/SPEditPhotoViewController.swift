//
//  SPEditPhotoViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/12/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Social

class SPEditPhotoViewController: UIViewController, UITextFieldDelegate {

    var image : UIImage!
    var imageTwo : UIImage!
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    
    @IBOutlet weak var captionTextfield: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewOne.image = self.image
        self.imageViewTwo.image = self.imageTwo

        let fbSharePhotoButton = FBSDKShareButton(frame: CGRectMake(37, 315, 247, 46)) //TODO: Autolayout this frame
        let fbPhoto1 = FBSDKSharePhoto(image: self.image, userGenerated: true)
        let fbPhoto2 = FBSDKSharePhoto(image: self.imageTwo, userGenerated: true)
        let fbContent = FBSDKSharePhotoContent()
        fbContent.photos = [fbPhoto1, fbPhoto2]

        fbSharePhotoButton.shareContent = fbContent;
        self.view.addSubview(fbSharePhotoButton)
    }
    
    @IBAction func shareImages(sender: AnyObject) {
        SPManager.sharedInstance.saveAndPostImages(self.image, imageTwo: imageTwo, caption: self.captionTextfield.text) { (success, error) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.captionTextfield.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
