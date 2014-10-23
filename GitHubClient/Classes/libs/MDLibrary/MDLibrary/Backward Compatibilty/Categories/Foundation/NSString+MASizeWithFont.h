//
//  NSString+SizeWithAppFont.h
//  MALibrary
//
//  Created by Sergey on 9/23/13.
//  Copyright (c) 2013 moqod. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Category adds backward compatibility for `sizeWithFont:` method.
 */

@interface NSString (MASizeWithFont)

- (CGSize)maSizeWithFont:(UIFont *)font;

- (CGSize)maSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)maSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)maSizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end