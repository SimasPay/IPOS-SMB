//
//  ProgressHUD.h
//  eHub
//
//  Created by Hasani Hunter on 11/7/12.
//  Copyright (c) 2012 Team Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHUD : NSObject

// displays the ProgressHUD with a message underneath the activity spinner. Pass in nil if no message is needed
+(void)displayWithMessage:(NSString *)message;

// displays the ProgressHUD with an optional message contstrained to the specified view.
+(void)displayWithMessage:(NSString *)message view:(UIView *)view;

// stops the animation and destroys the HUD
+(void)hide;

@end
