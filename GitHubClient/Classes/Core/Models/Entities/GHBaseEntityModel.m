//
//  GHBaseEntityModel.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHBaseEntityModel.h"

@implementation GHBaseEntityModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (NO == [dictionary isKindOfClass:[NSDictionary class]]) {
		return nil;
	} else {
		self = [super init];
		return self;
	}
}

@end
