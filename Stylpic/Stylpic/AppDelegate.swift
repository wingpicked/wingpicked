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
        
//        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("RZ1gWX7CNCMhuLFzclDRKknvZIqoSu2tUnI6cmAF", clientKey: "GrzuVuRsMePNfdGF0AhyBYvEmjgeHPWfwtTb7EHx")

        PFFacebookUtils.initializeFacebook()
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
                

        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        UIBarButtonItem.appearance().tintColor = UIColor.blackColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 18.0)!]
        
        if((PFUser.currentUser() != nil && PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!))) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarVC = storyboard.instantiateViewControllerWithIdentifier("MainIdentifier") as! UIViewController
            self.window?.rootViewController = mainTabBarVC
        }
        
        return true
    }

    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.setObject(PFUser.currentUser()!, forKey: "user")
        installation.saveInBackgroundWithBlock(nil)
    }
    
    func registerForPushNotifications(){
        let application = UIApplication.sharedApplication()
        let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
        let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
        var noPushPayload = false;
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let notificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
//    func registerForPushNotifications(application: UIApplication, launchOptions : [NSObject: AnyObject]?){
//        // Register for Push Notitications
//
//        // Track an app open here if we launch with a push, unless
//        // "content_available" was used to trigger a background push (introduced in iOS 7).
//        // In that case, we skip tracking here to avoid double counting the app-open.
//        
//        let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
//        let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
//        var noPushPayload = false;
//        if let options = launchOptions {
//            noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
//        }
//        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
//            PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
//        }
//        
//        
//        if application.respondsToSelector("registerUserNotificationSettings:") {
//            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
//            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
//            application.registerUserNotificationSettings(settings)
//            application.registerForRemoteNotifications()
//        } else {
//            let notificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
//            let settings = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: nil)
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBAppEvents.activateApp()
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    }
}

