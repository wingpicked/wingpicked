//
//  SPUser.h
//  Stylpic
//
//  Created by Joshua Bell on 3/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import <Parse/Parse.h>

@interface SPUser : PFUser <PFSubclassing>

@property (nonatomic) NSString *facebookId;
@property (nonatomic) NSString *channel;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) PFFile *profilePicture;
@property (nonatomic) NSNumber *isFollowing; // BOOL
@property (nonatomic) NSArray *facebookFriends; // array of SPUser


-(NSString *)spDisplayName;

@end
