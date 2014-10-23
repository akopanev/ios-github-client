//
//  GHReposHeaderView.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHUserModel.h"

@interface GHReposHeaderView : UIView

@property (nonatomic, strong) GHUserModel		*userModel;

+ (CGSize)sizeWithModel:(GHUserModel *)userModel width:(CGFloat)width;

@end
