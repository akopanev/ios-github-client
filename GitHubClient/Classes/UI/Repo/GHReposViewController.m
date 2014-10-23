//
//  GHReposViewController.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHReposViewController.h"
#import "GHReposView.h"
#import "MDWaitingView.h"
#import "MDErrorView.h"

@interface GHReposViewController ()

@property (nonatomic, readonly) GHReposView		*reposView;
@property (nonatomic, strong) GHUserModel		*userModel;

@end

@implementation GHReposViewController

#pragma mark - notifications

#pragma mark * names

- (NSString *)updatedUserModelNotificationName {
	return [NSString stringWithFormat:@"GHReposViewControllerUserNotification_%@", self.userModel.login];
}

- (NSString *)repositoriesNotificationName {
	return [NSString stringWithFormat:@"GHReposViewControllerRepositoriesNotification_%@", self.userModel.login];
}

- (NSString *)followersNotificationName {
	return [NSString stringWithFormat:@"GHReposViewControllerFollowersNotification_%@", self.userModel.login];
}

#pragma mark * handlers

- (void)updatedUserModelNotification:(NSNotification *)notification {
	if (!NTF_ERROR(notification)) {
		self.userModel = NTF_RESULT(notification);
		self.reposView.userModel = self.userModel;
		self.reposView.modalView = nil;
		
		[self requestAdditionalInformation];
	} else {
		self.reposView.modalView = [MDErrorView errorWithWithHint:NSLS(@"GENERAL_ERROR") errorHint:nil target:self action:@selector(requestUser)];
	}
}

- (void)userRepositoriesNotification:(NSNotification *)notification {
	if (!NTF_ERROR(notification)) {
		[self addRepositoriesInformation:NTF_RESULT(notification)];
	} else {
		// bad luck...
	}
	
	[[GHCoreEngine defaultEngine] apiUserFollowers:self.userModel.login notificationName:[self followersNotificationName]];
}

- (void)userFollowersNotification:(NSNotification *)notification {
	if (!NTF_ERROR(notification)) {
		[self addFollowersInformation:NTF_RESULT(notification)];
	} else {
		// bad luck...
	}
}

#pragma mark - requests

- (void)requestAdditionalInformation {
	// TODO: add waiting view
	[[GHCoreEngine defaultEngine] apiUserRepositories:self.userModel.login notificationName:[self repositoriesNotificationName]];
}

- (void)requestUser {
	self.reposView.modalView = [MDWaitingView waitingView];
	[[GHCoreEngine defaultEngine] apiUser:self.userModel.login notificationName:[self updatedUserModelNotificationName]];
}

#pragma mark - additional info

- (void)addRepositoriesInformation:(NSArray *)repositories {
	// puhhh...
	CGFloat fontSize = 14.0;
	NSString *title = [NSString stringWithFormat:@"%@: ", NSLS(@"USER_REPOSITORIES")];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
	[attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:[UIFont ghTitleFontName] size:fontSize] range:NSMakeRange(0, title.length)];
	
	if (repositories.count > 0) {
		for (NSInteger i = 0; i < repositories.count; i++) {
			GHRepoModel *repoModel = repositories[i];
			BOOL shouldAddComma = i < repositories.count - 1;
			[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:repoModel.repositoryName attributes: @{ NSFontAttributeName : [UIFont fontWithName:[UIFont ghInfoFontName] size:fontSize] } ]];
			if (repoModel.language.length) {
				NSString *langauageString = [NSString stringWithFormat:@" (%@)", repoModel.language];
				[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:langauageString attributes: @{ NSFontAttributeName : [UIFont fontWithName:[UIFont ghItalicFontName] size:fontSize] } ]];
			}
			
			if (shouldAddComma) {
				[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@", " attributes: @{ NSFontAttributeName : [UIFont fontWithName:[UIFont ghInfoFontName] size:fontSize] } ]];
			}
		}
	} else {
		[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:NSLS(@"USER_HAS_NO_REPOSITORIES") attributes: @{ NSFontAttributeName : [UIFont fontWithName:[UIFont ghItalicFontName] size:fontSize] } ]];
	}
	[self.reposView addAdditionalInfo: [GHRepoAdditionalInfoModel infoWithAttributedString:attributedString] ];
}

- (void)addFollowersInformation:(NSArray *)followers {
	// TODO: these methods are more or less the same, pls join them
	
	CGFloat fontSize = 14.0;
	NSString *title = [NSString stringWithFormat:@"%@: ", NSLS(@"USER_FOLLOWERS")];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
	[attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:[UIFont ghTitleFontName] size:fontSize] range:NSMakeRange(0, title.length)];
	
	if (followers.count > 0) {
		for (NSInteger i = 0; i < followers.count; i++) {
			GHUserModel *userModel = followers[i];
			BOOL shouldAddComma = i < followers.count - 1;
			[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:userModel.login attributes: @{ NSFontAttributeName : [UIFont fontWithName:[UIFont ghInfoFontName] size:fontSize] } ]];
			
			if (shouldAddComma) {
				[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@", " attributes: @{ NSFontAttributeName : [UIFont fontWithName:[UIFont ghInfoFontName] size:fontSize] } ]];
			}
		}
	} else {
		[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:NSLS(@"USER_HAS_NO_FOLLOWERS") attributes: @{ NSFontAttributeName : [UIFont fontWithName:[UIFont ghItalicFontName] size:fontSize] } ]];
	}
	[self.reposView addAdditionalInfo: [GHRepoAdditionalInfoModel infoWithAttributedString:attributedString] ];
}

#pragma mark - initialization

- (instancetype)initWithUserModel:(GHUserModel *)userModel {
	if (self = [super init]) {
		self.userModel = userModel;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = self.userModel.login;
	
	_reposView = [[GHReposView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:self.reposView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedUserModelNotification:) name:[self updatedUserModelNotificationName] object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRepositoriesNotification:) name:[self repositoriesNotificationName] object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowersNotification:) name:[self followersNotificationName] object:nil];
	
	[[GHCoreEngine defaultEngine] addRecentlyVieweUser:self.userModel];
	
	[self requestUser];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	CGFloat topMargin = 0.0;
	CGFloat top = topMargin + self.navigationController.navigationBar.bounds.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
	self.reposView.scrollView.contentInset = self.reposView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0.0, 0.0, 0.0);
}

@end
