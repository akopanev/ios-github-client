//
//  GHLoadMoreContentView.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHLoadMoreContentView.h"

const CGFloat GHLoadMoreContentViewHeight			= 40.0;

@interface GHLoadMoreContentView ()

@property (nonatomic, readonly) UIActivityIndicatorView			*indicatorView;
@property (nonatomic, readonly) UILabel							*hintLabel;

@end

@implementation GHLoadMoreContentView

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:self.indicatorView];
		
		_hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_hintLabel.font = [UIFont fontWithName:[UIFont ghTitleFontName] size:12.0];
		_hintLabel.backgroundColor = [UIColor clearColor];
		_hintLabel.textColor = [UIColor grayColor];
		[self addSubview:self.hintLabel];
		
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

#pragma mark -

- (void)setLoadMoreModel:(GHLoadMoreModel *)loadMoreModel {
	_loadMoreModel = loadMoreModel;
	NSString *hintText = nil;

	switch (self.loadMoreModel.status) {
		case GHLoadMoreFailed:
			hintText = NSLS(@"LOAD_MORE_FAILED");
			[self.indicatorView stopAnimating];
			break;
		
		default:
			hintText = NSLS(@"LOAD_MORE_LOADING");
			[self.indicatorView startAnimating];
			break;
	}
	self.hintLabel.text = hintText;
	[self setNeedsDisplay];
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat horizontalMargin = 5.0;
	CGFloat activitySize = self.loadMoreModel.status != GHLoadMoreFailed ? self.indicatorView.bounds.size.width : 0.0;
	CGFloat maxTextWidth = self.bounds.size.width - self.indicatorView.bounds.size.width - horizontalMargin * 2.0 - (activitySize > 0 ? horizontalMargin : 0.0);
	CGSize textSize = [self.hintLabel.text maSizeWithFont:self.hintLabel.font constrainedToSize:CGSizeMake(maxTextWidth, CGFLOAT_MAX)];
	CGFloat contentWidth = textSize.width + (activitySize > 0 ? horizontalMargin : 0.0) + activitySize;
	
	self.indicatorView.frame = CGRectMake(ceilf(self.bounds.size.width * 0.5 - contentWidth * 0.5), ceilf(self.bounds.size.height * 0.5 - self.indicatorView.bounds.size.height * 0.5), activitySize, activitySize);
	self.hintLabel.frame = CGRectMake(CGRectGetMaxX(self.indicatorView.frame) + horizontalMargin, 0.0, textSize.width, self.bounds.size.height);
}

@end
