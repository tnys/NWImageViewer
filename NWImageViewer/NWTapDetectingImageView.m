//
//  NWTapDetectingImageView.m
//  NWImageViewer
//
//  Created by Tom Nys on 04/05/13.
//  Copyright (c) 2013 Tom Nys. All rights reserved.
//

#import "NWTapDetectingImageView.h"

@implementation NWTapDetectingImageView

-(void)setup
{
	self.userInteractionEnabled = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self setup];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = touch.tapCount;
	switch (tapCount) {
		case 1:
			[self handleSingleTap:touch];
			break;
		case 2:
			[self handleDoubleTap:touch];
			break;
		case 3:
			[self handleTripleTap:touch];
			break;
		default:
			break;
	}
	[[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch {
	if ([self.tapDelegate respondsToSelector:@selector(view:singleTapDetected:)])
		[self.tapDelegate imageView:self singleTapDetected:touch];
}

- (void)handleDoubleTap:(UITouch *)touch {
	if ([self.tapDelegate respondsToSelector:@selector(view:doubleTapDetected:)])
		[self.tapDelegate imageView:self doubleTapDetected:touch];
}

- (void)handleTripleTap:(UITouch *)touch {
	if ([self.tapDelegate respondsToSelector:@selector(view:tripleTapDetected:)])
		[self.tapDelegate imageView:self tripleTapDetected:touch];
}
@end
