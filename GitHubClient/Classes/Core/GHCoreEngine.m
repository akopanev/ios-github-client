//
//  GHCoreEngine.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHCoreEngine.h"
#import "MBRequestOperationManager.h"
#import "MBResponseSerializer.h"

// keys
NSString *const GHCoreEngineNextLink			= @"nextLink";
NSString *const GHCoreEngineCurrentLink			= @"currentLink";

// API constants
NSString *const MBCoreEngineAPIURL			= @"https://api.github.com";

// notifications
NSString *const GHCoreEngineRecentlyViewedUsersDidChangeNotificaton		= @"GHCoreEngineRecentlyViewedUsersDidChangeNotificaton";

// recently constants
const NSInteger GHCoreEngineMaxRecentlyUsersCount		= 5;

#define MB_API_URL(x)				[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MBCoreEngineAPIURL,x]]
#define MB_API_URL_STRING(x)		[NSString stringWithFormat:@"%@/%@", MBCoreEngineAPIURL,x]


@interface GHCoreEngine ()

@property (nonatomic, strong) MBRequestOperationManager		*requestManager;
@property (nonatomic, strong) NSMutableArray				*innerRecentlyViewedUsers;

@end

@implementation GHCoreEngine

+ (instancetype)defaultEngine {
	static dispatch_once_t predicate;
	static id sharedInstance = nil;
	dispatch_once(&predicate, ^{
		sharedInstance = [self new];
	});
	return sharedInstance;
}

#pragma mark - notifications

- (void)applicationWillResignActiveNotification:(NSNotification *)notification {
	[self dumpRecentlyViewedUsers];
}

#pragma mark -

- (id)init {
	if (self = [super init]) {
		self.requestManager = [MBRequestOperationManager new];
		self.requestManager.responseSerializer = [MBResponseSerializer serializer];
		self.requestManager.operationQueue.maxConcurrentOperationCount = 5;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - helpers

- (NSString *)nextLinkFromLinkHeader:(NSString *)linkHeaderValue {
	NSArray *pairs = [linkHeaderValue componentsSeparatedByString:@","];
	for (NSString *pair in pairs) {
		NSArray *subpairs = [pair componentsSeparatedByString:@";"];
		if (subpairs.count == 2 && [subpairs[1] rangeOfString:@"next"].location != NSNotFound) {
			return [subpairs[0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
		}
	}
	return nil;
}

#pragma mark - APIs

#pragma mark * helpers

- (NSMutableArray *)arrayFromResponse:(NSArray *)response class:(Class)class {
	NSMutableArray *array = [NSMutableArray array];
	if ([response isKindOfClass:[NSArray class]]) {
		for (NSDictionary *d in response) {
			[array maAddObject:[[class alloc] initWithDictionary:d]];
		}
	}
	return array;
}

#pragma mark * users

- (void)apiUsersNextLink:(NSString *)nextLink notificationName:(NSString *)noticationName {
	NSString *apiURLString = nextLink ?: MB_API_URL_STRING(@"users");

	NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
	[userInfo setValue:nextLink forKey:GHCoreEngineCurrentLink];
	
	[self.requestManager GET:apiURLString
				  parameters:nil
					 success:^(AFHTTPRequestOperation *operation, id responseObject) {
						 [userInfo setValue:[self nextLinkFromLinkHeader:operation.response.allHeaderFields[@"Link"]] forKey:GHCoreEngineNextLink];
						 [[NSNotificationCenter defaultCenter] maSendNotificationNamed:noticationName object:self result:[self arrayFromResponse:responseObject class:[GHUserModel class]] error:nil userInfo:userInfo];
				  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					  [[NSNotificationCenter defaultCenter] maSendNotificationNamed:noticationName object:self result:nil error:error userInfo:userInfo];
				  }];
}

- (void)apiUser:(NSString *)username notificationName:(NSString *)noticationName {
	NSString *apiURLString = [NSString stringWithFormat:@"users/%@", username];
	[self.requestManager GET:MB_API_URL_STRING(apiURLString)
				  parameters:nil
					 success:^(AFHTTPRequestOperation *operation, id responseObject) {						 
						 [[NSNotificationCenter defaultCenter] maSendNotificationNamed:noticationName object:self result:[[GHUserModel alloc] initWithDictionary:responseObject] error:nil userInfo:username];
				  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					  [[NSNotificationCenter defaultCenter] maSendNotificationNamed:noticationName object:self result:nil error:error userInfo:username];
				  }];
}

- (void)apiSearchUsers:(NSString *)query notificationName:(NSString *)noticationName {
	NSString *apiURLString = [NSString stringWithFormat:@"search/users?q=%@", [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self.requestManager GET:MB_API_URL_STRING(apiURLString)
				  parameters:nil
					 success:^(AFHTTPRequestOperation *operation, id responseObject) {
						 [[NSNotificationCenter defaultCenter] maSendNotificationNamed:noticationName object:self result:[self arrayFromResponse:responseObject[@"items"] class:[GHUserModel class]] error:nil userInfo:query];
				  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					  [[NSNotificationCenter defaultCenter] maSendNotificationNamed:noticationName object:self result:nil error:error userInfo:query];
				  }];
}

#pragma mark * repos

- (void)apiUserRepositories:(NSString *)username notificationName:(NSString *)noticationName {
	NSString *apiURLString = [NSString stringWithFormat:@"users/%@/repos", username];
	[self.requestManager GET:MB_API_URL_STRING(apiURLString)
				  parameters:nil
					 success:^(AFHTTPRequestOperation *operation, id responseObject) {
						 [[NSNotificationCenter defaultCenter] maSendNotificationNamed:noticationName object:self result:[self arrayFromResponse:responseObject class:[GHRepoModel class]] error:nil userInfo:username];
				  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					  [[NSNotificationCenter defaultCenter] maSendNotificationNamed:noticationName object:self result:nil error:error userInfo:username];
				  }];
}

- (void)apiUserFollowers:(NSString *)username notificationName:(NSString *)noticationName {
	NSString *apiURLString = [NSString stringWithFormat:@"users/%@/followers", username];
	[self.requestManager GET:MB_API_URL_STRING(apiURLString)
				  parameters:nil
					 success:^(AFHTTPRequestOperation *operation, id responseObject) {
						 [[NSNotificationCenter defaultCenter] maSendNotificationNamed:noticationName object:self result:[self arrayFromResponse:responseObject class:[GHUserModel class]] error:nil userInfo:username];
				  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					  [[NSNotificationCenter defaultCenter] maSendNotificationNamed:noticationName object:self result:nil error:error userInfo:username];
				  }];
}

#pragma mark - recently viewed

- (void)dumpRecentlyViewedUsers {
	NSMutableArray *serializedUsers = [NSMutableArray array];
	for (GHUserModel *userModel in self.innerRecentlyViewedUsers) {
		[serializedUsers addObject:[userModel compactDictionaryRepresentation]];
	}
	[[NSUserDefaults standardUserDefaults] setValue:serializedUsers forKey:@"GHRecentlyViewedUsers"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)innerRecentlyViewedUsers {
	if (!_innerRecentlyViewedUsers) {
		_innerRecentlyViewedUsers = [NSMutableArray array];
		NSArray *serialized = [[NSUserDefaults standardUserDefaults] objectForKey:@"GHRecentlyViewedUsers"];
		if (serialized.count) {
			for (NSDictionary *dict in serialized) {
				GHUserModel *userModel = [[GHUserModel alloc] initWithDictionary:dict];
				[_innerRecentlyViewedUsers addObject:userModel];
			}
		}
	}
	return _innerRecentlyViewedUsers;
}

- (NSArray *)recentlyViewedUsers {
	return [NSArray arrayWithArray:self.innerRecentlyViewedUsers];
}

- (void)addRecentlyVieweUser:(GHUserModel *)userModel {
	if (userModel) {
		NSUInteger index = [self.innerRecentlyViewedUsers indexOfObject:userModel];
		if (NSNotFound == index) {
			// new user, add
			[self.innerRecentlyViewedUsers insertObject:userModel atIndex:0];
			if (self.innerRecentlyViewedUsers.count > GHCoreEngineMaxRecentlyUsersCount) {
				[self.innerRecentlyViewedUsers removeObjectsInRange:NSMakeRange(GHCoreEngineMaxRecentlyUsersCount, self.innerRecentlyViewedUsers.count - GHCoreEngineMaxRecentlyUsersCount)];
			}
		} else if (index > 0) {
			// already exists, put to the top
			[self.innerRecentlyViewedUsers removeObjectAtIndex:index];
			[self.innerRecentlyViewedUsers insertObject:userModel atIndex:0];
		}
		
		if (index != 0) {
			[[NSNotificationCenter defaultCenter] maSendNotificationNamed:GHCoreEngineRecentlyViewedUsersDidChangeNotificaton object:self result:[self recentlyViewedUsers]];
		}
	}
}


@end
