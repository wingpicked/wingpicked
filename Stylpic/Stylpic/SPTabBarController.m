//
//  SPTabBarController.m
//  Stylpic
//
//  Created by Neil Bhargava on 4/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

#import "SPTabBarController.h"
#import "Stylpic-Swift.h"

@interface SPTabBarController ()
@property(nonatomic, strong) UIButton *centerButton;
@end

@implementation SPTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.tabBarController.delegate = self;
    self.delegate = self;
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"Icon_post"] highlightImage:[UIImage imageNamed:@"Icon_post"] target:self action:@selector(buttonPressed:)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Create a custom UIButton and add it to the center of our tab bar
- (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0) {
        button.center = self.tabBar.center;
    } else {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    self.centerButton = button;
}

- (void)buttonPressed:(id)sender
{
    [self didSelectModalVC];
    //[self setSelectedIndex:2];
    [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
}

- (void)doHighlight:(UIButton*)b {
    [b setHighlighted:YES];
}

- (void)doNotHighlight:(UIButton*)b {
    [b setHighlighted:NO];
}

- (BOOL)tabBarHidden {
    return self.centerButton.hidden && self.tabBar.hidden;
}

- (void)setTabBarHidden:(BOOL)tabBarHidden
{
    self.centerButton.hidden = tabBarHidden;
    self.tabBar.hidden = tabBarHidden;
}

-(void) didSelectModalVC{
    UIImagePickerController *imagePickerViewController = [[UIImagePickerController alloc] init];
    [imagePickerViewController setSourceType:UIImagePickerControllerSourceTypeCamera];
    //imagePickerViewController.delegate = self;
    SPCameraOverlay *overlayView = (SPCameraOverlay *)[[NSBundle mainBundle] loadNibNamed:@"SPCameraOverlay" owner:nil options:nil][0];
    overlayView.delegate =self;
    imagePickerViewController.cameraOverlayView = overlayView;
//    self.overlayView = NSBundle.mainBundle().loadNibNamed("SPCameraOverlay", owner: nil, options: nil)[0] as? SPCameraOverlay
//    overlayView?.delegate = self
    
    [self presentViewController:imagePickerViewController animated:true completion:nil];
    
    //SPCameraOverlay *vc = [[SPCameraOverlay alloc] initWithNibName:@"SPProfileViewController" bundle:nil];
    //[self presentModalViewController:vc animated:true];
    //[self presentViewController:vc animated:TRUE completion:nil];
}

-(void) selectPhotosButtonDidTap{
    NSLog(@"HI!");
}



@end
