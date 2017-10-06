//
//  LoginViewController.h
//  Simobi
//
//  Created by Ravi on 10/7/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SimobiLoginViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *mPinField;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLBL;
@property (weak, nonatomic) IBOutlet UILabel *mpinLBL;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLBL;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBudgetAction:(id)sender;
@end
