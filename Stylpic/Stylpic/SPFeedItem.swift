//
//  SPNewsFeedItem.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

enum PhotoUserLikes{
    case NoPhotoLiked // 0
    case FirstPhotoLiked // 1
    case SecondPhotoLiked // 2
}

class SPFeedItem: NSObject {
    var photos : PFObject!
    var caption : String!
    var likesCountOne: Int!
    var likesCountTwo: Int!
    var commentsCountOne : Int!
    var commentsCountTwo : Int!
    var percentageLikedOne : Float!
    var percentageLikedTwo : Float!
    var username: String!
    var userFriendlyTimestamp: String!
    var userProfilePicture : PFFile?
    var photoUserLikes : PhotoUserLikes!
    var comments : SPPhotosComments?
    
}
