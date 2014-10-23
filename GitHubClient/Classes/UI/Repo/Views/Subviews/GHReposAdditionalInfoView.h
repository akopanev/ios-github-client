//
//  GHReposAdditionalInfoView.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHRepoAdditionalInfoModel.h"

@interface GHReposAdditionalInfoView : UIView

@property (nonatomic, strong) GHRepoAdditionalInfoModel		*infoModel;

+ (CGSize)sizeWithModel:(GHRepoAdditionalInfoModel *)infoModel width:(CGFloat)width;

@end
