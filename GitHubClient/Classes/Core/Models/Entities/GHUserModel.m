//
//  GHUserModel.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHUserModel.h"

@implementation GHUserModel

+ (NSDateFormatter *)sharedDateFormatter {
	static NSDateFormatter *dateFormatter = nil;
	if (!dateFormatter) {
		dateFormatter = [[NSDateFormatter alloc] init];
		// 2008-01-14T04:33:35Z
		dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:SS'Z'";
	}
	return dateFormatter;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super initWithDictionary:dictionary]) {
		self.userId = dictionary[@"id"];
		self.avatarUrl = dictionary[@"avatar_url"];
		self.login = dictionary[@"login"];
		
		self.bio = dictionary[@"bio"];
		self.email = dictionary[@"email"];
		self.locationString = dictionary[@"location"];
		self.hireable = dictionary[@"hireable"];
		self.name = dictionary[@"name"];
		self.company = dictionary[@"company"];		
		self.createdAtDate = [[[self class] sharedDateFormatter] dateFromString:dictionary[@"created_at"]];
	}
	return self;
}

#pragma mark -

- (BOOL)isEqual:(GHUserModel *)object {
	return [object isKindOfClass:[self class]] && [object.userId isEqual:self.userId];
}

#pragma mark -

- (NSDictionary *)compactDictionaryRepresentation {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setValue:self.avatarUrl forKey:@"avatar_url"];
	[dictionary setValue:self.login forKey:@"login"];
	[dictionary setValue:self.userId forKey:@"id"];
	return dictionary;
}

@end
