//
//  SPProfileInfo.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit


extension NSDictionary {
    
    //TODO: Refactor out this extension
    
    /**
    Always return a value
    
    - parameter key: key to lookup the value
    
    - returns: returns 0 if not found or the Int if Number is found
    */
    func safeIntForKey( key:String? ) -> Int {
        var safeInt = 0
        if let key = key {
            let value: AnyObject? = self.objectForKey( key )
            if let value: AnyObject = value {
                if value is NSNumber {
                    safeInt = value.integerValue
                }
            }
        }
        
        return safeInt
    }
    
    /**
    <#Description#>
    
    - parameter key: <#key description#>
    
    - returns: <#return value description#>
    */
    func safeBoolForKey( key:String? ) -> Bool {
        var safeBool = false
        if let key = key {
            let value: AnyObject? = self.objectForKey( key )
            if let value: AnyObject = value {
                if value is NSNumber {
                    safeBool = value.boolValue
                }
            }
        }
        
        return safeBool
    }
    
    
    func safeArrayForKey( key:String? ) -> [AnyObject] {
        var safeArray = []
        if let key = key {
            let value: AnyObject? = self.objectForKey( key )
            if let value: AnyObject = value {
                if value is [AnyObject] {
                    safeArray = value as! Array<AnyObject>
                }
            }
        }
        
        return safeArray as [AnyObject]
    }
}


class SPProfileInfo: NSObject {
    var postsCount : Int = 0
    var followersCount : Int = 0
    var followingCount : Int = 0
    var isFollowing : Bool = false
    
    var posts : [SPFeedItem] = []
    var followers : [SPUser] = []
    var following : [SPUser] = []
    var notifications : [SPActivity] = [] // SPActivity
    
    /**
    inits this class with server data
    
    - parameter profileInfo: NSDictionary of <String, AnyObject?>
    */
    func setupWithServerInfo( profileInfo: NSDictionary ) {
        self.postsCount = profileInfo.safeIntForKey( "postsCount" )
        self.followersCount = profileInfo.safeIntForKey( "followersCount" )
        self.followingCount = profileInfo.safeIntForKey( "followingCount" )
        self.isFollowing = profileInfo.safeBoolForKey( "isFollowing" )
        let arrayOfServerFeedItem = profileInfo[ "posts" ] as! [[String: AnyObject]]
        var arrayOfFeedItem = [];
        for serverFeeedItem in arrayOfServerFeedItem {
            let feedItem = SPFeedItem()
            feedItem.setupWithServerFeedItem( serverFeeedItem )
            self.posts.append(feedItem)
        }
        
        var fetchObjectsIfNeeded = [AnyObject]()
        let serverFollower = profileInfo.safeArrayForKey( "followers" ) as NSArray as! [[String: AnyObject]]
        for aServerFollower in serverFollower {
            let spUser = aServerFollower[ "user" ] as! SPUser
            let currentUserFollows = aServerFollower[ "isFollowing" ] as! NSNumber
            spUser.isFollowing = currentUserFollows
            self.followers.append( spUser )
            fetchObjectsIfNeeded.append( spUser )
        }
        
//        [[String: [String: AnyObject]] ]
//        user.isFollowing
        let serverFollowing = profileInfo.safeArrayForKey( "following" ) as NSArray as! [[String: AnyObject]]
        
        for aServerFollowing in serverFollowing {
            let spUser = aServerFollowing[ "user" ] as! SPUser
            let currentUserFollows = aServerFollowing[ "isFollowing" ] as! NSNumber
            spUser.isFollowing = currentUserFollows
//            println( spUser.lastName )
            self.following.append( spUser )
            fetchObjectsIfNeeded.append( spUser )
        }
        
        self.notifications = profileInfo.safeArrayForKey( "notifications" ) as NSArray as! [SPActivity]
        for activity in self.notifications {
            if let fromUser = activity.fromUser {
                fetchObjectsIfNeeded.append(fromUser)
            }
            
            if let toUser = activity.toUser {
                fetchObjectsIfNeeded.append(toUser)
            }
            
        }
        
        PFObject.fetchAllIfNeeded( fetchObjectsIfNeeded )
    }
    
}
