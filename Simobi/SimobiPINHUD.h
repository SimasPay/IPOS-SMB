//
//  SimobiPINHUD.h
//  Simobi
//
//  Created by Rajesh Pothuraju on 04/10/15.
//  Copyright (c) 2015 Mfino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialogHUD.h"

@interface SimobiPINHUD : NSObject<UIGestureRecognizerDelegate,UIScrollViewDelegate>
+(void)displayWithMessage:(NSString *)message;
+(void)hide;
@end
