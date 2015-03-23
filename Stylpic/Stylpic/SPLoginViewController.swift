//
//  SPLoginViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/2/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPLoginViewController: UIViewController, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        // Check if user is cached and linked to Facebook, if so, bypass login
        
        
        if((PFUser.currentUser() != nil && PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()))){
            self.performSegueWithIdentifier("loggedInSegue", sender: self)
            
        }
    }
        
    @IBAction func facebookLoginTouchUpInside(sender: AnyObject) {

        
        SPManager.sharedInstance.loginWithFacebook { (success, error) -> Void in
            if(error == nil && success == true) {                
                self.performSegueWithIdentifier("loggedInSegue", sender: self)
            }
            else {
                println("Login Failed")
                var av = UIAlertView(title: "Login Failed", message: "Sorry, something went wrong when trying to connect with Facebook.  Please try again later.", delegate: self, cancelButtonTitle: "OK")
                av.show()
            }
        }
//                var permissions = ["public_profile", "user_friends", "email"]
//        PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) -> Void in
//            if(user == nil){
//                if(error == nil){
//                    println("User cancelled facebook login")
//                }
//                else{
//                    println("An error occured: \(error)")
//                    
//                    var av2 = UIAlertView(title: "Error", message: "An Error occurred: \(error.localizedDescription)", delegate: self, cancelButtonTitle: "OK")
//                    av2.show()
//                    
//                }
//            }
//            else{
//                println("User Logged in!")
//                
//                self.loadFBData(user as PFUser)
//                
////                var pfuser = PFUser()
////                pfuser.setObject(firstName, forKey: "firstName")
////                pfuser.setObject(lastName, forKey: "firstName")
//                //self.loadFBData()
//                
//                self.performSegueWithIdentifier("loggedInSegue", sender: self)
//                
//                
//                
//            
//            }
//            
//        })
    }

    
//    func loadFBData(user: PFUser){
//        var request = FBRequest.requestForMe()
//        request.startWithCompletionHandler { (connection, result, error) -> Void in
//            //TODO: Need to test this facebook user invalidation testing out.
//            if let cError = error{
//                if let cUserInfo = cError.userInfo{
//                    if let cError = cUserInfo["error"] as? NSDictionary{
//                        if let cType = cError["type"] as? String{
//                            if cType == "OAuthException"{
//                                println("FB Session was invalidated.")
//                                //self.logoutButtonTouchUpInside(nil)
//                            }
//                        }
//                    }
//                }
//            }
//            else
//            {
//                var userData = result as! NSDictionary
//                var facebookID = userData["id"] as! String;
//                user.setObject(userData["first_name"], forKey: "firstName")
//                user.setObject(userData["last_name"], forKey: "lastName")
//                var pictureURL = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1")
//                var request = NSURLRequest(URL: pictureURL!)
//                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, connectionError) -> Void in
//                    if (connectionError == nil && data != nil) {
//                        var profilePicture = PFFile(name: "ProfilePicture", data: data)
//                        user.setObject(profilePicture, forKey: "profilePicture")
//                        user.saveInBackgroundWithBlock({ (success, error) -> Void in
//                            if(error != nil){
//                                println(error)
//                            }
//                        })
//                    }
//                })
//            }
//        }
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "loggedInSegue"){
            println("Logged In!")
        }
    }
    

}
