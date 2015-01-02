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
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //        var testObject = PFObject(className: "TestObject")
        //        testObject["foo"] = "bar"
        //        testObject.saveInBackgroundWithBlock(nil)

        cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        cameraUI.delegate = self
        
        loadFBData()
        
        
//        var loginView = FBLoginView()
//        loginView.center = self.view.center;
//        self.view.addSubview(loginView)
        
    }

    func loadFBData(){
        var request = FBRequest.requestForMe()
        request.startWithCompletionHandler { (connection, result, error) -> Void in
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButton(sender: AnyObject) {
        self.presentViewController(cameraUI, animated: true, completion:nil)

    }
    

    @IBAction func logoutButtonTouchUpInside(sender: AnyObject) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
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
