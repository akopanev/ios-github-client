//
//  MDBaseView.h
//  GitHubClient
//
//  Created by Andrew Kopanev on 10/13/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDBaseView : UIView

// you can assign any custom UIView
// such as waiting view, empty state, error, etc
// default is nil
@property (nonatomic, strong) UIView			*modalView;

// override getter for proper layout
// default is self.bounds
@property (nonatomic, readonly) CGRect			modalViewFrame;

@end
