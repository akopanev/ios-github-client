//
//  GHReposHeaderView.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHReposHeaderView.h"

/*
 @property (nonatomic, strong) NSNumber		*userId;
 @property (nonatomic, strong) NSString		*avatarUrl;
 @property (nonatomic, strong) NSString		*login;
 
 // these properties could be nil — depends on the API
 @property (nonatomic, strong) NSDate		*createdAtDate;
 @property (nonatomic, strong) NSString		*locationString;
 @property (nonatomic, strong) NSString		*email;
 @property (nonatomic, strong) NSString		*bio;
 @property (nonatomic, assign, getter=isHireable) NSNumber			*hireable;
 */

const CGFloat GHReposHeaderViewOffsetBetweenLabels			= 0.0;
const CGFloat GHReposHeaderViewSeparatorHeight				= 8.0;

@interface GHReposHeaderView ()

@property (nonatomic, readonly) UIView				*separatorView;

@end

@implementation GHReposHeaderView

+ (CGSize)sizeWithModel:(GHUserModel *)userModel width:(CGFloat)width {
	// setup labels
	CGFloat currentHeight = 0.0;
	for (NSDictionary *mapping in [[self class] propertiesMappingList]) {
		NSAttributedString *attributedString = [[self class] attributedStringForMapping:mapping model:userModel];
		if (attributedString) {
			CGSize size = [attributedString maSizeConstrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
			currentHeight += size.height + GHReposHeaderViewOffsetBetweenLabels;
		}
	}
	return CGSizeMake(width, currentHeight + GHReposHeaderViewSeparatorHeight);
}

+ (NSArray *)propertiesMappingList {
	NSMutableArray *array = [NSMutableArray arrayWithObjects:
							 @{ @"name" : NSLS(@"USER_NAME") },
							 @{ @"company" : NSLS(@"COMPANY") },
							 @{ @"createdAtDate" : NSLS(@"MEMBER_SINCE") },
							 @{ @"locationString" : NSLS(@"LOCATION") },
							 @{ @"email" : NSLS(@"EMAIL") },
							 @{ @"hireable" : NSLS(@"HIREABLE") },
							 @{ @"bio" : NSLS(@"USER_BIO") },
							 nil];
	return array;
}

+ (NSString *)stringForValue:(id)value {
	if ([value isKindOfClass:[NSString class]]) {
		return value;
	} else if ([value isKindOfClass:[NSNumber class]]) {
		// TODO: there could be also digits, not boolean values
		return [value boolValue] ? NSLS(@"YES") : NSLS(@"NO");
	} else if ([value isKindOfClass:[NSDate class]]) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		// well, we use current locale but the app uses russian localization only
		// so force formatter to be russian :)
		[formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ru"]];
		[formatter setDateStyle:NSDateFormatterFullStyle];
		return [[formatter stringFromDate:value] capitalizedString];
	} else {
		return [NSString stringWithFormat:@"%@", value];
	}
}

+ (NSAttributedString *)attributedStringForMapping:(NSDictionary *)mapping model:(NSObject *)model {
	// TODO: if we will add more than one key then it must be reviewed
	NSString *key = [[mapping allKeys] firstObject];
	
	id value = key ? [model valueForKey:key] : nil;
	if (value) {
		NSString *title = mapping[key]; //[NSString stringWithFormat:@"%@:", mapping[key]];
		NSString *info = [self stringForValue:value];
		
		CGFloat fontSize = 14.0;
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", title, info]];
		[attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:[UIFont ghTitleFontName] size:fontSize] range:NSMakeRange(0, title.length)];
		[attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:[UIFont ghInfoFontName] size:fontSize] range:NSMakeRange(title.length, attributedString.string.length - title.length)];
		return attributedString;
	} else {
		return nil;
	}
}

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	}
	return self;
}

- (void)setUserModel:(GHUserModel *)userModel {
	_userModel = userModel;
	
	[self maRemoveAllSubviews];
	
	// setup labels
	for (NSDictionary *mapping in [[self class] propertiesMappingList]) {
		NSAttributedString *attributedString = [[self class] attributedStringForMapping:mapping model:self.userModel];
		if (attributedString) {
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.numberOfLines = 0;
			label.attributedText = attributedString;
			[self addSubview:label];
		}
	}
	
	_separatorView = [[UIView alloc] initWithFrame:CGRectZero];
	_separatorView.backgroundColor = [UIColor grayColor];
	[self addSubview:_separatorView];
	
	[self setNeedsLayout];
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat currentY = 0.0;
	for (UILabel *label in self.subviews) {
		if ([label isKindOfClass:[UILabel class]]) {
			CGSize labelSize = [label.attributedText maSizeConstrainedToSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
			label.frame = CGRectMake(0.0, currentY, labelSize.width, labelSize.height);
			currentY = CGRectGetMaxY(label.frame) + GHReposHeaderViewOffsetBetweenLabels;
		}
	}
	
	CGFloat separatorHeight = 1.0 / [[UIScreen mainScreen] scale];
	_separatorView.frame = CGRectMake(0.0, self.bounds.size.height - separatorHeight, self.bounds.size.width, separatorHeight);
}

@end
