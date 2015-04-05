//
//  SPClosetPhoto.h
//  Stylpic
//
//  Created by Joshua Bell on 4/4/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import <Parse/Parse.h>
@class SPPhoto, SPUser;

@interface SPClosetPhoto : PFObject <PFSubclassing>

@property (nonatomic) NSNumber *isVisible;
@property (nonatomic) SPPhoto *photo;
@property (nonatomic) SPUser *user;

@end
