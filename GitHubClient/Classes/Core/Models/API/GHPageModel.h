//
//  GHPageModel.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHBaseModel.h"

@interface GHPageModel : GHBaseModel

@property (nonatomic, assign) NSInteger			index;
@property (nonatomic, assign) NSInteger			limit;

+ (instancetype)modelWithIndex:(NSInteger)index limit:(NSInteger)limit;

@end
