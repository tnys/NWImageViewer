//
//  NWZoomingScrollView.m
//  NWImageViewer
//
//  Created by Tom Nys on 04/05/13.
//  Copyright (c) 2013 Tom Nys. All rights reserved.
//

#import "NWZoomingImageView.h"
#import "NWTapDetectingView.h"
#import "NWTapDetectingImageView.h"

@interface NWZoomingImageView()<UIScrollViewDelegate, NWTapDetectingImageViewDelegate, NWTapDetectingViewDelegate>
{
	NWTapDetectingView* _tapView;
	NWTapDetectingImageView* _photoImageView;
}

@end

@implementation NWZoomingImageView

-(void)setup
{
	// Tap view for background
	_tapView = [[NWTapDetectingView alloc] initWithFrame:self.bounds];
	_tapView.tapDelegate = self;
	_tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_tapView.backgroundColor = [UIColor blackColor];
	[self addSubview:_tapView];
	
	// Image view
	_photoImageView = [[NWTapDetectingImageView alloc] initWithFrame:CGRectZero];
	_photoImageView.tapDelegate = self;
	_photoImageView.contentMode = UIViewContentModeCenter;
	_photoImageView.backgroundColor = [UIColor blackColor];
	[self addSubview:_photoImageView];
	
	// Setup
	self.backgroundColor = [UIColor blackColor];
	self.delegate = self;
	self.showsHorizontalScrollIndicator = NO;
	self.showsVerticalScrollIndicator = NO;
	self.decelerationRate = UIScrollViewDecelerationRateFast;
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
		[self setMaxMinZoomScalesForCurrentBounds];
		[self setNeedsLayout];
	}];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self setup];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame]))
	{
		[self setup];
    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Image

// Get and display image
-(void)setImage:(UIImage *)image
{
	_image = image;
		
	// Reset
	self.maximumZoomScale = 1;
	self.minimumZoomScale = 1;
	self.zoomScale = 1;
	self.contentSize = CGSizeMake(0, 0);
		
	if (_image) {
		// Set image
		_photoImageView.image = _image;
		_photoImageView.hidden = NO;
		
		// Setup photo frame
		CGRect photoImageViewFrame;
		photoImageViewFrame.origin = CGPointZero;
		photoImageViewFrame.size = _image.size;
		_photoImageView.frame = photoImageViewFrame;
		self.contentSize = photoImageViewFrame.size;
		
		// Set zoom to minimum zoom
		[self setMaxMinZoomScalesForCurrentBounds];
		
	} else {
		
		// Hide image view
		_photoImageView.hidden = YES;
		
	}
	[self setNeedsLayout];
}

#pragma mark - Setup

- (void)setMaxMinZoomScalesForCurrentBounds {
	
	// Reset
	self.maximumZoomScale = 1;
	self.minimumZoomScale = 1;
	self.zoomScale = 1;
	
	// Bail
	if (_photoImageView.image == nil) return;
	
	// Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.frame.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
	
	// If image is smaller than the screen then ensure we show it at
	// min scale of 1
	if (xScale > 1 && yScale > 1) {
		minScale = 1.0;
	}
    
	// Calculate Max
	CGFloat maxScale = 4.0; // Allow double scale
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	
	// Set
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
	
	// Reset position
	_photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
	[self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews {
	
	// Update tap view frame
	_tapView.frame = self.bounds;
	
	// Super
	[super layoutSubviews];
	
	
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
	} else {
        frameToCenter.origin.x = 0;
	}
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
	} else {
        frameToCenter.origin.y = 0;
	}
    
	// Center
	if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
		_photoImageView.frame = frameToCenter;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _photoImageView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if ([self.zoomingDelegate respondsToSelector:@selector(cancelControlHiding)])
		[self.zoomingDelegate cancelControlHiding];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
	if ([self.zoomingDelegate respondsToSelector:@selector(cancelControlHiding)])
		[self.zoomingDelegate cancelControlHiding];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if ([self.zoomingDelegate respondsToSelector:@selector(hideControlsAfterDelay)])
		[self.zoomingDelegate hideControlsAfterDelay];
}

#pragma mark - Tap Detection

- (void)handleSingleTap:(CGPoint)touchPoint {
	if ([self.zoomingDelegate respondsToSelector:@selector(toggleControls)])
		[self.zoomingDelegate performSelector:@selector(toggleControls) withObject:nil afterDelay:0.2];
}

- (void)handleDoubleTap:(CGPoint)touchPoint {
	
	// Cancel any single tap handling
	[NSObject cancelPreviousPerformRequestsWithTarget:self.zoomingDelegate];
	
	// Zoom
	if (self.zoomScale == self.maximumZoomScale) {
		
		// Zoom out
		[self setZoomScale:self.minimumZoomScale animated:YES];
		
	} else {
		
		// Zoom in
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
		
	}
	
	// Delay controls
	if ([self.zoomingDelegate respondsToSelector:@selector(hideControlsAfterDelay)])
		[self.zoomingDelegate hideControlsAfterDelay];
	
}

// Image View
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch {
    [self handleSingleTap:[touch locationInView:imageView]];
}
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:imageView]];
}

// Background View
- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch {
    [self handleSingleTap:[touch locationInView:view]];
}
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:view]];
}

@end
