//
//  GHSideBarView.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "MDBaseView.h"

@interface GHSideBarView : MDBaseView

@property (nonatomic, readonly) UISearchBar		*searchBar;
@property (nonatomic, readonly) UITableView		*tableView;

@end
