//
//  SPPhoto.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPPhotoPair: PFObject, PFSubclassing {
    @NSManaged var imageOne : PFFile?
    @NSManaged var imageTwo : PFFile?
    @NSManaged var thumbnailOne : PFFile?
    @NSManaged var thumbnailTwo : PFFile?
    @NSManaged var caption : String?
    @NSManaged var user : SPUser?
    
    override init() {
        super.init()
    }
//    func setup( imageOne: PFFile, thumbnailImageOne: PFFile, imageTwo: PFFile, thumbnailImageTwo: PFFile, postCaption: String, postingUser: SPUser ) {
//        self.imageOne = imageOne
//        self.imageTwo = imageTwo
//        self.thumbnailOne = thumbnailImageOne
//        self.thumbnailTwo = thumbnailImageTwo
//        self.caption = postCaption
//        self.user = postingUser
//    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String! {
        return "Photos"
    }
    
}
