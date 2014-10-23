//
//  GHReposView.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "MDBaseView.h"
#import "GHUserModel.h"
#import "GHRepoAdditionalInfoModel.h"

@interface GHReposView : MDBaseView

@property (nonatomic, readonly) UIScrollView	*scrollView;
@property (nonatomic, strong) GHUserModel		*userModel;

- (void)addAdditionalInfo:(GHRepoAdditionalInfoModel *)additionalInfoModel;

@end
