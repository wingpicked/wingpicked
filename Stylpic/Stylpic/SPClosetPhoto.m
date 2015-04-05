//
//  SPClosetPhoto.m
//  Stylpic
//
//  Created by Joshua Bell on 4/4/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import "SPClosetPhoto.h"
#import <Parse/PFObject+Subclass.h>

@implementation SPClosetPhoto

@dynamic photo, isVisible, user;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"ClosetPhoto";
}

@end
