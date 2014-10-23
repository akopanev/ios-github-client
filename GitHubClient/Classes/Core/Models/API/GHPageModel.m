//
//  GHPageModel.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHPageModel.h"

@implementation GHPageModel

+ (instancetype)modelWithIndex:(NSInteger)index limit:(NSInteger)limit {
	GHPageModel *model = [self new];
	model.index = index;
	model.limit = limit;
	return model;
}

@end
