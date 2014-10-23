//
//  GHCoreEngine.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <Foundation/Foundation.h>

// keys
extern NSString *const GHCoreEngineNextLink;
extern NSString *const GHCoreEngineCurrentLink;

// notifications
extern NSString *const GHCoreEngineRecentlyViewedUsersDidChangeNotificaton;

@interface GHCoreEngine : NSObject

+ (instancetype)defaultEngine;

// API methods
// next link could be nil
// userInfo contains following information:
// GHCoreEngineNextLink — next link (NSString)
// GHCoreEngineCurrentLink - requst link (NSString)
- (void)apiUsersNextLink:(NSString *)nextLink notificationName:(NSString *)noticationName;

// userInfo contains username (NSString)
- (void)apiUser:(NSString *)username notificationName:(NSString *)noticationName;

// userInfo contains query (NSString)
- (void)apiSearchUsers:(NSString *)query notificationName:(NSString *)noticationName;

// userInfo contains username (NSString)
- (void)apiUserRepositories:(NSString *)userName notificationName:(NSString *)noticationName;

// userInfo contains username (NSString)
- (void)apiUserFollowers:(NSString *)userName notificationName:(NSString *)noticationName;

// other stuff
- (NSArray *)recentlyViewedUsers;
- (void)addRecentlyVieweUser:(GHUserModel *)userModel;

@end
