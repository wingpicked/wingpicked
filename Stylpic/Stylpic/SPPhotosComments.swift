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
    
    // sorted by updatedAt with 4 most recent comments
    lazy var sortedCommentsPhotoOne : [SPActivity] = {
        return self.sortedActivities(self.commentsPhotoOne)
    }()

    // sorted by updatedAt with 4 most recent comments
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
        
        
        if someSortedComments.count > 4 {
            let firstComment = someSortedComments[someSortedComments.count - 4]
            let secondComment = someSortedComments[someSortedComments.count - 3]
            let thirdComment = someSortedComments[someSortedComments.count - 2]
            let fourthComment = someSortedComments[someSortedComments.count - 1]
            someSortedComments = [ firstComment, secondComment, thirdComment, fourthComment]
        }
        
        return someSortedComments
    }

    func updateSortedCommentsOne() {
        self.sortedCommentsPhotoOne = self.sortedActivities(self.commentsPhotoOne)
    }

    func updateSortedCommentsTwo() {
        self.sortedCommentsPhotoTwo = self.sortedActivities(self.commentsPhotoTwo)
    }
}

