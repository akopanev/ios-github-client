//
//  GHLoadMoreTableViewCell.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHLoadMoreTableViewCell.h"

@implementation GHLoadMoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		_loadMoreContentView = [[GHLoadMoreContentView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:self.loadMoreContentView];
	}
	return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	self.loadMoreContentView.frame = self.contentView.bounds;
}
@end
