//
//  MDErrorView.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "MDErrorView.h"

@implementation MDErrorView

+ (instancetype)errorWithWithHint:(NSString *)hint target:(id)target action:(SEL)action {
	return [self errorWithWithHint:hint errorHint:nil target:target action:action];
}

+ (instancetype)errorWithWithHint:(NSString *)hint errorHint:(NSString *)errorHint target:(id)target action:(SEL)action {
	MDErrorView *errorView = [[MDErrorView alloc] initWithFrame:CGRectZero];
	if (target && action) {
		[errorView.tryAgainButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	}
	errorView.hintLabel.text = hint;
	errorView.errorHintLabel.text = errorHint ? errorHint : @"";
	return errorView;
}

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor whiteColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		_hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_hintLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
		_hintLabel.textAlignment = NSTextAlignmentCenter;
		_hintLabel.numberOfLines = 0;
		_hintLabel.text = NSLS(@"GENERAL_ERROR");
		[self addSubview:_hintLabel];
		
		_errorHintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_errorHintLabel.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:10.0];
		_errorHintLabel.textAlignment = NSTextAlignmentCenter;
		_errorHintLabel.numberOfLines = 1;
		[self addSubview:_errorHintLabel];

		_tryAgainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[_tryAgainButton setTitle:NSLS(@"TRY_AGAIN") forState:UIControlStateNormal];
		_tryAgainButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
		[self addSubview:_tryAgainButton];
	}
	return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	
	const CGFloat horizontalMargin = 20.0;
	CGFloat errorLabelHeight = ceilf(self.errorHintLabel.font.lineHeight * 2.0);
	self.errorHintLabel.frame = CGRectMake(horizontalMargin, self.bounds.size.height - errorLabelHeight, self.bounds.size.width - horizontalMargin * 2.0, errorLabelHeight);
	
	CGFloat tryAgainButtonHeight = 40.0;
	CGFloat tryAgainButtonWidth = self.bounds.size.width - horizontalMargin * 2.0;
	self.tryAgainButton.frame = CGRectMake(ceilf(self.bounds.size.width * 0.5 - tryAgainButtonWidth * 0.5), CGRectGetMinY(self.errorHintLabel.frame) - 10.0 - tryAgainButtonHeight, tryAgainButtonWidth, tryAgainButtonHeight);
	
	CGFloat topOffset = 20.0;
	CGFloat hintLabelHeight = CGRectGetMinY(self.tryAgainButton.frame) - 10.0 - topOffset;
	self.hintLabel.frame = CGRectMake(horizontalMargin, topOffset, self.bounds.size.width - horizontalMargin * 2.0, hintLabelHeight);
}

@end
