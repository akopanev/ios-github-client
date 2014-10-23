//
//  GHLoadMoreTableViewCell.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHLoadMoreContentView.h"

@interface GHLoadMoreTableViewCell : UITableViewCell

@property (nonatomic, readonly) GHLoadMoreContentView		*loadMoreContentView;

@end
