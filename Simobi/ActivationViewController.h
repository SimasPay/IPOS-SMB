//
//  ActivationViewController.h
//  Simobi
//
//  Created by Ravi on 10/8/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Eula.h"

typedef enum
{
    ParentControllerTypeRoot,
    ParentControllerTypeAccount,
    ParentControllerTypeAccountChange

}ParentControllerType;


@interface ActivationViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate,EulaDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIView *activationView;
@property (weak, nonatomic) IBOutlet UIView *otpView;
@property (weak, nonatomic) IBOutlet UILabel *lblOldpin;
@property (weak, nonatomic) IBOutlet UITextField *inputOldpin;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *otpField;
@property (weak, nonatomic) IBOutlet UITextField *mPinField;
@property (weak, nonatomic) IBOutlet UITextField *mpin2Field;

@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab1;

@property (weak, nonatomic) IBOutlet UIButton *otpSubmitBUtton;
@property (weak, nonatomic) IBOutlet UIButton *resendOTPButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *changePinSubmitButton;
@property (weak, nonatomic) IBOutlet UIView *reactivationView;
@property (weak, nonatomic) IBOutlet UITextField *cardPanField;
@property (weak, nonatomic) IBOutlet UITextField *bankPin;
@property (weak, nonatomic) IBOutlet UITextField *newpin;
@property (weak, nonatomic) IBOutlet UITextField *confirmPin;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UILabel *lab6;
@property (weak, nonatomic) IBOutlet UILabel *lab7;
@property (nonatomic)  Eula *eula;


- (IBAction)submitButtonAction:(id)sender;
- (IBAction)resendOTPButtonAction:(id)sender;
- (IBAction)otpSubmitBUttonAction:(id)sender;

- (instancetype)initWithparent:(ParentControllerType) parent;

@end
