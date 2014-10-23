//
//  GHLoadMoreModel.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHPageModel.h"

typedef NS_ENUM(NSInteger, GHLoadMoreStatus) {
	GHLoadMoreJustInitialized = 0,
	GHLoadMoreLoading,
	GHLoadMoreFailed
};

@interface GHLoadMoreModel : NSObject

@property (nonatomic, assign) GHLoadMoreStatus		status;

@end
