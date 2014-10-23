//
//  MDWaitingView.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDWaitingView : UIView

@property (nonatomic, readonly) UIActivityIndicatorView			*activityIndicatorView;
@property (nonatomic, readonly) UILabel							*hintLabel;

+ (instancetype)waitingView;
+ (instancetype)waitingViewWithHint:(NSString *)hint;

@end
