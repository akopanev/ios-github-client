//
//  GHReposView.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHReposView.h"
#import "GHReposHeaderView.h"
#import "GHReposAdditionalInfoView.h"

@interface GHReposView ()

@property (nonatomic, readonly) GHReposHeaderView			*headerView;
@property (nonatomic, strong) NSMutableArray				*additionalInfoViews;

@end

@implementation GHReposView

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor whiteColor];
		
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
		[self addSubview:self.scrollView];
		
		_headerView = [[GHReposHeaderView alloc] initWithFrame:CGRectZero];
		[self.scrollView addSubview:self.headerView];
		
		self.additionalInfoViews = [NSMutableArray array];
	}
	return self;
}

#pragma mark -

- (void)setUserModel:(GHUserModel *)userModel {
	_userModel = userModel;
	self.headerView.userModel = self.userModel;
	[self layoutScrollViewSubviews];
}

#pragma mark -

- (void)addAdditionalInfo:(GHRepoAdditionalInfoModel *)additionalInfoModel {
	GHReposAdditionalInfoView *infoView = [[GHReposAdditionalInfoView alloc] initWithFrame:CGRectZero];
	infoView.infoModel = additionalInfoModel;
	[self.additionalInfoViews addObject:infoView];
	[self.scrollView addSubview:infoView];
	[self layoutScrollViewSubviews];
}

#pragma mark -

- (void)layoutScrollViewSubviews {	
	const CGFloat horizontalMargin = 20.0;
	const CGFloat verticalMargin = 5.0;
	CGFloat contentWidth = self.bounds.size.width - horizontalMargin * 2.0;
	CGSize headerSize = [GHReposHeaderView sizeWithModel:self.userModel width:contentWidth];
	self.headerView.frame = CGRectMake(horizontalMargin, verticalMargin, headerSize.width, headerSize.height);
	
	CGFloat currentY = CGRectGetMaxY(self.headerView.frame) + verticalMargin;
	for (GHReposAdditionalInfoView *infoView in self.additionalInfoViews) {
		CGSize infoSize = [GHReposAdditionalInfoView sizeWithModel:infoView.infoModel width:contentWidth];
		infoView.frame = CGRectMake(horizontalMargin, currentY, infoSize.width, infoSize.height);
		currentY = CGRectGetMaxY(infoView.frame) + verticalMargin;
	}
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, currentY);
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.scrollView.frame = self.bounds;
	[self layoutScrollViewSubviews];
}

@end
