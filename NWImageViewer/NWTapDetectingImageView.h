//
//  NWTapDetectingImageView.h
//  NWImageViewer
//
//  Created by Tom Nys on 04/05/13.
//  Copyright (c) 2013 Tom Nys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NWTapDetectingImageViewDelegate <NSObject>
@optional
- (void)imageView:(UIImageView *)view singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)view doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)view tripleTapDetected:(UITouch *)touch;
@end

@interface NWTapDetectingImageView : UIImageView

@property (nonatomic, weak) id <NWTapDetectingImageViewDelegate> tapDelegate;

@end
