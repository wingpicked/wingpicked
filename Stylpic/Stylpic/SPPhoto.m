//
//  SPPhoto.m
//  Stylpic
//
//  Created by Joshua Bell on 4/4/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import "SPPhoto.h"
#import <Parse/PFObject+Subclass.h>

@implementation SPPhoto

@dynamic photo, photoThumbnail;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Photo";
}

@end
