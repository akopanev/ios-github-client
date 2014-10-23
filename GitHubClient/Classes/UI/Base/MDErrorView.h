//
//  MDErrorView.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDErrorView : UIView

+ (instancetype)errorWithWithHint:(NSString *)hint target:(id)target action:(SEL)action;
+ (instancetype)errorWithWithHint:(NSString *)hint errorHint:(NSString *)errorHint target:(id)target action:(SEL)action;

@property (nonatomic, readonly) UILabel			*hintLabel;
@property (nonatomic, readonly) UILabel			*errorHintLabel;
@property (nonatomic, readonly) UIButton		*tryAgainButton;

@end
