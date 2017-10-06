//
//  BaseViewController.h
//  Simobi
//
//  Created by Ravi on 10/7/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimobiManager.h"
#import "SimobiAlert.h"
#import "SimobiConstants.h"
#import "SimobiServiceModel.h"
#import "ProgressHUD.h"
#import "SimobiConstants.h"


@interface BaseViewController : UIViewController<UIAlertViewDelegate,UIGestureRecognizerDelegate>



@property (nonatomic,retain)UILabel *titleLable;
@property (nonatomic,retain)UILabel *subTitleLabel;
@property (nonatomic,assign)BOOL isNetworkReachable;


- (void)showHomeButton;
- (void)showBackButton;
- (void)hideBackButton;
- (void)hideHomeButton;

- (void)title:(NSString *)titleStr;
- (void)subtitle:(NSString *)titleStr;
- (void)backButtonAction:(id)sender;
- (void)displayProgressHudWithMessage:(NSString *)message;
- (void)hideProgressHud;
- (void)noNetworkAlert;
- (void)reLoginAlertWithMessage:(NSString *)alertMessage;
- (void)tapped;
@end
