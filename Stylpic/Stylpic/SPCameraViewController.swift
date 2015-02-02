//
//  SPCameraViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Parse

class SPCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate{

    //var cameraUI = UIImagePickerController()//: UIImagePickerController!
    var navController = UINavigationController()
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFBData()
    }
    

    

    @IBAction func logoutButtonTouchUpInside(sender: AnyObject) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    

    
    
    
    
    
    func loadFBData(){
        var request = FBRequest.requestForMe()
        request.startWithCompletionHandler { (connection, result, error) -> Void in
            //TODO: Need to test this facebook user invalidation testing out.
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

    
}
