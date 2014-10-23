//
//  GHReposAdditionalInfoView.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHReposAdditionalInfoView.h"

@interface GHReposAdditionalInfoView ()

@property (nonatomic, readonly) UILabel		*textLabel;

@end

@implementation GHReposAdditionalInfoView

+ (CGSize)sizeWithModel:(GHRepoAdditionalInfoModel *)infoModel width:(CGFloat)width {
	CGSize textSize = [infoModel.attributedString maSizeConstrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
	return textSize;
}

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_textLabel.numberOfLines = 0;
		_textLabel.backgroundColor =[UIColor clearColor];
		[self addSubview:_textLabel];
	}
	return self;
}

- (void)setInfoModel:(GHRepoAdditionalInfoModel *)infoModel {
	_infoModel = infoModel;
	self.textLabel.attributedText = infoModel.attributedString;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	self.textLabel.frame = self.bounds;
}

@end
