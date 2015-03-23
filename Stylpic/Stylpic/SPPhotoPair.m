//
//  SPPhotoPair.m
//  Stylpic
//
//  Created by Joshua Bell on 3/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import "SPPhotoPair.h"
#import <Parse/PFObject+Subclass.h>

@implementation SPPhotoPair
@dynamic imageOne, imageTwo, thumbnailOne, thumbnailTwo, caption, user;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Photos";
}


@end
