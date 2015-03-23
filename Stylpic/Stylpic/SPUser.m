//
//  SPUser.m
//  Stylpic
//
//  Created by Joshua Bell on 3/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import "SPUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation SPUser

@dynamic firstName, lastName, profilePicture, facebookId, facebookFriends, channel, isFollowing;

+ (void)load {
    [self registerSubclass];
}

-(NSString *)spDisplayName {
    NSString *lastInitial = [self.lastName substringToIndex:1];
    return [NSString stringWithFormat:@"%@ %@.", self.firstName, lastInitial];
}

@end
