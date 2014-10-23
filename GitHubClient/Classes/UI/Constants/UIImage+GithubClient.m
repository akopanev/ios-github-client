//
//  UIImahe+GithubClient.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "UIImage+GithubClient.h"
#import "GHUserTableViewCell.h"

@implementation UIImage (GitHubClient)

+ (UIImage *)ghAvatarPlaceholderImage {
	static UIImage *placeholderImage = nil;
	if (!placeholderImage) {
		const CGFloat imageSize = GHUserTableViewCellHeight;
		placeholderImage = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, imageSize, imageSize - 1.0)] maShapshot];
	}
	return placeholderImage;
}

@end
