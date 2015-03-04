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
typealias SPFeedItemsResultBlock = ( feedItems: [SPNewsFeedItem], error: NSError?) -> Void
typealias SPSaveImagesResultsBlock = (imageOne: PFFile?, imageOneThumbnail: PFFile?, imageTwo: PFFile?, imageTwoThumbnail: PFFile?, error: NSError?) -> Void

class SPManager: NSObject {
    
    class var sharedInstance: SPManager {
        struct Static {
            static let instance: SPManager = SPManager()
        }
        return Static.instance
    }
    //MARK: Items
//    the Feed subclasses PFQueryTableViewController which has a delegate method -(PFQuery *)queryForTable
//    func getFeedItems( resultsBlock: SPFeedItemsResultBlock ) {
//        var photosQuery = PFQuery( className: "Photos" )
//        photosQuery.includeKey( "User" )
//        photosQuery.
//        
//    }
    
    func getExploreItems() -> [SPNewsFeedItem]{
        return [SPNewsFeedItem()]
    }
    
    func getProfileItems() -> [SPNewsFeedItem] {
        return [SPNewsFeedItem()]
    }
    
    func getMyClosetItems() -> [SPNewsFeedItem] {
        return [SPNewsFeedItem()]
    }

    
    func getPhotosComments() -> SPPhotosComments{
        return SPPhotosComments()
    }
    
    func postComment(comment: String) {
        
    }

    func likePhoto(comment: String) {
        
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
    
    func postPhotosToFeed(photos : SPPhotos, block: PFBooleanResultBlock ) {
        photos.saveInBackgroundWithBlock { (success, error) -> Void in
            block( success, error )
        }
    }
    
    func postPhotoToCloset(photos : SPPhotos) {
        
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
