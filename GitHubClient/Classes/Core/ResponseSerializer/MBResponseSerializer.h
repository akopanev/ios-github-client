//
//  MBResponseSerializer.h
//  ModulBank
//
//  Created by Andrew Kopanev on 8/31/14.
//  Copyright (c) 2014 Octoberry. All rights reserved.
//

#import "AFURLResponseSerialization.h"

// errors
extern NSString *const MBAPIErrorDomain;
extern NSString *const MBParsingErrorDomain;

typedef NS_ENUM(NSInteger, MBErrorCode) {
	MBErrorNone	= 0,
	MBErrorGeneral,
	MBErrorNoResultInResponseJSON
};

@interface MBResponseSerializer : AFJSONResponseSerializer 

@end
