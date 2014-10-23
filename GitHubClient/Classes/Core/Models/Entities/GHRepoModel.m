//
//  GHRepoModel.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHRepoModel.h"

@implementation GHRepoModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super initWithDictionary:dictionary]) {
		self.repositoryName = dictionary[@"name"];
		self.language = dictionary[@"language"];
	}
	return self;
}

#pragma mark -

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: name == %@, language == %@>", [super description], self.repositoryName, self.language];
}

@end
