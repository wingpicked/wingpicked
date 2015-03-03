//
//  SPNewsFeedItem.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

enum PhotoUserLikes{
    case NoPhotoLiked
    case FirstPhotoLiked
    case SecondPhotoLiked
}

class SPNewsFeedItem: NSObject {
    var photos : SPPhotos!
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
