//
//  GHSideBarView.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHSideBarView.h"

@implementation GHSideBarView

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor whiteColor];
		
		_searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
		self.searchBar.tintColor = [UIColor grayColor];
		self.searchBar.barTintColor = [UIColor whiteColor];
		self.searchBar.placeholder = NSLS(@"SEARCHBAR_PLACEHOLDER");
		self.searchBar.showsCancelButton = YES;
		[self addSubview:_searchBar];
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero];
		self.tableView.tableFooterView = [UIView new];
		[self addSubview:self.tableView];
	}
	return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	
	// magic value
	// have to review PKReveal, becuase it doesn't provide view with correct frame
	const CGFloat actualWidth = 260.0;
	const CGFloat horizontalMargin = 10.0;
	const CGFloat verticalMargin = 10.0;
	
	self.searchBar.frame = CGRectMake(horizontalMargin, verticalMargin + [[UIApplication sharedApplication] statusBarFrame].size.height, actualWidth - horizontalMargin * 2.0, 40.0);
	
	CGFloat tableY = CGRectGetMaxY(self.searchBar.frame) + 5.0;
	self.tableView.frame = CGRectMake(horizontalMargin, tableY, actualWidth - horizontalMargin * 1.0, self.bounds.size.height - tableY);
}

@end
