//
//  AppDelegate.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("RZ1gWX7CNCMhuLFzclDRKknvZIqoSu2tUnI6cmAF", clientKey: "GrzuVuRsMePNfdGF0AhyBYvEmjgeHPWfwtTb7EHx")

        PFFacebookUtils.initializeFacebook()
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        
        // Simple way to create a user or log in the existing user
        // For your app, you will probably want to present your own login screen
        
//        var currentUser = PFUser.currentUser()
//        if(currentUser == nil)
//        {
//            var user = PFUser()
//            user.username = "Neil"
//            user.password = "password"
//            user.email = "neilb@email.arizona.edu"
//            
//            user.signUpInBackgroundWithBlock({ (succeeded, error) -> Void in
//                if(error != nil)
//                {
//                    PFUser.logInWithUsername("Neil", password: "password")
//                }
//            })
//        }
        

        
        //Facebook stuff
        
//        var permissions = ["user_friends", "email"]
//        
//        PFFacebookUtils.logInWithPermissions(permissions, {
//            (user: PFUser!, error: NSError!) -> Void in
//            if user == nil {
//                NSLog("Uh oh. The user cancelled the Facebook login.")
//            } else if user.isNew {
//                NSLog("User signed up and logged in through Facebook!")
//            } else {
//                NSLog("User logged in through Facebook!")
//            }
//        })
//        
//    
//        var isLoggedIn = false
//        var storyboardId = isLoggedIn ? "MainIdentifier" : "LoginIdentifier"
//        self.window?.rootViewController = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier(storyboardId) as UIViewController!
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    FBAppEvents.activateApp()
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    }


}

