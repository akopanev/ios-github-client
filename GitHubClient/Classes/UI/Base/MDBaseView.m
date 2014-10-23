//
//  MDBaseView.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "MDBaseView.h"

const NSTimeInterval MDBaseViewModalViewAnimationDuration		= 0.15;

@implementation MDBaseView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	}
	return self;
}

#pragma mark -

- (CGRect)modalViewFrame {
	return self.bounds;
}

- (void)setModalView:(UIView *)modalView {
	[self.modalView removeFromSuperview];
	_modalView = modalView;
	if (_modalView) {
		[self addSubview:_modalView];
		[self setNeedsLayout];
	}
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	self.modalView.frame = self.modalViewFrame;
}

@end
