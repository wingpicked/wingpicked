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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showScreen", name: "showLoginScreen", object: nil)
    }

    override func viewDidAppear(animated: Bool) {
        // Check if user is cached and linked to Facebook, if so, bypass login
        super.viewDidAppear(animated)
//        if((PFUser.currentUser() != nil && PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!))){
//            self.performSegueWithIdentifier("loggedInSegue", sender: self)
//            
//        }
        
    }
        
    @IBAction func facebookLoginTouchUpInside(sender: AnyObject) {
        SPManager.sharedInstance.loginWithFacebook { (success, error) -> Void in
            if(error == nil && success == true) {
                self.performSegueWithIdentifier("loggedInSegue", sender: self)
                
                (UIApplication.sharedApplication().delegate as! AppDelegate).registerForPushNotifications()
            }
            else if (error == nil && success == false){
                let cancelMessage = "Aw, facebook login with facebook was cancelled."
                let av = UIAlertView(title: "Login Failed", message: cancelMessage, delegate: self, cancelButtonTitle: "OK")
                av.show()
            }
            else {
                print("Login Failed: \(error?.localizedDescription)")
                let av = UIAlertView(title: "Login Failed", message: "Sorry, something went wrong when trying to connect with Facebook.  Please try again later.", delegate: self, cancelButtonTitle: "OK")
                av.show()
            }
        }
    }
    
    func showScreen() {
            self.dismissViewControllerAnimated(true, completion: nil)
//        self.navigationController?.popToViewController(self, animated: true)
    }

}
