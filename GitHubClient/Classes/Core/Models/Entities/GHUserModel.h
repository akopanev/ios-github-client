//
//  GHUserModel.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHBaseEntityModel.h"
/*
{
	"avatar_url" = "https://avatars.githubusercontent.com/u/129?v=2";
	"events_url" = "https://api.github.com/users/canadaduane/events{/privacy}";
	"followers_url" = "https://api.github.com/users/canadaduane/followers";
	"following_url" = "https://api.github.com/users/canadaduane/following{/other_user}";
	"gists_url" = "https://api.github.com/users/canadaduane/gists{/gist_id}";
	"gravatar_id" = "";
	"html_url" = "https://github.com/canadaduane";
	id = 129;
	login = canadaduane;
	"organizations_url" = "https://api.github.com/users/canadaduane/orgs";
	"received_events_url" = "https://api.github.com/users/canadaduane/received_events";
	"repos_url" = "https://api.github.com/users/canadaduane/repos";
	"site_admin" = 0;
	"starred_url" = "https://api.github.com/users/canadaduane/starred{/owner}{/repo}";
	"subscriptions_url" = "https://api.github.com/users/canadaduane/subscriptions";
	type = User;
	url = "https://api.github.com/users/canadaduane";
},
*/

@interface GHUserModel : GHBaseEntityModel

@property (nonatomic, strong) NSNumber		*userId;
@property (nonatomic, strong) NSString		*avatarUrl;
@property (nonatomic, strong) NSString		*login;

// these properties could be nil — depends on the API
@property (nonatomic, strong) NSDate		*createdAtDate;
@property (nonatomic, strong) NSString		*locationString;
@property (nonatomic, strong) NSString		*email;
@property (nonatomic, strong) NSString		*bio;
@property (nonatomic, strong) NSString		*name;
@property (nonatomic, strong) NSString		*company;

@property (nonatomic, assign, getter=isHireable) NSNumber			*hireable;

- (NSDictionary *)compactDictionaryRepresentation;

@end
