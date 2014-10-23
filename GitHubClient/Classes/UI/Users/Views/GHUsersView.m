//
//  GHUsersView.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHUsersView.h"

@implementation GHUsersView

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero];
		_tableView.separatorColor = [UIColor lightGrayColor];
		[self addSubview:_tableView];
		
		/*
		_refreshControl = [[UIRefreshControl alloc] init];
		[_tableView addSubview:_refreshControl];
		 */
	}
	return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	self.tableView.frame = self.bounds;
}

@end
