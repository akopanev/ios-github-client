//
//  GHReposViewController.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "MDBaseViewController.h"
#import "GHUserModel.h"

@interface GHReposViewController : MDBaseViewController

- (instancetype)initWithUserModel:(GHUserModel *)userModel;

@end
