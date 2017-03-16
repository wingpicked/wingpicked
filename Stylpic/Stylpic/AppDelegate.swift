//
//  AppDelegate.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//TODO: Useful Optimization http://stackoverflow.com/questions/20988960/a-long-running-parse-operation-is-being-executed-on-the-main-thread
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//        Parse.enableLocalDatastore()
        
        // Initialize Parse.
let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
    ParseMutableClientConfiguration.applicationId = "RZ1gWX7CNCMhuLFzclDRKknvZIqoSu2tUnI6cmAF"
    ParseMutableClientConfiguration.clientKey = "GrzuVuRsMePNfdGF0AhyBYvEmjgeHPWfwtTb7EHx"
    ParseMutableClientConfiguration.server = "https://wingpicked.herokuapp.com/parse"

Parse.initializeWithConfiguration(parseConfiguration)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
//        PFFacebookUtils.ini
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
                

        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        UIBarButtonItem.appearance().tintColor = UIColor.blackColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 18.0)!]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLoginScreen", name: "showLoginScreen", object: nil)
        
        if((PFUser.currentUser() != nil && PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!))) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarVC = storyboard.instantiateViewControllerWithIdentifier("MainIdentifier") 
            self.window?.rootViewController = mainTabBarVC
        }
        
        return true
    }
    
    func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarVC = storyboard.instantiateViewControllerWithIdentifier("LoginIdentifier")
        self.window?.rootViewController = mainTabBarVC
    }

    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // do this ih cloud code
//        let query = PFInstallation.query()
//        query!.includeKey("user")
//        query!.whereKey("user", equalTo: PFUser.currentUser()!);
//        query!.findObjectsInBackgroundWithBlock { (installations, error) -> Void in
        let user = PFUser.currentUser()!
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.setObject(user, forKey: "user")
        installation.saveInBackgroundWithBlock { (success, ErrorType) -> Void in
            PFCloud.callFunctionInBackground( "purgeInstallations", withParameters:["userObjectId": user.objectId!], block: { (results, error) -> Void in
                print( results )
            })
        }
//        }
    }
    
    func registerForPushNotifications(){
        let application = UIApplication.sharedApplication()
        _ = !application.respondsToSelector("backgroundRefreshStatus")
        _ = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let notificationType: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
            let settings = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: nil)
        }
    }
    

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

