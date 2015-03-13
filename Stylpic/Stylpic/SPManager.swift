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

class SPManager: NSObject {
    
    class var sharedInstance: SPManager {
        struct Static {
            static let instance: SPManager = SPManager()
        }
        return Static.instance
    }
    
    //MARK: Items
    func getFeedItems( page: UInt, resultsBlock: SPFeedItemsResultBlock ) {
        var params = [ "page": page ]
        PFCloud.callFunctionInBackground( "getFeedItemsForPage", withParameters: params) { (responseObject:AnyObject!, error:NSError!) -> Void in
            println( responseObject )

            var feedItems = [SPFeedItem]()
            if error == nil {
            var photos : [PFObject] = responseObject! as! [PFObject]
                for photo in photos {
                    // TEMP
                    var feedItem = SPFeedItem()
                    println( photo.objectForKey("caption"))
                    feedItem.caption = photo.objectForKey("caption") as! String
                    feedItem.photos = photo
                    feedItem.likesCountOne = 0
                    feedItem.likesCountTwo = 0
                    feedItem.commentsCountOne = 0
                    feedItem.commentsCountTwo = 0
                    feedItem.percentageLikedOne = 0
                    feedItem.username = SPUser.currentUser().username
                    let createdAtString = photo.createdAt
                    
//                    feedItem.userFriendlyTimestamp = createdAtString
                    feedItem.userProfilePicture = nil
                    feedItem.photoUserLikes = .NoPhotoLiked
                    feedItem.comments = SPPhotosComments()
                    feedItems.append( feedItem )
                }
                
                resultsBlock(feedItems:feedItems, error: nil)
            } else {
                println( error )
            }
        }
        
    }
    
    func getExploreItems() -> [SPFeedItem]{
        return [SPFeedItem()]
    }
    
    func getProfileItems() -> [SPFeedItem] {
        return [SPFeedItem()]
    }
    
    func getMyClosetItems() -> [SPFeedItem] {
        return [SPFeedItem()]
    }

    
    func getPhotosComments() -> SPPhotosComments{
        return SPPhotosComments()
    }
    
    func postComment(comment: String) {
        
    }

    func likePhoto( activityType: ActivityType, photoPair: SPPhotoPair, fromUser:SPUser, toUser: SPUser, content: NSString, resultBlock: SPBoolResultBlock ) {
        var activity = SPActivity()
        activity.fromUser = fromUser
        activity.toUser = toUser
        activity.photoPair = photoPair
        activity.isArchiveReady = false
        activity.type = activityType.rawValue
        activity.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                resultBlock(success: success, error: error)
            } else {
                println( error )
            }
        }
    }
    
    func followUser(user: PFUser) {
        
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
    
}
