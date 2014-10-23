//
//  MBRequestOperationManager.m
//  ModulBank
//
//  Created by Andrew Kopanev on 8/31/14.
//  Copyright (c) 2014 Octoberry. All rights reserved.
//

#import "MBRequestOperationManager.h"

@implementation MBRequestOperationManager

- (AFHTTPRequestOperation *)scheduledHTTPRequestOperationWithRequest:(NSURLRequest *)request
															 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
															 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[self.delegate operationManager:self requestOperation:operation didFailWithError:error];
		if (failure) {
			failure(operation, error);
		}
	}];
	[self.operationQueue addOperation:operation];
	return operation;
}


@end
