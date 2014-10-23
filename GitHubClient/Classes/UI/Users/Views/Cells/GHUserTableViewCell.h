//
//  GHUserTableViewCell.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHUserModel.h"

extern const CGFloat GHUserTableViewCellHeight;

@interface GHUserTableViewCell : UITableViewCell

@property (nonatomic, strong) GHUserModel		*userModel;

@end
