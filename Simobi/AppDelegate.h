//
//  AppDelegate.h
//  Simobi
//
//  Created by Ravi on 10/7/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) Reachability *reachability;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *viewController;
@property (assign)            BOOL publikKeyReceived;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (assign, nonatomic) BOOL isNetAvailable;
@end
