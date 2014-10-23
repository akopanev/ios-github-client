//
//  GHUserTableViewCell.m
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "GHUserTableViewCell.h"
#import <UIImageView+AFNetworking.h>

const CGFloat GHUserTableViewCellHeight			= 44.0;

@implementation GHUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // ?
		
		self.textLabel.font = [UIFont fontWithName:[UIFont ghTitleFontName] size:16.0];
		// setup placeholder image becuase in other case cell doesn't draw an imaghe view
		self.imageView.image = [UIImage ghAvatarPlaceholderImage];
		self.imageView.contentMode = UIViewContentModeScaleAspectFill;
		
	}
	return self;
}

- (void)setUserModel:(GHUserModel *)userModel {
	if ([_userModel isEqual:userModel] == NO) {
		_userModel = userModel;
		
		self.textLabel.text = userModel.login;
		
		__block UIImageView *capturedImageView = self.imageView;
		[self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userModel.avatarUrl]]
							  placeholderImage:[UIImage ghAvatarPlaceholderImage]
									   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
										   capturedImageView.alpha = 0.0;
										   capturedImageView.image = image;
										   [UIView animateWithDuration:0.25 animations:^{
											   capturedImageView.alpha = 1.0;
										   }];
									   }
									   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
									   }];
		
	}
}

@end
