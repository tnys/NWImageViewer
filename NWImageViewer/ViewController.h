//
//  ViewController.h
//  NWImageViewer
//
//  Created by Tom Nys on 04/05/13.
//  Copyright (c) 2013 Tom Nys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NWZoomingImageView;

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet NWZoomingImageView *imageView;

@end
