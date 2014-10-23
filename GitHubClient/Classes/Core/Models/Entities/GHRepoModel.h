//
//  GHRepoModel.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHBaseEntityModel.h"

@interface GHRepoModel : GHBaseEntityModel

@property (nonatomic, strong) NSString		*repositoryName;
@property (nonatomic, strong) NSString		*language;

@end
