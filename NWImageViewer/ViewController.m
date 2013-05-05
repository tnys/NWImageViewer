//
//  ViewController.m
//  NWImageViewer
//
//  Created by Tom Nys on 04/05/13.
//  Copyright (c) 2013 Tom Nys. All rights reserved.
//

#import "ViewController.h"
#import "NWZoomingImageView.h"

@interface ViewController ()<NWZoomingImageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.imageView.zoomingDelegate = self;
//	self.imageView.image = [UIImage imageNamed:@"movie-collection-ipad.jpg"];
	self.imageView.image = [UIImage imageNamed:@"small.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}

// Tell the system It should autorotate
- (BOOL) shouldAutorotate {
	return YES;
}

@end
