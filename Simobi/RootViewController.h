//
//  RootViewController.h
//  Simobi
//
//  Created by Ravi on 10/7/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RootViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *loginLBL;
@property (weak, nonatomic) IBOutlet UILabel *activationLBL;
@property (weak, nonatomic) IBOutlet UIButton *contactUsBtn;
@property (weak, nonatomic) IBOutlet UIButton *termConditionBtn;

- (IBAction)loginButtonAction:(id)sender;
- (IBAction)activationBUttonAction:(id)sender;
- (IBAction)contactUSButtonAction:(id)sender;
- (IBAction)termsButtonAction:(id)sender;
@end
