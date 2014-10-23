//
//  GHUsersViewController.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/7/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHUsersViewController.h"
#import "GHUsersView.h"
#import "MDWaitingView.h"
#import "MDErrorView.h"
#import "GHLoadMoreTableViewCell.h"
#import "GHUserTableViewCell.h"
#import "GHLoadMoreModel.h"

#import "GHCoreEngine.h"

#import "GHReposViewController.h"

#import <UIImageView+AFNetworking.h>

NSString *const GHUsersViewControllerUsersListNotification			= @"GHUsersViewControllerUsersListNotification";

@interface GHUsersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) GHUsersView			*usersView;
@property (nonatomic, strong) NSMutableArray		*menuList;

// paging
@property (nonatomic, strong) NSString				*nextLinkURLString;

@end

@implementation GHUsersViewController

#pragma mark - notifications

- (void)didReceiveUsersListNotification:(NSNotification *)notification {
	self.usersView.modalView = nil;
	[self.usersView.refreshControl endRefreshing];
	
	if (!NTF_ERROR(notification)) {
		NSDictionary *userInfo = NTF_USERINFO(notification);
		self.nextLinkURLString = userInfo[GHCoreEngineNextLink];

		[self updateMenuListWithUsers:NTF_RESULT(notification)];
	} else {
		if (!self.menuList.count) {
			self.usersView.modalView = [MDErrorView errorWithWithHint:NSLS(@"GENERAL_ERROR") errorHint:nil target:self action:@selector(errorViewTryAgainAction:)];
		} else {
			// update table view cell
			// I know it should be last in the list, but who knows what will we change in future
			[self reloadLoadMoreCellWithStatus:GHLoadMoreFailed];
		}
	}
}

#pragma mark - requests

- (void)requestUsers:(NSString *)nextLinkURLString {
	if (self.menuList.count == 0) {
		// seems like we should show modal wating view
		self.usersView.modalView = [MDWaitingView waitingViewWithHint:NSLS(@"GENERAL_PLEASE_WAIT")];
	}
	
	[[GHCoreEngine defaultEngine] apiUsersNextLink:nextLinkURLString notificationName:GHUsersViewControllerUsersListNotification];
}

#pragma mark - paging & items stuff

- (void)reloadLoadMoreCellWithStatus:(GHLoadMoreStatus)status {
	for (NSInteger i = 0; i < self.menuList.count; i++) {
		GHLoadMoreModel *moreModel = self.menuList[i];
		if ([moreModel isKindOfClass:[GHLoadMoreModel class]]) {
			moreModel.status = status;
			[self.usersView.tableView reloadRowsAtIndexPaths: @[ [NSIndexPath indexPathForRow:i inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
	}

}

- (void)loadNextUsersAndUpdateLoadMoreModel:(GHLoadMoreModel *)loadMoreModel {
	[self reloadLoadMoreCellWithStatus:GHLoadMoreLoading];
	[self requestUsers:self.nextLinkURLString];
}

- (void)userDidScrollToLoadMoreModel:(GHLoadMoreModel *)loadMoreModel {
	if (GHLoadMoreJustInitialized == loadMoreModel.status) {
		[self loadNextUsersAndUpdateLoadMoreModel:loadMoreModel];
	}
}

- (void)userDidSelectLoadMoreModel:(GHLoadMoreModel *)loadMoreModel {
	if (GHLoadMoreFailed == loadMoreModel.status) {
		[self loadNextUsersAndUpdateLoadMoreModel:loadMoreModel];
	}
}

- (void)updateMenuListWithUsers:(NSArray *)users {
	// TODO: implement empty state, ie when there are no users at all...
	if (!self.menuList) {
		self.menuList = [NSMutableArray array];
	}
	
	// remove current load more model
	NSUInteger indexToBeRemoved = NSNotFound;
	for (NSUInteger i = 0; i < self.menuList.count; i++) {
		GHLoadMoreModel *moreModel = self.menuList[i];
		if ([moreModel isKindOfClass:[GHLoadMoreModel class]]) {
			indexToBeRemoved = i;
			break;
		}
	}
	NSInteger countBefore = self.menuList.count;
	if (indexToBeRemoved != NSNotFound) {
		[self.menuList removeObjectAtIndex:indexToBeRemoved];
	}

	[self.menuList addObjectsFromArray:users];
	GHLoadMoreModel *loadMoreModel = [GHLoadMoreModel new];
	loadMoreModel.status = GHLoadMoreJustInitialized;
	[self.menuList addObject:loadMoreModel];
	
	NSInteger countAfter = self.menuList.count;
	if (countAfter > countBefore && countBefore > 0) {
		NSMutableArray *indexPaths = [NSMutableArray array];
		for (NSInteger i = countBefore; i < countAfter; i++) {
			[indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
		}
		[self.usersView.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
		if (indexToBeRemoved != NSNotFound) {
			[self.usersView.tableView reloadRowsAtIndexPaths: @[ [NSIndexPath indexPathForRow:indexToBeRemoved inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
		}
	} else {
		[self.usersView.tableView reloadData];
	}
}

#pragma mark - actions

- (void)showUserDetails:(GHUserModel *)userModel {
	[self.navigationController pushViewController:[[GHReposViewController alloc] initWithUserModel:userModel] animated:YES];
}

- (void)errorViewTryAgainAction:(UIButton *)sender {
	[self requestUsers:self.nextLinkURLString];
}

- (void)refreshAction:(UIControl *)sender {
	[self requestUsers:self.nextLinkURLString];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLS(@"USERS_VIEW_TITLE");
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

	// subscribe to notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveUsersListNotification:) name:GHUsersViewControllerUsersListNotification object:nil];
	
	// create interface
	_usersView = [[GHUsersView alloc] initWithFrame:self.view.bounds];
	_usersView.tableView.delegate = self;
	_usersView.tableView.dataSource = self;
	[_usersView.refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:_usersView];
	
	// request users list
	[self requestUsers:nil];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	CGFloat topMargin = 2.0;
	CGFloat top = topMargin + self.navigationController.navigationBar.bounds.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
	self.usersView.tableView.contentInset = UIEdgeInsetsMake(top, 0.0, 0.0, 0.0);
	self.usersView.tableView.scrollIndicatorInsets = self.usersView.tableView.contentInset;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.usersView.tableView deselectRowAtIndexPath:[self.usersView.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	id model = self.menuList[indexPath.row];
	if ([model isKindOfClass:[GHLoadMoreModel class]]) {
		GHLoadMoreTableViewCell *cell = (GHLoadMoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GHLoadMoreTableViewCell"];
		if (!cell) {
			cell = [[GHLoadMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GHLoadMoreTableViewCell"];
		}
		cell.loadMoreContentView.loadMoreModel = model;
		cell.selectionStyle =  cell.loadMoreContentView.loadMoreModel.status == GHLoadMoreFailed ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
		// do it after drawing...
		[self performSelector:@selector(userDidScrollToLoadMoreModel:) withObject:model afterDelay:0.01];
		return cell;
	} else if ([model isKindOfClass:[GHUserModel class]]) {
		GHUserTableViewCell *cell = (GHUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GHUserTableViewCell"];
		if (!cell) {
			cell = [[GHUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GHUserTableViewCell"];
		}
		cell.userModel = model;
		return cell;
	} else {
		return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id model = self.menuList[indexPath.row];
	if ([model isKindOfClass:[GHUserModel class]]) {
		[self showUserDetails:model];
	} else if ([model isKindOfClass:[GHLoadMoreModel class]]) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[self userDidSelectLoadMoreModel:model];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.menuList[indexPath.row] isKindOfClass:[GHLoadMoreModel class]]) {
		return GHLoadMoreContentViewHeight;
	} else {
		return GHUserTableViewCellHeight;
	}
}

@end
