//
//  SPPhoto.h
//  Stylpic
//
//  Created by Joshua Bell on 4/4/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import <Parse/Parse.h>

@interface SPPhoto : PFObject <PFSubclassing>

@property (nonatomic) PFFile *photo;
@property (nonatomic) PFFile *photoThumbnail;

@end
