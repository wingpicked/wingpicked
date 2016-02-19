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
    [self fetchIfNeeded];
    NSString *message;
    switch ([self.type intValue]) {
        case CommentImageOne:
        case CommentImageTwo:
            message = [NSString stringWithFormat:@"%@ commented on your photo", [self.fromUser spDisplayName]];
            break;
        case LikeImageOne:
        case LikeImageTwo:
            message = [NSString stringWithFormat:@"%@ liked your photo", [self.fromUser spDisplayName]];
            break;
        case Follow:
            message = [NSString stringWithFormat:@"%@ followed you", [self.fromUser spDisplayName]];
            break;
        default:
            message = @"Unknown Notification";
            break;
    }
    
    return message;
    
}

@end
