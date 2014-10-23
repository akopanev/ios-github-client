//
//  MBRequestOperationManager.h
//  ModulBank
//
//  Created by Andrew Kopanev on 8/31/14.
//  Copyright (c) 2014 Octoberry. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@class MBRequestOperationManager;
@protocol MBRequestOperationManagerDelegate <NSObject>

- (BOOL)operationManager:(MBRequestOperationManager *)manager requestOperation:(AFHTTPRequestOperation *)operation didFailWithError:(NSError *)error;

@end

@interface MBRequestOperationManager : AFHTTPRequestOperationManager

@property (nonatomic, assign) id <MBRequestOperationManagerDelegate>delegate;

- (AFHTTPRequestOperation *)scheduledHTTPRequestOperationWithRequest:(NSURLRequest *)request
															 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
															 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
