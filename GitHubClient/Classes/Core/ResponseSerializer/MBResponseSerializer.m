//
//  MBResponseSerializer.m
//  ModulBank
//
//  Created by Andrew Kopanev on 8/31/14.
//  Copyright (c) 2014 Octoberry. All rights reserved.
//

#import "MBResponseSerializer.h"

NSString *const MBAPIErrorDomain				= @"MBAPIErrorDomain";
NSString *const MBParsingErrorDomain			= @"MBParsingErrorDomain";


@implementation MBResponseSerializer

- (instancetype)init {
    self = [super init];
    if (self) {
		self.removesKeysWithNullValues = YES;
    }
    return self;
}

#pragma mark -

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
	id responseObject = [super responseObjectForResponse:response data:data error:error];
#ifdef DEBUG
	// NSLog(@"%s response == %@", __PRETTY_FUNCTION__, responseObject);
#endif
	id result = nil;
	if (!*error) {
		if (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]]) {
			*error = [NSError maErrorWithDomain:MBParsingErrorDomain code:MBErrorGeneral localizedDescription:NSLS(@"ERROR_PARSING_BAD_JSON")];
		} else {
			result = responseObject;
		}
	}
	return result;
}

- (BOOL)validateResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
	BOOL isValid = [super validateResponse:response data:data error:error];
	if (!isValid) {
		/*
		NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:self.readingOptions error:nil];
		if ([responseDictionary isKindOfClass:[NSDictionary class]]) {
			
			NSLog(@"%s %@ response == %@", __PRETTY_FUNCTION__, response.URL.path, responseDictionary);
			
			id responseMessage = [responseDictionary objectForKey:@"message"];
			if ([responseMessage isKindOfClass:[NSArray class]]) {
				responseMessage = [responseMessage firstObject];
			}
			
			NSString *errorValue = [responseMessage isKindOfClass:[NSString class]] ? responseMessage : nil;
			
			NSString *message = responseMessage ? [NSString stringWithFormat:@"%@", responseMessage] : [(*error) localizedDescription];
			if (!message) {
				message = [NSString stringWithFormat:@"json == %@", responseDictionary];
			}
			*error = [NSError maErrorWithDomain:MBAPIErrorDomain code:[responseDictionary[@"status"] intValue] localizedDescription:message];
			// (*error).mbErrorValue = errorValue;
		}
		 */
	}
	return isValid;
}

@end
