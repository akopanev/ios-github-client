//
//  GHUserViewController.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHUserViewController.h"
#import "GHUserView.h"

@interface GHUserViewController ()

@property (nonatomic, strong) GHUserModel		*userModel;
@property (nonatomic, readonly) GHUserView		*userView;

@end

@implementation GHUserViewController

#pragma mark - notifications



#pragma mark - requests



#pragma mark - initialization

- (id)initWithUser:(GHUserModel *)userModel {
	if (self = [super init]) {
		self.userModel = userModel;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_userView = [[GHUserView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:self.userView];
}

@end
