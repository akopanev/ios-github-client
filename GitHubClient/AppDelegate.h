//
//  AppDelegate.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/7/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// kind of global navigation controller
// better to implement special view controller, but...
- (void)showUserDetails:(GHUserModel *)userModel;

@end

