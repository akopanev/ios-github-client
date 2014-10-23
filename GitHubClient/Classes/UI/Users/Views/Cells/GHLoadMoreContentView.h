//
//  GHLoadMoreContentView.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHLoadMoreModel.h"

extern const CGFloat GHLoadMoreContentViewHeight;

@interface GHLoadMoreContentView : UIView

@property (nonatomic, strong) GHLoadMoreModel		*loadMoreModel;

@end
