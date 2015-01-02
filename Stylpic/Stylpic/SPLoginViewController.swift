//
//  SPLoginViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/2/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPLoginViewController: UIViewController {

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookLoginTouchUpInside(sender: AnyObject) {
        
                var permissions = ["public_profile, user_friends", "email"]
        PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) -> Void in
            if(user == nil){
                if(error == nil){
                    println("User cancelled facebook login")
                }
                else{
                    println("An error occured: \(error)")
                }
            }
            else{
                println("User Logged in!")
                self.performSegueWithIdentifier("loggedInSegue", sender: self)
            }
            
        })
    }

    
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
