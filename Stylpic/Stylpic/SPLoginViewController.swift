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
                
                (UIApplication.sharedApplication().delegate as! AppDelegate).registerForPushNotifications()
            }
            else if (error == nil && success == false){
                let cancelMessage = "Aw, facebook login with facebook was cancelled."
                var av = UIAlertView(title: "Login Failed", message: cancelMessage, delegate: self, cancelButtonTitle: "OK")
                av.show()
            }
            else {
                println("Login Failed: \(error?.localizedDescription)")
                var av = UIAlertView(title: "Login Failed", message: "Sorry, something went wrong when trying to connect with Facebook.  Please try again later.", delegate: self, cancelButtonTitle: "OK")
                av.show()
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "loggedInSegue"){
            println("Logged In!")
        }
    }
    

}
