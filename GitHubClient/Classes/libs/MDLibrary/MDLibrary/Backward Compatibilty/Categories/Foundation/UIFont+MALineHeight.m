//
//  UIFont+MALineHeight.m
//  Nastenka
//
//  Created by Sergey Ryazanov on 24.06.14.
//  Copyright (c) 2014 moqod. All rights reserved.
//

#import "UIFont+MALineHeight.h"

@implementation UIFont (MALineHeight)

- (CGFloat)maLineHeight {
    return ceilf(self.lineHeight);
}

@end
