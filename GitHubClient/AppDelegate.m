//
//  AppDelegate.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/7/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "AppDelegate.h"

#import <PKRevealController.h>
#import "GHUsersViewController.h"
#import "GHSidebarViewController.h"
#import "GHReposViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController	*navigationController;
@property (nonatomic, strong) GHUsersViewController		*usersViewController;
@property (nonatomic, strong) PKRevealController		*revealViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	
	[[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
	
	self.usersViewController = [GHUsersViewController new];
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.usersViewController];
	self.revealViewController = [PKRevealController revealControllerWithFrontViewController:self.navigationController leftViewController:[GHSidebarViewController new]];
	self.window.rootViewController = self.revealViewController;
	[self.window makeKeyAndVisible];
	return YES;
}

#pragma mark -

- (void)showUserDetails:(GHUserModel *)userModel {
	GHReposViewController *reposViewController = [[GHReposViewController alloc] initWithUserModel:userModel];
	[self.navigationController setViewControllers: @[self.usersViewController, reposViewController] animated: YES ];
	if (self.revealViewController.focusedController != self.navigationController) {
		[self.revealViewController showViewController:self.navigationController];
	}
}

@end
