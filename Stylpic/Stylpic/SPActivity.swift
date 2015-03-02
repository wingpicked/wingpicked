//
//  SPActivity.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

enum ActivityType : Int{
    case CommentImageOne
    case CommentImageTwo
    case LikeImageOne
    case LikeImageTwo
    case Follow
    case Join
}


class SPActivity: PFObject {
   
    @NSManaged var fromUser : SPUser
    @NSManaged var toUser : SPUser
    @NSManaged var type : NSNumber
    @NSManaged var content : String
    @NSManaged var photo : SPPhotos
    
    var activityType : ActivityType? {
        get {
            return ActivityType(rawValue: type.integerValue)
        }
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String! {
        return "Activity"
    }
    
    
}
