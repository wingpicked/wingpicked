//
//  SPCameraViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Parse

class SPCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var cameraUI = UIImagePickerController()//: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //        var testObject = PFObject(className: "TestObject")
        //        testObject["foo"] = "bar"
        //        testObject.saveInBackgroundWithBlock(nil)

        cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        cameraUI.delegate = self
        
        var loginView = FBLoginView()
        loginView.center = self.view.center;
        self.view.addSubview(loginView)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButton(sender: AnyObject) {
        self.presentViewController(cameraUI, animated: true, completion:nil)

    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
            println("Selected Image")
            self.dismissViewControllerAnimated(true, completion: nil)
        
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

//        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//        // Hide old HUD, show completed HUD (see example for code)
//        
//            // Create a PFObject around a PFFile and associate it with the current user
//            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
//            [userPhoto setObject:imageFile forKey:@"imageFile"];
//            
//            // Set the access control list to current user for security purposes
//            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
//            
//            PFUser *user = [PFUser currentUser];
//            [userPhoto setObject:user forKey:@"user"];
//            
//            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (!error) {
//            [self refresh:nil];
//            }
//            else{
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//            }
//            }];
//        }
//        else{
//        [HUD hide:YES];
//        // Log details of the failure
//        NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//        } progressBlock:^(int percentDone) {
//        // Update your progress spinner here. percentDone will be between 0 and 100.
//        HUD.progress = (float)percentDone/100;
//        }];
        
    
    }

   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
