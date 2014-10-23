//
//  GHSidebarViewController.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/7/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHSidebarViewController.h"
#import "GHSideBarView.h"
#import "GHUserTableViewCell.h"

#import "AppDelegate.h"

NSString *const GHSidebarViewControllerUsersSearchNotification			= @"GHSidebarViewControllerUsersSearchNotification";

const NSInteger GHSidebarViewControllerSearchSymbolsCount				= 3;

typedef NS_ENUM(NSInteger, GHSidebarViewMode) {
	GHSidebarViewModeRecentlyViewed = 1,
	GHSidebarViewModeSearch
};

@interface GHSidebarViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, readonly) GHSideBarView		*sideBarView;
@property (nonatomic, strong) NSArray				*menuList;
@property (nonatomic, assign) GHSidebarViewMode		viewMode;

@end

@implementation GHSidebarViewController

#pragma mark - notifications

#pragma mark * recently

- (void)recentlyViewedUsersChangedNotification:(NSNotification *)notification {
	/*
	if (GHSidebarViewModeRecentlyViewed == self.viewMode) {
		self.menuList = NTF_RESULT(notification);
		[self.sideBarView.tableView reloadData];
	}
	 */
}

#pragma mark * search

- (void)usersSearchNotification:(NSNotification *)notification {
	NSString *query = NTF_USERINFO(notification);
	if (self.viewMode == GHSidebarViewModeSearch && [self.sideBarView.searchBar.text isEqualToString:query]) {
		if (!NTF_ERROR(notification)) {
			self.menuList = NTF_RESULT(notification);
			[self.sideBarView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
		} else {
			// TODO: show error
			NSLog(@"%s error == %@", __PRETTY_FUNCTION__, NTF_ERROR(notification));
		}
	}
}

#pragma mark * keyboard

- (void)keyboardDidAppearNotification:(NSNotification *)notification {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	CGRect localKeyboardRect = [self.sideBarView convertRect:keyboardRect fromView:nil];
	CGFloat tableViewMaxY = CGRectGetMaxY(self.sideBarView.tableView.frame);
	if (tableViewMaxY > CGRectGetMinY(localKeyboardRect)) {
		self.sideBarView.tableView.contentInset = self.sideBarView.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, tableViewMaxY - CGRectGetMinY(localKeyboardRect), 0.0);
	}
}

- (void)keyboardWillDisappearNotification:(NSNotification *)notification {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	self.sideBarView.tableView.contentInset = self.sideBarView.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}


#pragma mark - requests

- (void)requestUsersSearch:(NSString *)query {
	[[GHCoreEngine defaultEngine] apiSearchUsers:query notificationName:GHSidebarViewControllerUsersSearchNotification];
}

#pragma mark -

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_sideBarView = [[GHSideBarView alloc] initWithFrame:self.view.bounds];
	self.sideBarView.tableView.delegate = self;
	self.sideBarView.tableView.rowHeight = GHUserTableViewCellHeight;
	[self.sideBarView.tableView registerClass:[GHUserTableViewCell class] forCellReuseIdentifier:@"GHUserTableViewCell"];
	self.sideBarView.tableView.dataSource = self;
	self.sideBarView.searchBar.delegate = self;
	[self.view addSubview:self.sideBarView];
	
	self.viewMode = GHSidebarViewModeRecentlyViewed;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recentlyViewedUsersChangedNotification:) name:GHCoreEngineRecentlyViewedUsersDidChangeNotificaton object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usersSearchNotification:) name:GHSidebarViewControllerUsersSearchNotification object:nil];
	// [self requestUsersSearch:@"akopa"];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.view maFindAndResignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.viewMode == GHSidebarViewModeRecentlyViewed) {
		self.menuList = [[GHCoreEngine defaultEngine] recentlyViewedUsers];
		[self.sideBarView.tableView reloadData];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppearNotification:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappearNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -

- (void)setViewMode:(GHSidebarViewMode)viewMode {
	if (_viewMode != viewMode) {
		_viewMode = viewMode;
		
		if (self.viewMode == GHSidebarViewModeSearch) {
			self.menuList = [NSArray array];
		} else {
			self.menuList = [[GHCoreEngine defaultEngine] recentlyViewedUsers];
			/*
			 NSMutableArray *array = [NSMutableArray array];
			 for (int i = 0; i < 234; i++) {
			 [array addObjectsFromArray:self.menuList];
			 }
			 self.menuList = array;
			 */
		}
		[self.sideBarView.tableView reloadData];
	}
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	GHUserTableViewCell *cell = (GHUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GHUserTableViewCell" forIndexPath:indexPath];
	if (!cell) {
		cell = [[GHUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GHUserTableViewCell"];
	}
	cell.userModel = self.menuList[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate showUserDetails:self.menuList[indexPath.row]];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	if (searchBar.text.length > 0) {
		self.viewMode = GHSidebarViewModeSearch;
		[self requestUsersSearch:searchBar.text];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	self.viewMode = GHSidebarViewModeRecentlyViewed;
	[self.view maFindAndResignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if (searchText.length >= GHSidebarViewControllerSearchSymbolsCount) {
		self.viewMode = GHSidebarViewModeSearch;
		[self requestUsersSearch:searchText];
	}
}


@end
