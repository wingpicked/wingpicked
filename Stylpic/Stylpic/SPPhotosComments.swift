//
//  SPPhotosComments.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPPhotosComments: NSObject {
   
    // array of Activity
    var commentsPhotoOne : [SPActivity] = []
    // array of Activity
    var commentsPhotoTwo : [SPActivity] = []
    
    // sorted by updatedAt
    lazy var sortedCommentsPhotoOne : [SPActivity] = {
        return self.sortedActivities(self.commentsPhotoOne)
    }()

    // sorted by updatedAt
    lazy var sortedCommentsPhotoTwo : [SPActivity] = {
        return self.sortedActivities(self.commentsPhotoTwo)
    }()
    
    
    func sortedActivities( activities:[SPActivity] ) -> [SPActivity] {
        var someSortedComments: [SPActivity] = []
        if activities.count > 1 {
            someSortedComments = activities.sort { activity1, activity2 in
                let dateComparison = activity1.updatedAt?.compare(activity2.updatedAt!)
                return dateComparison == NSComparisonResult.OrderedAscending
            }
        } else {
            someSortedComments = NSArray.init( array:activities as [SPActivity] ) as! [SPActivity]
        }
        
        return someSortedComments
    }


}

