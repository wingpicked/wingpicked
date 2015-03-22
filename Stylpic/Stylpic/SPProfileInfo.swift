//
//  SPProfileInfo.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit


extension NSDictionary {
    
    
    /**
    Always return a value
    
    :param: key key to lookup the value
    
    :returns: returns 0 if not found or the Int if Number is found
    */
    func safeIntForKey( key:String? ) -> Int {
        var safeInt = 0
        if let key = key {
            var value: AnyObject? = self.objectForKey( key )
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
    
    :param: key <#key description#>
    
    :returns: <#return value description#>
    */
    func safeBoolForKey( key:String? ) -> Bool {
        var safeBool = false
        if let key = key {
            var value: AnyObject? = self.objectForKey( key )
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
            var value: AnyObject? = self.objectForKey( key )
            if let value: AnyObject = value {
                if value is [AnyObject] {
                    safeArray = value as! NSArray
                }
            }
        }
        
        return safeArray as! [AnyObject]
    }
}


class SPProfileInfo: NSObject {
    var postsCount : Int = 0
    var followersCount : Int = 0
    var followingCount : Int = 0
    var isFollowing : Bool = false
    
    var posts : [SPFeedItem] = []
    var followers : [PFUser] = []
    var following : [PFUser] = []
    var notifications : [PFObject] = [] // SPActivity
    
    /**
    inits this class with server data
    
    :param: profileInfo NSDictionary of <String, AnyObject?>
    */
    func setupWithServerInfo( profileInfo: NSDictionary ) {
        self.postsCount = profileInfo.safeIntForKey( "postsCount" )
        self.followersCount = profileInfo.safeIntForKey( "followersCount" )
        self.followingCount = profileInfo.safeIntForKey( "followingCount" )
        self.isFollowing = profileInfo.safeBoolForKey( "isFollowing" )
        
        var arrayOfServerFeedItem = profileInfo[ "posts" ] as! [[String: AnyObject]]
        var arrayOfFeedItem = [];
        for serverFeeedItem in arrayOfServerFeedItem {
            var feedItem = SPFeedItem()
            feedItem.setupWithServerFeedItem( serverFeeedItem )
            self.posts.append(feedItem)
        }
        
        self.followers = profileInfo.safeArrayForKey( "followers" ) as! [PFUser]
        self.following = profileInfo.safeArrayForKey( "following" ) as! [PFUser]
        self.notifications = profileInfo.safeArrayForKey( "notifications" ) as! [PFObject]
        
    }
    
}
