//
//  SPActivity.h
//  Stylpic
//
//  Created by Joshua Bell on 3/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import <Parse/Parse.h>

@class SPPhotoPair;


@interface SPActivity : PFObject <PFSubclassing>

@property (nonatomic) PFUser *fromUser;
@property (nonatomic) PFUser *toUser;
@property (nonatomic) NSNumber *type;
@property (nonatomic) NSString *content;
@property (nonatomic) SPPhotoPair *photoPair;
@property (nonatomic) NSNumber *isArchiveReady; // BOOL
@property (nonatomic) NSNumber *notificationViewed; // BOOL
@end
