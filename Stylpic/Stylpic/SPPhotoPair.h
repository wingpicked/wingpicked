//
//  SPPhotoPair.h
//  Stylpic
//
//  Created by Joshua Bell on 3/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import <Parse/Parse.h>

@class SPUser;

@interface SPPhotoPair : PFObject <PFSubclassing>

@property (nonatomic) PFFile *imageOne;
@property (nonatomic) PFFile *imageTwo;
@property (nonatomic) PFFile *thumbnailOne;
@property (nonatomic) PFFile *thumbnailTwo;
@property (nonatomic) NSString *caption;
@property (nonatomic) SPUser *user;


@end
