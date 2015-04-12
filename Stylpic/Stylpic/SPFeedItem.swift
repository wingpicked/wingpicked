//
//  SPNewsFeedItem.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

enum PhotoUserLikes: Int {
    case NoPhotoLiked // 0
    case FirstPhotoLiked // 1
    case SecondPhotoLiked // 2
}


//TODO: This model needs to be broken down into two SPPhoto's each one holding its own likes, comments, percentages, and comments
class SPFeedItem: NSObject {
    var photos : SPPhotoPair?
    var caption = ""
    var likesCountOne = 0
    var likesCountTwo = 0
    var commentsCountOne: Int! = 0
    var commentsCountTwo = 0
    var percentageLikedOne = 0.0
    var percentageLikedTwo = 0.0
    var username = ""
    var userProfilePicture : PFFile?
    var photoUserLikes = PhotoUserLikes.NoPhotoLiked
    var comments = SPPhotosComments()
    var timeintervalSincePost : NSString?
    var isCurrentUserFollowing = true
    
    func setupWithServerFeedItem( serverFeedItem: Dictionary<String, AnyObject> ) {
        self.caption = serverFeedItem[ "caption" ] as! String
        var comments = serverFeedItem[ "comments" ] as! Dictionary<String, AnyObject>
        var commentsPhoto1 = comments[ "commentsPhoto1" ] as! Array<SPActivity>
        self.comments.commentsPhotoOne = commentsPhoto1
        var commentsPhoto2 = comments[ "commentsPhoto2" ] as! Array<SPActivity>
        self.comments.commentsPhotoTwo = commentsPhoto2
        
        self.photos = serverFeedItem[ "photoPair" ] as? SPPhotoPair
        self.commentsCountOne = serverFeedItem[ "commentsCountOne" ] as! Int
        self.commentsCountTwo = serverFeedItem[ "commentsCountTwo" ] as! Int
        self.likesCountOne = serverFeedItem[ "likesCountOne" ] as! Int
        self.likesCountTwo = serverFeedItem[ "likesCountTwo" ] as! Int
        self.percentageLikedOne = serverFeedItem[ "percentageLikedOne" ] as! Double
        self.percentageLikedTwo = serverFeedItem[ "percentageLikedTwo" ] as! Double
        self.username = serverFeedItem[ "username" ] as! String
        self.isCurrentUserFollowing = serverFeedItem[ "isCurrentUserFollowing" ] as! Bool
        let photoUserLikes = serverFeedItem[ "photoUserLikes" ] as! Int
        self.photoUserLikes = PhotoUserLikes( rawValue: photoUserLikes )!
        
        
        let timeIntervalFormatter = TTTTimeIntervalFormatter()
        let x = self.photos?.updatedAt.timeIntervalSinceNow
        if let x = x{
            self.timeintervalSincePost = timeIntervalFormatter.stringForTimeInterval(x)
        }
    }
}
