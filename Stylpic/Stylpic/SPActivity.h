//
//  SPActivity.h
//  Stylpic
//
//  Created by Joshua Bell on 3/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import <Parse/Parse.h>
#import "SPUser.h"

@class SPPhotoPair;


typedef enum : NSUInteger {
    CommentImageOne,
    CommentImageTwo,
    LikeImageOne,
    LikeImageTwo,
    Follow,
    Join
} ActivityType;

@interface SPActivity : PFObject <PFSubclassing>

@property (nonatomic) SPUser *fromUser;
@property (nonatomic) SPUser *toUser;
@property (nonatomic) NSNumber *type;
@property (nonatomic) NSString *content;
@property (nonatomic) SPPhotoPair *photoPair;
@property (nonatomic) NSNumber *isArchiveReady; // BOOL
@property (nonatomic) NSNumber *notificationViewed; // BOOL

- (NSString *)displayMessage;

@end
