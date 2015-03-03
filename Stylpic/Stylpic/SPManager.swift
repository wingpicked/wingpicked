//
//  SPManager.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPManager: NSObject {
   
    //MARK: Items
    func getFeedItems() -> [SPNewsFeedItem]{
        return [SPNewsFeedItem()]
    }
    
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
    
    func postPhotosToFeed(photos : SPPhotos) {
        
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
    
    
    
}
