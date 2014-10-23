//
//  GHRepoAdditonalInfoModel.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/22/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHRepoAdditionalInfoModel : NSObject

@property (nonatomic, strong) NSAttributedString		*attributedString;

+ (instancetype)infoWithAttributedString:(NSAttributedString *)attributedString;

@end
