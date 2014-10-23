//
//  GHRepoAdditonalInfoModel.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHRepoAdditionalInfoModel.h"

@implementation GHRepoAdditionalInfoModel

+ (instancetype)infoWithAttributedString:(NSAttributedString *)attributedString {
	GHRepoAdditionalInfoModel *model = [self new];
	model.attributedString = attributedString;
	return model;
}

@end
