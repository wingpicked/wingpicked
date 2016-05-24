//
//  SPManager.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

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
        let params = [ "page": page ]
        PFCloud.callFunctionInBackground( "getFeedItemsForPageV3", withParameters: params) { (payload, error) -> Void in
            if error == nil {
                var payloadObject = payload as! Dictionary<String, Array<Dictionary<String, AnyObject>>>
                let serverFeedItems: Array = payloadObject[ "feedItems" ]!
                var feedItems = Array<SPFeedItem>()
                for aServerFeedItem in serverFeedItems {                    
                    let feedItem = SPFeedItem()
                    feedItem.setupWithServerFeedItem( aServerFeedItem )
                    feedItems.append( feedItem )
                }
                
                resultsBlock(feedItems:feedItems, error: nil)
            }
        
        }
        
    }
    
    func getExploreItems( resultsBlock: SPFeedItemsResultBlock ) {
        let params = [NSObject : AnyObject]();
        PFCloud.callFunctionInBackground( "fetchExploreInfo", withParameters: params) { (payload:AnyObject?, error:NSError?) -> Void in
            if error == nil {
                var payloadObject = payload as! Dictionary<String, Array<Dictionary<String, AnyObject>>>
                let serverFeedItems: Array = payloadObject[ "feedItems" ]!
                var feedItems = Array<SPFeedItem>()
                for aServerFeedItem in serverFeedItems {
                    let feedItem = SPFeedItem()
                    feedItem.setupWithServerFeedItem( aServerFeedItem )
                    feedItems.append( feedItem )
                }
                
                resultsBlock(feedItems:feedItems, error: nil)
            }
        }
    }
    
    func getProfileInfo( user: PFUser?, resultBlock:(SPProfileInfoResultsBlock) ) {

        if let user = user {
            let params = [ "userObjectId": user.objectId! ]
//            MRProgressOverlayView.showOverlayAddedTo(UIApplication.sharedApplication().delegate?.window!, animated: true)
            
            
            PFCloud.callFunctionInBackground( "fetchProfileInfo", withParameters: params) { (payload, error) -> Void in
                if error == nil {
                    let serverProfileInfo = (payload as! [String: AnyObject])["profileInfo"] as! NSDictionary
//                    let serverProfileInfo = payload![ "profileInfo" ] as! [String: AnyObject]
                    let profileInfo = SPProfileInfo()
                    profileInfo.setupWithServerInfo(serverProfileInfo)
                    resultBlock(profileObject: profileInfo, error: nil )
                    
                } else {
                    print( error )
                    resultBlock( profileObject: nil, error: error)
                }
//                MRProgressOverlayView.dismissOverlayForView(UIApplication.sharedApplication().delegate?.window!, animated: true)
                
                
            }
        } else {
            let userInfo = [ "message": "follow did not happen because user was nil" ]
            let error = NSError( domain: "SP", code: -10000, userInfo: userInfo)
            resultBlock( profileObject: nil, error:error )
        }
        
    }
    
    func getMyClosetItemsWithResultBlock( resultBlock:SPClosetPhotosResultBlock ) {
//        self.displayLoadingIndicator(true)
        let usersPhotosQuery = PFQuery( className: "ClosetPhoto" )
        //usersPhotosQuery.cachePolicy = kPFCachePolicyCacheThenNetwork
        usersPhotosQuery.includeKey( "user" )
        usersPhotosQuery.includeKey( "photo" )
        usersPhotosQuery.whereKey("user", equalTo: PFUser.currentUser()! )
        usersPhotosQuery.whereKey("isVisible", equalTo: true )
        usersPhotosQuery.limit = 1000;
        usersPhotosQuery.orderByDescending("updatedAt")
        usersPhotosQuery.findObjectsInBackgroundWithBlock { (someClosetPhotos, anError) -> Void in
            if anError == nil && someClosetPhotos != nil {
                let spClosetPhotos = someClosetPhotos as! [SPClosetPhoto]
                resultBlock( closetPhotos: spClosetPhotos, error: nil )
            } else {
                resultBlock( closetPhotos: nil, error: anError )
            }
//            self.displayLoadingIndicator(false)
        }
        
    }

    
    func addMyClosetItemWithImage( image:UIImage, resultBlock: PFBooleanResultBlock ) {
        let imageData = UIImageJPEGRepresentation(image, 0.05)
        let imageFile = PFFile(name: "Image.jpg", data: imageData!)
        imageFile!.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                let photoOne = SPPhoto()
                photoOne.photo = imageFile
                photoOne.photoThumbnail = imageFile
                photoOne.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if error == nil {
                        let closetPhotoOne = SPClosetPhoto()
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

        let commentQuery = PFQuery( className: "Activity" )
        commentQuery.includeKey("fromUser")
        commentQuery.includeKey("photoPair")
        commentQuery.includeKey("photoPair.user")
        commentQuery.includeKey("toUser")
        commentQuery.whereKey( "type", equalTo: imageTapped.rawValue )
        commentQuery.whereKey( "photoPair", equalTo: photoPair )
        commentQuery.whereKey( "isArchiveReady", equalTo: false )
        commentQuery.limit = 1000;
        commentQuery.orderByDescending( "createdAt" )
        
        commentQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                let arrayPFObject = objects as! Array<SPActivity>
                resultBlock(comments: arrayPFObject, error: nil)
            } else {
                print( error )
            }
        }
    }
    
    func postComment( activityType: ActivityType, photoPair:PFObject?,  comment: String?, resultBlock: SPPFObjectResultsBlock) {
        if let photoPair = photoPair {
            let photosOwner = photoPair.objectForKey( "user" ) as! SPUser
            let fromUser = SPUser.currentUser()
            let activity = SPActivity()
            activity.fromUser = fromUser
            activity.toUser = photosOwner
            activity.photoPair = photoPair as! SPPhotoPair
            activity.notificationViewed = false
            activity.isArchiveReady = false
            activity.type = activityType.rawValue
            activity.content = comment
            activity.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    print( "saved comment activity" )
                    resultBlock( savedObject: activity, error: error )
                    NSNotificationCenter.defaultCenter().postNotificationName("RefreshViewControllers", object: nil)
                } else {
                    print( error )
                }
            })
        }
    }

    func likePhoto( activityType: ActivityType, photoPair: PFObject?, resultBlock: SPBoolResultBlock ) {
        if let photoPair = photoPair {
            let photosOwner = photoPair.objectForKey( "user" ) as! SPUser
            let fromUser = SPUser.currentUser()
            let activity = SPActivity()
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
                    print( error )
                }
            }
        } else {
            let userInfo = [ "message": "could not save photo because photopair did not exist" ]
            let error = NSError( domain: "SP", code: -10000, userInfo: userInfo)
            resultBlock( success: false, error: error )
        }
    }
    
    
    func followUser(user: SPUser?, resultBlock: SPPFObjectResultsBlock ) {
        if let user = user {
            let fromUser = SPUser.currentUser()
            let activity = SPActivity()
            activity.fromUser = fromUser
            activity.toUser = user
            activity.isArchiveReady = false
            activity.notificationViewed = false
            activity.type = ActivityType.Follow.rawValue
            activity.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    NSNotificationCenter.defaultCenter().postNotificationName("RefreshViewControllers", object: nil)
                    resultBlock( savedObject: activity, error: error )
                } else {
                    print( error )
                    resultBlock( savedObject: nil, error: error )
                }
            })
        } else {
            let userInfo = [ "message": "follow did not happen because user was nil" ]
            let error = NSError( domain: "SP", code: -10000, userInfo: userInfo)
            resultBlock( savedObject: nil, error: error )
        }
    }

    
    func unfollowUser( user: PFUser?, resultBlock:PFBooleanResultBlock ) {
        if let user = user {
            let fromUser = SPUser.currentUser()
            let activityQuery = PFQuery( className: "Activity" )
            activityQuery.whereKey( "fromUser", equalTo: fromUser! )
            activityQuery.whereKey( "toUser", equalTo: user )
            activityQuery.whereKey( "type", equalTo: ActivityType.Follow.rawValue )
            activityQuery.whereKey( "isArchiveReady", equalTo: false )
            activityQuery.findObjectsInBackgroundWithBlock({ (payloadObjects, error) -> Void in
                for activity in payloadObjects as [PFObject]! {
                    activity.setObject( true, forKey: "isArchiveReady" )
                }
                
                PFObject.saveAllInBackground(payloadObjects, block: { (success, errro) -> Void in
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("RefreshViewControllers", object: nil)
                    resultBlock( success, error )
                })
            })
        } else {
            let userInfo = [ "message": "follow did not happen because user was nil" ]
            let error = NSError( domain: "SP", code: -10000, userInfo: userInfo)
            resultBlock( false, error )
        }
    }
    
    func removeClosetPhoto( closetPhoto:SPClosetPhoto ) {
        closetPhoto.isVisible = NSNumber( bool: false )
        closetPhoto.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
            } else {
                print( error )
            }
        }
    }
    
    func removePostWithPhotoPairObjectId( photoPairObjectId: String, resultBlock: SPBoolResultBlock ) {
        let params = [ "photoPairObjectId": photoPairObjectId ]
        PFCloud.callFunctionInBackground( "removeFeedItem", withParameters: params) { (payload, error) -> Void in
            if error == nil {
                resultBlock(success: true, error: nil)
            } else {
                print( error )
                resultBlock(success: false, error: error)
            }
        }
    }
    
    func getPhotoPairLikes( photoPairObjectId:String, likesPhotoIdentifier:ActivityType, resultBlock:SPActivityResultBlock ) {
        let params = [ "photoPairObjectId": photoPairObjectId, "likesPhotoIdentifier": NSNumber(integer:likesPhotoIdentifier.rawValue) ]
        PFCloud.callFunctionInBackground("photoPairLikes", withParameters: params) { (payload, error) -> Void in
            if error == nil {
                let likes = (payload as! [String: AnyObject])["likes"] as! [SPActivity]
                
//                let likes = payload!["likes"] as! [SPActivity]
                resultBlock(activities: likes, error: nil)
            } else {
                print( error )
                resultBlock( activities: nil, error: error)
            }
        }
        
        
    }
    
    // parma searchTerms is a string of all the search terms seperated by spaces
    func getUsersWithSearchTerms( searchTerms:String, resultBlock:SPUsersResultBlock ) {
        let seperatedSearchTerms = searchTerms.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let params = [ "searchTerms": seperatedSearchTerms ]
        PFCloud.callFunctionInBackground("usersWithSearchTerms", withParameters: params) { (users, error) -> Void in
            if error == nil {
                let someUsers = (users as! [String: AnyObject])["users"] as! [SPUser]
//                let someUsers = users![ "users" ] as! [SPUser]
                resultBlock( users: someUsers, error: nil )
            } else {
                print( error )
                resultBlock( users: nil, error: error )
            }
        }
        
        
    }
    
    //Low priority
    func getFacebookFriendsWithApp( resultBlock:SPUsersResultBlock  ) {
//        let friendsRequest = FBRequest(graphPath: "me/friends", parameters: ["fields":"id,name,installed" ], HTTPMethod: "GET")
        let friendsRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields":"id,name,installed" ])
        let connection = FBSDKGraphRequestConnection()
        connection.addRequest(friendsRequest) { (connection, result, error) -> Void in 
            if error == nil {
                print( result )
                var facebookIds = [String]()
                let friendDatas = (result as! [String: AnyObject])["data"] as! [AnyObject]
//                let friendDatas = result["data"] as! [AnyObject]
                if friendDatas.count > 0 {
                    for friendData in friendDatas {
                        let aFacebookId = (friendData as! [String: AnyObject])["id"] as! String
//                        let aFacebookId = friendData["id"] as! String
                        facebookIds.append( aFacebookId )
                    }
                    
                    let userQuery = PFUser.query()
                    userQuery!.limit = facebookIds.count
                    userQuery!.whereKey("facebookId", containedIn:facebookIds)
                    userQuery!.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                        if error == nil {
                            let parseUsers = users as! [SPUser]
                            if parseUsers.count > 0 {
                                var userForFollowingInfo = [String: SPUser]()
                                for spUser in parseUsers {
                                    spUser.isFollowing = NSNumber( bool: false )
                                    userForFollowingInfo[ spUser.objectId! ] = spUser
                                }
                                
                                self.followingActivitiesWithCandidateUsers( parseUsers, resultBlock: { (followingActivities, error) -> Void in
                                    if error == nil {
                                        for activity in followingActivities! {
                                            let spActivity = activity
                                            let followingUser = spActivity.toUser
                                            let aFollowingInfo = userForFollowingInfo[ followingUser.objectId! ]
                                            aFollowingInfo!.isFollowing = NSNumber(bool: true)
                                        }
                                        
                                        resultBlock( users: parseUsers, error: nil )
                                    } else {
                                        print( error )
                                        resultBlock( users: nil, error: error)
                                    }
                                })
                                
                            } else {
                                // then no results
                                resultBlock( users: [SPUser](), error: nil)
                            }
                        } else {
                            print( error )
                            resultBlock( users: nil, error: error)
                        }
                    })
                } else {
                    resultBlock( users: [SPUser](), error: nil)
                }
                
            } else {
                print( error )
                resultBlock( users: nil, error: error)
            }
        }
        
        connection.start()
    }
    
    
    func followingActivitiesWithCandidateUsers( candidateFollowingUsers: [SPUser], resultBlock: SPActivityResultBlock ) {
        let fromUser = SPUser.currentUser()
        let activityQuery = PFQuery( className: "Activity" )
        activityQuery.includeKey("fromUser")
        activityQuery.includeKey("toUser")
        activityQuery.includeKey("photoPair")
        activityQuery.includeKey("photoPair.user")
        activityQuery.whereKey( "fromUser", equalTo: fromUser! )
        activityQuery.whereKey( "toUser", containedIn: candidateFollowingUsers )
        activityQuery.whereKey( "type", equalTo: ActivityType.Follow.rawValue )
        activityQuery.whereKey( "isArchiveReady", equalTo: false )
        activityQuery.findObjectsInBackgroundWithBlock { (activities, error) -> Void in
            if error == nil {
                let foundActivities = activities as! [SPActivity]
                resultBlock( activities: foundActivities, error: error )
            } else {
                print( error )
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
        let photoOne = SPPhoto()
        photoOne.photo = fileOne
        photoOne.photoThumbnail = fileOne
        
        let photoTwo = SPPhoto()
        photoTwo.photo = fileTwo
        photoTwo.photoThumbnail = fileTwo

        
        let pfObjects = [photoOne, photoTwo]
        PFObject.saveAllInBackground(pfObjects, block: { (success, error) -> Void in
            if error == nil {
                
                let photoPair = SPPhotoPair()
                photoPair.photoOne = photoOne
                photoPair.photoTwo = photoTwo
                photoPair.caption = caption
                photoPair.user = SPUser.currentUser()
                photoPair.isArchiveReady = false
                
                let closetPhotoOne = SPClosetPhoto()
                closetPhotoOne.isVisible = true
                closetPhotoOne.user = SPUser.currentUser()
                closetPhotoOne.photo = photoOne                
                
                let closetPhotoTwo = SPClosetPhoto()
                closetPhotoTwo.isVisible = true
                closetPhotoTwo.user = SPUser.currentUser()
                closetPhotoTwo.photo = photoTwo
                
                let morePFObjects = [ photoPair, closetPhotoOne, closetPhotoTwo ]
                PFObject.saveAllInBackground(morePFObjects, block: { (success, error) -> Void in
                    resultsBlock( success, error )
                })
            } else {
                print( error )
            }
        })

    }
    
    

    func saveAndPostImages( imageOne: UIImage?, imageTwo: UIImage?, caption: String, resultsBlock: PFBooleanResultBlock ) {
        if let imageOne = imageOne, imageTwo = imageTwo {
            var isImageOneSaved = false
            var isImageTwoSaved = false
            let imageData = UIImageJPEGRepresentation(imageOne, 0.05)
            let imageFile = PFFile(name: "Image.jpg", data: imageData!)
            let imageDataTwo = UIImageJPEGRepresentation(imageTwo, 0.05)
            let imageFileTwo = PFFile(name: "Image.jpg", data: imageDataTwo!)
            
            imageFile!.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                if error == nil {
                    
                    
                    isImageOneSaved = true
                    if isImageTwoSaved {
                        
                        self.finishPostingWithFileOne(imageFile!, fileTwo: imageFileTwo!, caption: caption, resultsBlock: { (success, error) -> Void in
                            resultsBlock( success, error );
                        })
                    }
                } else {
                    print( error )
                }
            }

            
            imageFileTwo!.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                if error == nil {
                    isImageTwoSaved = true
                    if isImageOneSaved {
                        self.finishPostingWithFileOne(imageFile!, fileTwo: imageFileTwo!, caption: caption, resultsBlock: { (success, error) -> Void in
                            resultsBlock( success, error );
                        })
                    }
                } else {
                    print( error )
                }
            }
        } else {
            let errorMessage = "ERROR: one or the other image is nil passed to saveImages so can't save images"
            print( errorMessage )
            resultsBlock( false, NSError(domain:"com.Stylpic", code: -1001, userInfo:[ "error": errorMessage ] ) )
        }
    }
    
    
    
    func loginWithFacebook(completionHander : SPBoolResultBlock){
        let permissions = ["public_profile", "user_friends", "email"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (user, error) -> Void in
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
                self.loadFBDataForUser(user!)
                completionHander(success: true, error: nil)
            }
        })
    }
    
    func loadFBDataForUser(user: PFUser){
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,first_name,last_name"])
        request.startWithCompletionHandler { (connection, result, error) -> Void in
            //TODO: Need to test this facebook user invalidation testing out.
            if let error = error{
                    if let cError = error.userInfo["error"] as? NSDictionary{
                        if let type = cError["type"] as? String{
                            if type == "OAuthException"{
                                print("FB Session was invalidated.")
                                //self.logoutButtonTouchUpInside(nil)
                            }
                        }
                    }
            }
            else
            {
                let userData = result as! NSDictionary
                let facebookID = userData["id"] as! String
                user.setObject(userData["first_name"]!, forKey: "firstName")
                user.setObject(userData["last_name"]!, forKey: "lastName")
                user.setObject(userData["name"]!, forKey: "fullName")
                user.setObject(facebookID, forKey: "facebookId")
                let pictureURL = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1")
                let request = NSURLRequest(URL: pictureURL!)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, connectionError) -> Void in
                    if (connectionError == nil && data != nil) {
                        let profilePicture = PFFile(name: "ProfilePicture", data: data!)
                        user.setObject(profilePicture!, forKey: "profilePicture")
                        user.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if(error != nil){
                                print(error)
                            }
                        })
                    }
                })
            }
        }
    }
    
    func displayLoadingIndicator(visible: Bool){
        if(visible){
            MRProgressOverlayView.showOverlayAddedTo(UIApplication.sharedApplication().delegate?.window!, animated: true)
        }
        else{
            MRProgressOverlayView.dismissOverlayForView(UIApplication.sharedApplication().delegate?.window!, animated: true)
        }
    }
}
