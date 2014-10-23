//
//  GHUsersView.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "MDBaseView.h"

@interface GHUsersView : MDBaseView

@property (nonatomic, readonly) UIRefreshControl	*refreshControl;
@property (nonatomic, readonly) UITableView			*tableView;

@end
