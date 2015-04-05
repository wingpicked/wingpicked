//
//  SPPhotoPair.h
//  Stylpic
//
//  Created by Joshua Bell on 3/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import <Parse/Parse.h>

@class SPUser, SPPhoto;

@interface SPPhotoPair : PFObject <PFSubclassing>

@property (nonatomic) SPPhoto *photoOne;
@property (nonatomic) SPPhoto *photoTwo;
@property (nonatomic) NSString *caption;
@property (nonatomic) SPUser *user;

@end
