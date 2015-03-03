//
//  SPPhoto.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPPhotos: PFObject, PFSubclassing {
    @NSManaged var imageOne : PFFile
    @NSManaged var imageTwo : PFFile
    @NSManaged var thumbnailOne : PFFile
    @NSManaged var thumbnailTwo : PFFile
    @NSManaged var caption : String
    @NSManaged var user : SPUser
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String! {
        return "Photo"
    }
    
}
