//
//  UIImage+BackgroundImage.h
//  Stylpic
//
//  Created by Neil Bhargava on 4/4/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BackgroundImage)

+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius;


@end
