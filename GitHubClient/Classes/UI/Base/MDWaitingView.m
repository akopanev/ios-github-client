//
//  MDWaitingView.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "MDWaitingView.h"

@interface MDWaitingView ()

@end

@implementation MDWaitingView

#pragma mark -

+ (instancetype)waitingView {
	return [self waitingViewWithHint:NSLS(@"GENERAL_PLEASE_WAIT")];
}

+ (instancetype)waitingViewWithHint:(NSString *)hint {
	MDWaitingView *waitingView = [[self alloc] initWithFrame:CGRectZero];
	waitingView.hintLabel.text = hint;
	return waitingView;
}

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor whiteColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		_hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_hintLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
		_hintLabel.numberOfLines = 0;
		_hintLabel.text = NSLS(@"GENERAL_PLEASE_WAIT");
		[self addSubview:_hintLabel];
		
		_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		_activityIndicatorView.color = [UIColor blackColor];
		[_activityIndicatorView startAnimating];
		[self addSubview:_activityIndicatorView];
	}
	return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	
	const CGFloat horizontalMargin = 40.0;
	const CGFloat offset = 10.0;
	CGFloat startX = horizontalMargin;
	CGFloat activitySize = self.activityIndicatorView.bounds.size.width;
	CGFloat maxLabelWidth = self.bounds.size.width - horizontalMargin * 2.0 - offset - activitySize;
	CGSize textSize = [self.hintLabel.text maSizeWithFont:self.hintLabel.font constrainedToSize:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
	
	if (textSize.width < maxLabelWidth) {
		startX += ceilf( (maxLabelWidth - textSize.width) * 0.5 );
	}
	
	self.activityIndicatorView.frame = CGRectMake(startX, ceilf(self.bounds.size.height * 0.5 - activitySize * 0.5), activitySize, activitySize);
	self.hintLabel.frame = CGRectMake(CGRectGetMaxX(self.activityIndicatorView.frame) + offset, ceilf(self.bounds.size.height * 0.5 - textSize.height * 0.5), textSize.width, textSize.height);
}

@end
