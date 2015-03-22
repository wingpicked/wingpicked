//
//  SPUser.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPUser: PFUser, PFSubclassing {
    @NSManaged var displayName : String
    @NSManaged var profilePicture : PFFile
    @NSManaged var facebookId : String
    @NSManaged var facebookFriends : [SPUser]
    @NSManaged var channel : String
    @NSManaged var isFollowing : Bool
    @NSManaged var firstName : String
    @NSManaged var lastName : String
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    func spDisplayName() -> String {
        var lastInitial = (self.lastName as NSString).substringToIndex( 1 )
        return "\(self.firstName) \(lastInitial)."
    }
}
