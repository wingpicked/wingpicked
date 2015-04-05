////
////  SPTabBarController.m
////  Stylpic
////
////  Created by Neil Bhargava on 4/1/15.
////  Copyright (c) 2015 Neil Bhargava. All rights reserved.
////
//
//#import "SPTabBarController.h"
//#import "Stylpic-Swift.h"
//
//@interface SPTabBarController () <SPCameraOverlayDelegate, UIImagePickerControllerDelegate>
//@property(nonatomic, strong) UIButton *centerButton;
//@end
//
//@implementation SPTabBarController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    //    self.tabBarController.delegate = self;
//    self.delegate = self;
//    
//    [self addCenterButtonWithImage:[UIImage imageNamed:@"Icon_post"] highlightImage:[UIImage imageNamed:@"Icon_post"] target:self action:@selector(buttonPressed:)];
//}
//
//// Create a custom UIButton and add it to the center of our tab bar
//- (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action
//{
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
//    
//    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
//    if (heightDifference < 0) {
//        button.center = self.tabBar.center;
//    } else {
//        CGPoint center = self.tabBar.center;
//        center.y = center.y - heightDifference/2.0;
//        button.center = center;
//    }
//    
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:button];
//    self.centerButton = button;
//}
//
//- (void)buttonPressed:(id)sender
//{
//    [self didSelectModalVC];
////    [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
//}
//
////- (void)doHighlight:(UIButton*)b {
////    [b setHighlighted:YES];
////}
////
////- (void)doNotHighlight:(UIButton*)b {
////    [b setHighlighted:NO];
////}
//
//- (BOOL)tabBarHidden {
//    return self.centerButton.hidden && self.tabBar.hidden;
//}
//
//- (void)setTabBarHidden:(BOOL)tabBarHidden
//{
//    self.centerButton.hidden = tabBarHidden;
//    self.tabBar.hidden = tabBarHidden;
//}
//
//-(void) didSelectModalVC{
//    UIImagePickerController *imagePickerViewController = [[UIImagePickerController alloc] init];
//    [imagePickerViewController setSourceType:UIImagePickerControllerSourceTypeCamera];
//    //imagePickerViewController.delegate = self;
//    imagePickerViewController.showsCameraControls = false;
//    SPCameraOverlay *overlayView = (SPCameraOverlay *)[[NSBundle mainBundle] loadNibNamed:@"SPCameraOverlay" owner:nil options:nil][0];
//    overlayView.delegate = self;
//    imagePickerViewController.cameraOverlayView = overlayView;
//    [self presentViewController:imagePickerViewController animated:true completion:nil];
//}
//
//-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//   
//        let originalImage = info[ UIImagePickerControllerOriginalImage ] as! UIImage
//        println( "original image \(originalImage)" )
//        let squareRect = CGRectMake( 0, 0, originalImage.size.width, originalImage.size.width )
//        var imageRef: CGImageRef = CGImageCreateWithImageInRect(originalImage.CGImage, squareRect);
//        var squareImage = UIImage(CGImage:imageRef, scale: 1, orientation: UIImageOrientation.Right)
//        if let constUserPhotoOne = self.userPhotoOne {
//            self.userPhotoTwo = squareImage;
//            var editPhotoStoryboard = UIStoryboard(name: "SPEditPhotoStoryboard", bundle: nil)
//            var editPhotoController = editPhotoStoryboard.instantiateViewControllerWithIdentifier("SPEditPhotoViewController") as! SPEditPhotoViewController
//            self.imageViewOne.image = self.userPhotoOne
//            self.imageViewTwo.image = self.userPhotoTwo
//            self.dismissViewControllerAnimated(true, completion:nil)
//        } else {
//            self.userPhotoOne = squareImage;
//            self.shouldStartCameraController()
//        }
// }
//
//-(void) selectPhotosButtonDidTap{
//    NSLog(@"HI!");
//}
//
//-(void) selectPhotosDidTap{
//    NSLog(@"A");
//}
//
//-(void) takePhotoButtonDidTap{
//    NSLog(@"B");
//}
//
//
//@end
