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
typealias SPPFObjectArrayResultBlock = ( comments: Array<SPActivity>?, error: NSError?) -> Void
typealias SPPFObjectResultsBlock = ( savedObject: SPActivity?, error: NSError? ) -> Void
typealias SPProfileInfoResultsBlock = ( profileObject: SPProfileInfo?, error: NSError? ) -> Void
typealias SPPFFilesResultBlock = ( pfFiles: [PFFile]?, error: NSError? ) -> Void
typealias SPClosetPhotosResultBlock = ( closetPhotos: [SPClosetPhoto]?, error: NSError? ) -> Void
typealias SPActivityResultBlock = ( activities: [SPActivity]?, error: NSError? ) -> Void
typealias SPUsersResultBlock = ( users: [SPUser]?, error: NSError? ) -> Void
typealias SPFileResultBlock = ( file: PFFile?, error: NSError? ) -> Void

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
        PFCloud.callFunctionInBackground( "getFeedItemsForPageV3", withParameters: params) { (payload:AnyObject!, error:NSError!) -> Void in
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
    
    func getMyClosetItemsWithResultBlock( resultBlock:SPClosetPhotosResultBlock ) {
        var usersPhotosQuery = PFQuery( className: "ClosetPhoto" )
        usersPhotosQuery.includeKey( "user" )
        usersPhotosQuery.includeKey( "photo" )
        usersPhotosQuery.whereKey("user", equalTo: PFUser.currentUser() )
        usersPhotosQuery.whereKey("isVisible", equalTo: true )
        usersPhotosQuery.limit = 1000;
        usersPhotosQuery.orderByDescending("updatedAt")
        usersPhotosQuery.findObjectsInBackgroundWithBlock { (someClosetPhotos, anError) -> Void in
            if anError == nil && someClosetPhotos != nil {
                var spClosetPhotos = someClosetPhotos as! [SPClosetPhoto]
                resultBlock( closetPhotos: spClosetPhotos, error: nil )
            } else {
                resultBlock( closetPhotos: nil, error: anError )
            }
        }
        
    }

    
    func addMyClosetItemWithImage( image:UIImage, resultBlock: PFBooleanResultBlock ) {
        var imageData = UIImageJPEGRepresentation(image, 0.05)
        var imageFile = PFFile(name: "Image.jpg", data: imageData)
        imageFile.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                var photoOne = SPPhoto()
                photoOne.photo = imageFile
                photoOne.photoThumbnail = imageFile
                photoOne.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if error == nil {
                        var closetPhotoOne = SPClosetPhoto()
                        closetPhotoOne.isVisible = true
                        closetPhotoOne.user = SPUser.currentUser()
                        closetPhotoOne.photo = photoOne
                        closetPhotoOne.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if error == nil {
                                resultBlock( true, nil )
                            }
                        })
                    }
                })
            }
        }    
        
    }
    
    
    func fetchComments(photoPair: PFObject, imageTapped: ActivityType, resultBlock: SPPFObjectArrayResultBlock) {

        var commentQuery = PFQuery( className: "Activity" )
        commentQuery.whereKey( "type", equalTo: imageTapped.rawValue )
        commentQuery.whereKey( "photoPair", equalTo: photoPair )
        commentQuery.whereKey( "isArchiveReady", equalTo: false )
        commentQuery.limit = 1000;
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
                    NSNotificationCenter.defaultCenter().postNotificationName("RefreshViewControllers", object: nil)
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
                    NSNotificationCenter.defaultCenter().postNotificationName("RefreshViewControllers", object: nil)
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
                    NSNotificationCenter.defaultCenter().postNotificationName("RefreshViewControllers", object: nil)
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
            activityQuery.whereKey( "isArchiveReady", equalTo: false )
            activityQuery.findObjectsInBackgroundWithBlock({ (payloadObjects, error) -> Void in
                for activity in payloadObjects as! [PFObject] {
                    activity.setObject( true, forKey: "isArchiveReady" )
                }
                
                PFObject.saveAllInBackground(payloadObjects, block: { (success, errro) -> Void in
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("RefreshViewControllers", object: nil)
                    resultBlock( success, error )
                })
            })
        } else {
            println( "user was nil" )
            var userInfo = [ "message": "follow did not happen because user was nil" ]
            var error = NSError( domain: "SP", code: -10000, userInfo: userInfo)
            resultBlock( false, error )
        }
    }
    
    func removeClosetPhoto( closetPhoto:SPClosetPhoto ) {
        closetPhoto.isVisible = NSNumber( bool: false )
        closetPhoto.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                println( "removed closet photo" )
            } else {
                println( error )
            }
        }
    }
    
    func removePostWithPhotoPairObjectId( photoPairObjectId: String ) {
        var params = [ "photoPairObjectId": photoPairObjectId ]
        PFCloud.callFunctionInBackground( "removeFeedItem", withParameters: params) { (payload, error) -> Void in
            if error == nil {
                println( payload )
            } else {
                println( error )
            }
        }
    }
    
    func getPhotoPairLikes( photoPairObjectId:String, likesPhotoIdentifier:ActivityType, resultBlock:SPActivityResultBlock ) {
        var params = [ "photoPairObjectId": photoPairObjectId, "likesPhotoIdentifier": NSNumber(unsignedInteger:likesPhotoIdentifier.rawValue) ]
        PFCloud.callFunctionInBackground("photoPairLikes", withParameters: params) { (payload, error) -> Void in
            if error == nil {
                var likes = payload["likes"] as! [SPActivity]
                resultBlock(activities: likes, error: nil)
            } else {
                println( error )
                resultBlock( activities: nil, error: error)
            }
        }
        
        
    }
    
    // parma searchTerms is a string of all the search terms seperated by spaces
    func getUsersWithSearchTerms( searchTerms:String, resultBlock:SPUsersResultBlock ) {
        var seperatedSearchTerms = searchTerms.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var params = [ "searchTerms": seperatedSearchTerms ]
        PFCloud.callFunctionInBackground("usersWithSearchTerms", withParameters: params) { (users, error) -> Void in
            if error == nil {
                var someUsers = users[ "users" ] as! [SPUser]
                println( someUsers );
                resultBlock( users: someUsers, error: nil )
            } else {
                println( error )
                resultBlock( users: nil, error: error )
            }
        }
        
        
    }
    
    //Low priority
    func getFacebookFriendsWithApp( resultBlock:SPUsersResultBlock  ) {
        var friendsRequest = FBRequest(graphPath: "me/friends", parameters: ["fields":"id,name,installed" ], HTTPMethod: "GET")
        friendsRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error == nil {
                println( result )
                var facebookIds = [String]()
                var friendDatas = result["data"] as! [AnyObject]
                if friendDatas.count > 0 {
                    for friendData in friendDatas {
                        var aFacebookId = friendData["id"] as! String
                        facebookIds.append( aFacebookId )
                    }
                    
                    var userQuery = PFUser.query()
                    userQuery.limit = facebookIds.count
                    userQuery.whereKey("facebookId", containedIn:facebookIds)
                    userQuery.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                        if error == nil {
                            var parseUsers = users as! [SPUser]
                            if parseUsers.count > 0 {
                                var userForFollowingInfo = [String: SPUser]()
                                for spUser in parseUsers {
                                    spUser.isFollowing = NSNumber( bool: false )
                                    userForFollowingInfo[ spUser.objectId ] = spUser
                                }
                                
                                self.followingActivitiesWithCandidateUsers( parseUsers, resultBlock: { (followingActivities, error) -> Void in
                                    if error == nil {
                                        for activity in followingActivities! {
                                            var spActivity = activity
                                            var followingUser = spActivity.toUser
                                            var aFollowingInfo = userForFollowingInfo[ followingUser.objectId ]
                                            aFollowingInfo!.isFollowing = NSNumber(bool: true)
                                        }
                                        
                                        resultBlock( users: parseUsers, error: nil )
                                    } else {
                                        println( error )
                                        resultBlock( users: nil, error: error)
                                    }
                                })
                                
                            } else {
                                // then no results
                                resultBlock( users: [SPUser](), error: nil)
                            }
                        } else {
                            println( error )
                            resultBlock( users: nil, error: error)
                        }
                    })
                } else {
                    resultBlock( users: [SPUser](), error: nil)
                }
                
            } else {
                println( error )
                resultBlock( users: nil, error: error)
            }
        }
        
    }
    
    
    func followingActivitiesWithCandidateUsers( candidateFollowingUsers: [SPUser], resultBlock: SPActivityResultBlock ) {
        var fromUser = SPUser.currentUser()
        var activityQuery = PFQuery( className: "Activity" )
        activityQuery.whereKey( "fromUser", equalTo: fromUser )
        activityQuery.whereKey( "toUser", containedIn: candidateFollowingUsers )
        activityQuery.whereKey( "type", equalTo: ActivityType.Follow.rawValue )
        activityQuery.whereKey( "isArchiveReady", equalTo: false )
        activityQuery.findObjectsInBackgroundWithBlock { (activities, error) -> Void in
            if error == nil {
                var foundActivities = activities as! [SPActivity]
                resultBlock( activities: foundActivities, error: error )
            } else {
                println( error )
                resultBlock( activities: nil, error: error )
            }
        }
        
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
    
    
    func finishPostingWithFileOne( fileOne:PFFile, fileTwo:PFFile, caption: String, resultsBlock:PFBooleanResultBlock ) {
        var photoOne = SPPhoto()
        photoOne.photo = fileOne
        photoOne.photoThumbnail = fileOne
        
        var photoTwo = SPPhoto()
        photoTwo.photo = fileTwo
        photoTwo.photoThumbnail = fileTwo

        
        var pfObjects = [photoOne, photoTwo]
        PFObject.saveAllInBackground(pfObjects, block: { (success, error) -> Void in
            if error == nil {
                
                var photoPair = SPPhotoPair()
                photoPair.photoOne = photoOne
                photoPair.photoTwo = photoTwo
                photoPair.caption = caption
                photoPair.user = SPUser.currentUser()
                photoPair.isArchiveReady = false
                
                var closetPhotoOne = SPClosetPhoto()
                closetPhotoOne.isVisible = true
                closetPhotoOne.user = SPUser.currentUser()
                closetPhotoOne.photo = photoOne                
                
                var closetPhotoTwo = SPClosetPhoto()
                closetPhotoTwo.isVisible = true
                closetPhotoTwo.user = SPUser.currentUser()
                closetPhotoTwo.photo = photoTwo
                
                var morePFObjects = [ photoPair, closetPhotoOne, closetPhotoTwo ]
                PFObject.saveAllInBackground(morePFObjects, block: { (success, error) -> Void in
                    resultsBlock( success, error )
                })
            } else {
                println( error )
            }
        })

    }
    
    

    func saveAndPostImages( imageOne: UIImage?, imageTwo: UIImage?, caption: String, resultsBlock: PFBooleanResultBlock ) {
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
                        
                        self.finishPostingWithFileOne(imageFile, fileTwo: imageFileTwo, caption: caption, resultsBlock: { (success, error) -> Void in
                            resultsBlock( success, error );
                        })
                    }
                } else {
                    println( error )
                }
            }

            
            imageFileTwo.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                if error == nil {
                    isImageTwoSaved = true
                    if isImageOneSaved {
                        self.finishPostingWithFileOne(imageFile, fileTwo: imageFileTwo, caption: caption, resultsBlock: { (success, error) -> Void in
                            resultsBlock( success, error );
                        })
                    }
                } else {
                    println( error )
                }
            }
        } else {
            var errorMessage = "ERROR: one or the other image is nil passed to saveImages so can't save images"
            println( errorMessage )
            resultsBlock( false, NSError(domain:"com.stylpic", code: -1001, userInfo:[ "error": errorMessage ] ) )
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
                user.setObject(facebookID, forKey: "facebookId")
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
