//
//  SPManager.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

///--------------------------------------
/// @name Blocks
///--------------------------------------
typealias SPFeedItemsResultBlock = ( feedItems: [SPFeedItem]!, error: NSError?) -> Void
typealias SPSaveImagesResultsBlock = (imageOne: PFFile?, imageOneThumbnail: PFFile?, imageTwo: PFFile?, imageTwoThumbnail: PFFile?, error: NSError?) -> Void
typealias SPBoolResultBlock = ( success: Bool, error: NSError? ) -> Void
typealias SPPFObjectArrayResultBlock = ( comments: Array<PFObject>?, error: NSError?) -> Void
typealias SPPFObjectResultsBlock = ( savedObject: PFObject?, error: NSError? ) -> Void
typealias SPProfileInfoResultsBlock = ( profileObject: SPProfileInfo?, error: NSError? ) -> Void


class SPManager: NSObject {
    
    var x = 0
    
    class var sharedInstance: SPManager {
        struct Static {
            static let instance: SPManager = SPManager()
        }
        return Static.instance
    }
    
    //MARK: Items
    func getFeedItems( page: UInt, resultsBlock: SPFeedItemsResultBlock ) {
        var params = [ "page": page ]
        PFCloud.callFunctionInBackground( "getFeedItemsForPage2", withParameters: params) { (payload:AnyObject!, error:NSError!) -> Void in
            if error == nil {
                var payloadObject = payload as! Dictionary<String, Array<Dictionary<String, AnyObject>>>
                println( payloadObject )
                
                var serverFeedItems: Array = payloadObject[ "feedItems" ]!
                var feedItems = Array<SPFeedItem>()
                for aServerFeedItem in serverFeedItems {                    
                    var feedItem = SPFeedItem()
                    feedItem.setupWithServerFeedItem( aServerFeedItem )
                    feedItems.append( feedItem )
                }
                
                resultsBlock(feedItems:feedItems, error: nil)
            }
        
        }
        
    }
    
    func getExploreItems( resultsBlock: SPFeedItemsResultBlock ) {
        let params = [NSObject : AnyObject]();
        PFCloud.callFunctionInBackground( "fetchExploreInfo", withParameters: params) { (payload:AnyObject!, error:NSError!) -> Void in
            if error == nil {
                var payloadObject = payload as! Dictionary<String, Array<Dictionary<String, AnyObject>>>
                println( payloadObject )
                
                var serverFeedItems: Array = payloadObject[ "feedItems" ]!
                var feedItems = Array<SPFeedItem>()
                for aServerFeedItem in serverFeedItems {
                    var feedItem = SPFeedItem()
                    feedItem.setupWithServerFeedItem( aServerFeedItem )
                    feedItems.append( feedItem )
                }
                
                resultsBlock(feedItems:feedItems, error: nil)
            }
            
        }
    }
    
    func getProfileInfo( user: PFUser?, resultBlock:(SPProfileInfoResultsBlock) ) {
        if let user = user {
            var params = [ "userObjectId": user.objectId ]
            PFCloud.callFunctionInBackground( "fetchProfileInfo", withParameters: params) { (payload, error) -> Void in
                if error == nil {
                    println( payload )
                    //println( payload as! SPProfileInfo)
                    var serverProfileInfo = payload[ "profileInfo" ] as! [String: AnyObject]
                    var profileInfo = SPProfileInfo()
                    profileInfo.setupWithServerInfo( serverProfileInfo )
                    resultBlock(profileObject: profileInfo, error: nil )
                    
                } else {
                    println( error )
                    resultBlock( profileObject: nil, error: error)
                }
                
                
            }
        } else {
            println( "user was nil" )
            var userInfo = [ "message": "follow did not happen because user was nil" ]
            var error = NSError( domain: "SP", code: -10000, userInfo: userInfo)
            resultBlock( profileObject: nil, error:error )
        }
        
    }
    
    func getMyClosetItems() -> [SPFeedItem] {
        return [SPFeedItem()]
    }

    
    func fetchComments(photoPair: PFObject, imageTapped: ActivityType, resultBlock: SPPFObjectArrayResultBlock) {

        var commentQuery = PFQuery( className: "Activity" )
        commentQuery.whereKey( "type", equalTo: imageTapped.rawValue )
        commentQuery.whereKey( "photoPair", equalTo: photoPair )
        commentQuery.orderByDescending( "createdAt" )
        commentQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                println( objects )
                var arrayPFObject = objects as! Array<SPActivity>
                resultBlock(comments: arrayPFObject, error: nil)
            } else {
                println( error )
            }
        }
    }
    
    func postComment( activityType: ActivityType, photoPair:PFObject?,  comment: String?, resultBlock: SPPFObjectResultsBlock) {
        if let photoPair = photoPair {
            var photosOwner = photoPair.objectForKey( "user" ) as! SPUser
            var fromUser = SPUser.currentUser()
            var activity = SPActivity()
            activity.fromUser = fromUser
            activity.toUser = photosOwner
            activity.photoPair = photoPair as! SPPhotoPair
            activity.notificationViewed = false
            activity.isArchiveReady = false
            activity.type = activityType.rawValue
            activity.content = comment
            activity.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    println( "saved comment activity" )
                    resultBlock( savedObject: activity, error: error )
                } else {
                    println( error )
                }
            })
        }
        
        
    }

    func likePhoto( activityType: ActivityType, photoPair: PFObject?, resultBlock: SPBoolResultBlock ) {
        if let photoPair = photoPair {
            var photosOwner = photoPair.objectForKey( "user" ) as! SPUser
            var fromUser = SPUser.currentUser()
            var activity = SPActivity()
            activity.fromUser = fromUser
            activity.toUser = photosOwner
            activity.photoPair = photoPair as! SPPhotoPair
            activity.isArchiveReady = false
            activity.notificationViewed = false
            activity.type = activityType.rawValue
            activity.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    resultBlock(success: success, error: error)
                } else {
                    println( error )
                }
            }
        } else {
            var userInfo = [ "message": "could not save photo because photopair did not exist" ]
            var error = NSError( domain: "SP", code: -10000, userInfo: userInfo)
            resultBlock( success: false, error: error )
        }
        
    }
    
    
    func followUser(user: SPUser?, resultBlock: SPPFObjectResultsBlock ) {
        if let user = user {
            var fromUser = SPUser.currentUser()
            var activity = SPActivity()
            activity.fromUser = fromUser
            activity.toUser = user
            activity.isArchiveReady = false
            activity.notificationViewed = false
            activity.type = ActivityType.Follow.rawValue
            activity.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    println( "saved follow ativity" )
                    resultBlock( savedObject: activity, error: error )
                } else {
                    println( error )
                    resultBlock( savedObject: nil, error: error )
                }
            })
        } else {
            println( "user was nil" )
            var userInfo = [ "message": "follow did not happen because user was nil" ]
            var error = NSError( domain: "SP", code: -10000, userInfo: userInfo)
            resultBlock( savedObject: nil, error: error )
        }
    }

    
    func unfollowUser( user: PFUser?, resultBlock:PFBooleanResultBlock ) {
        if let user = user {
            var fromUser = SPUser.currentUser()
            var activityQuery = PFQuery( className: "Activity" )
            activityQuery.whereKey( "fromUser", equalTo: fromUser )
            activityQuery.whereKey( "toUser", equalTo: user )
            activityQuery.whereKey( "type", equalTo: ActivityType.Follow.rawValue )
            activityQuery.findObjectsInBackgroundWithBlock({ (payloadObjects, error) -> Void in
                for activity in payloadObjects as! [PFObject] {
                    activity.setObject( true, forKey: "isArchiveReady" )
                }
                
                PFObject.saveAllInBackground(payloadObjects, block: resultBlock)
            })
        } else {
            println( "user was nil" )
            var userInfo = [ "message": "follow did not happen because user was nil" ]
            var error = NSError( domain: "SP", code: -10000, userInfo: userInfo)
            resultBlock( false, error )
        }
    }
    
    
    //Low priority
    func getFacebookFriendsWithApp() -> [SPUser]?{
        return nil
    }
    
    
    func searchForUserByUsername(query : String) -> [SPUser]{
        return [SPUser()]
    }

    func getProfileInfoOfUser(user : SPUser) -> SPProfileInfo {
        return SPProfileInfo()
    }
    
    func postPhotosToFeed(photos : SPPhotoPair, block: PFBooleanResultBlock ) {
        photos.saveInBackgroundWithBlock { (success, error) -> Void in
            block( success, error )
        }
    }
    
    func postPhotoToCloset(photos : SPPhotoPair) {
        
    }
    
    func getFollowersOfUser(user: SPUser) -> [SPUser]{
        return [SPUser()]
    }
    
    func getFollowingOfUser(user: SPUser) -> [SPUser]{
        return [SPUser()]
    }
    
    
    func getNotifications(){
    }
    
    
//   returns 4 PFFiles for the images. an image and thumbnail for each image param
    func saveImages( imageOne: UIImage?, imageTwo: UIImage?, resultsBlock: SPSaveImagesResultsBlock ) {
        if let imageOne = imageOne, imageTwo = imageTwo {
            var isImageOneSaved = false
            var isImageTwoSaved = false
            var imageData = UIImageJPEGRepresentation(imageOne, 0.05)
            var imageFile = PFFile(name: "Image.jpg", data: imageData)
            var imageDataTwo = UIImageJPEGRepresentation(imageTwo, 0.05)
            var imageFileTwo = PFFile(name: "Image.jpg", data: imageDataTwo)
            imageFile.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                if error == nil {
                    isImageOneSaved = true
                    if isImageTwoSaved {
                        resultsBlock(imageOne: imageFile, imageOneThumbnail: imageFile, imageTwo: imageFileTwo, imageTwoThumbnail: imageFileTwo, error: nil )
                    }
                } else {
                    resultsBlock(imageOne: nil, imageOneThumbnail: nil, imageTwo: nil, imageTwoThumbnail: nil, error: error )
                }
            }

            
            imageFileTwo.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                if error == nil {
                    isImageTwoSaved = true
                    if isImageOneSaved {
                        resultsBlock(imageOne: imageFile, imageOneThumbnail: imageFile, imageTwo: imageFileTwo, imageTwoThumbnail: imageFileTwo, error: nil )
                    }
                } else {
                    resultsBlock(imageOne: nil, imageOneThumbnail: nil, imageTwo: nil, imageTwoThumbnail: nil, error: error )
                }
            }
        } else {
            var errorMessage = "ERROR: one or the other image is nil passed to saveImages so can't save images"
            println( errorMessage )
            resultsBlock(imageOne: nil, imageOneThumbnail: nil, imageTwo: nil, imageTwoThumbnail: nil, error: NSError(domain:"com.stylpic", code: -1001, userInfo:[ "error": errorMessage ] )  )
        }
    }
    
    func loginWithFacebook(completionHander : SPBoolResultBlock){
        let permissions = ["public_profile", "user_friends", "email"]
        PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) -> Void in
            if(user == nil){
                if(error == nil){
                    completionHander(success: false, error: nil) //User cancelled facebook login
                }
                else{
                    completionHander(success: false, error: error) //User cancelled facebook login
                    
//                    var av2 = UIAlertView(title: "Error", message: "An Error occurred: \(error.localizedDescription)", delegate: self, cancelButtonTitle: "OK")
//                    av2.show()
                }
            }
            else{
                self.loadFBDataForUser(user)
                completionHander(success: true, error: nil)
            }
        })
    }
    
    func loadFBDataForUser(user: PFUser){
        var request = FBRequest.requestForMe()
        request.startWithCompletionHandler { (connection, result, error) -> Void in
            //TODO: Need to test this facebook user invalidation testing out.
            if let error = error{
                if let userInfo = error.userInfo{
                    if let cError = userInfo["error"] as? NSDictionary{
                        if let type = cError["type"] as? String{
                            if type == "OAuthException"{
                                println("FB Session was invalidated.")
                                //self.logoutButtonTouchUpInside(nil)
                            }
                        }
                    }
                }
            }
            else
            {
                var userData = result as! NSDictionary
                var facebookID = userData["id"] as! String
                user.setObject(userData["first_name"], forKey: "firstName")
                user.setObject(userData["last_name"], forKey: "lastName")
                var pictureURL = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1")
                var request = NSURLRequest(URL: pictureURL!)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, connectionError) -> Void in
                    if (connectionError == nil && data != nil) {
                        var profilePicture = PFFile(name: "ProfilePicture", data: data)
                        user.setObject(profilePicture, forKey: "profilePicture")
                        user.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if(error != nil){
                                println(error)
                            }
                        })
                    }
                })
            }
        }
    }

    
    
    
}
