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

@dynamic photoOne, photoTwo, caption, user, isArchiveReady;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"PhotoPair";
}


@end
