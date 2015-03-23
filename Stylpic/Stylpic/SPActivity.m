//
//  SPActivity.m
//  Stylpic
//
//  Created by Joshua Bell on 3/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import "SPActivity.h"

@implementation SPActivity

@dynamic fromUser, toUser, type, content, photoPair, isArchiveReady, notificationViewed;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Activity";
}

- (NSString *)displayMessage {
        return @"TODO: finish";
}


//
//func displayMessage() -> String {
//    var message = ""
//    var spUser = fromUser as! SPUser
//    var userName = spUser.spDisplayName()
//    if let activityType = activityType{
//        switch activityType {
//        case .CommentImageOne, .CommentImageTwo:
//            message = "\(userName) commented on your photo"
//            break
//        case .LikeImageOne, .LikeImageTwo:
//            message = "\(userName) liked your photo"
//            break
//        case .Follow:
//            message = "\(userName) followed you"
//        default:
//            break
//        }
//    }
//    
//    return message
//}


@end
