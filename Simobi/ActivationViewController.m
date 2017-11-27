//
//  ActivationViewController.m
//  Simobi
//
//  Created by Ravi on 10/8/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "ActivationViewController.h"
#import "UITextField+Extension.h"
#import "SimobiLoginViewController.h"
#import "NSString+Extension.h"
#import "XRSA.h"
#import "Reachability.h"
#import "DialogHUD.h"
#import "MainMenuViewController.h"
#import "RootViewController.h"

#import "Reachability.h"
#import "Eula.h"


#define COMPARE(x,y)[x isEqualToString:y]

@interface ActivationViewController ()
// storing the position and size of the keyboad
@property (assign) CGRect viewFrame;
@property (assign) CGRect submitOTPRect;

@property (assign)UITextField *activeTextField;
@property (assign)ParentControllerType parentType;
@property (assign)BOOL resetPinRequested;
@property (assign)BOOL reactivationRequested;
@property (assign)BOOL confirmSelected;


@end

@implementation ActivationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithparent:(ParentControllerType) parent
{
    
    self = [super initWithNibName:@"ActivationViewController" bundle:nil];
    
    if (self) {
        self.parentType = parent;
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *textData = [[SimobiManager shareInstance] textDataForLanguage];
    
    self.phoneLabel.text = [textData objectForKey:PHONE];
    
    [self.submitButton setTitle:[textData objectForKey:SUBMIT] forState:UIControlStateNormal];
    [self.otpSubmitBUtton setTitle:[textData objectForKey:SUBMIT] forState:UIControlStateNormal];
    [self.changePinSubmitButton setTitle:[textData objectForKey:SUBMIT] forState:UIControlStateNormal];
    
    if (self.parentType == ParentControllerTypeRoot) {
        
        self.lab1.text       = [textData objectForKey:ACTIVATION__OTP];
        self.lab2.text       = [textData objectForKey:MPIN];
        self.lab3.text       = [textData objectForKey:ACTIVATION_REENTER_PIN];
        [self title:[textData objectForKey:ACTIVATION]];
        
    } else {
        if (self.parentType == ParentControllerTypeAccountChange) {
            self.lab1.text       = [textData objectForKey:CHANGEPIN_OLD_MPIN];
            self.lab2.text       = [textData objectForKey:CHANEPIN_NEW_MPIN];
            self.lab3.text       = [textData objectForKey:CHANEPIN_REENTER_NEW_MPIN];
            [self title:[textData objectForKey:CHANGEPIN]];
        } else {
            self.lab1.text       = @"";
            self.lab2.text       = [textData objectForKey:CHANEPIN_NEW_MPIN];
            self.lab3.text       = [textData objectForKey:CHANEPIN_REENTER_NEW_MPIN];
            [self title:[textData objectForKey:CHANGEPIN]];
        }
        
    }
    
    self.lab6.text = [textData objectForKey:NEWPIN];
    self.lab7.text = [textData objectForKey:CONFIRMPIN];
    
    [ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(success) name:kCHANGEPINNOTIFICATION object:nil ];
    if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
        [self.resendOTPButton setTitle:@"Resend OTP" forState:UIControlStateNormal];
        
    } else {
        [self.resendOTPButton setTitle:@"Kirim Ulang OTP" forState:UIControlStateNormal];
    }
    [self.resendOTPButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    
    
    
    self.otpSubmitBUtton.layer.cornerRadius = 10;
    self.otpSubmitBUtton.clipsToBounds = YES;
    self.resendOTPButton.layer.cornerRadius = 10;
    self.resendOTPButton.clipsToBounds = YES;
    self.submitButton.layer.cornerRadius = 10;
    self.submitButton.clipsToBounds = YES;
    self.changePinSubmitButton.layer.cornerRadius = 10;
    self.changePinSubmitButton.clipsToBounds = YES;
    
}

/*
 * Sucess Notification
 */
- (void)success
{
    
    if (self.parentType == ParentControllerTypeAccount) {
        NSArray *navigationStack = [self.navigationController viewControllers];
        for (UIViewController *vC in navigationStack) {
            
            if ([vC isKindOfClass:[MainMenuViewController class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToViewController:vC animated:YES];
                });
                break;
                return;
            }
        }
        
        MainMenuViewController *mainMenuVC = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:Nil];
        [self.navigationController pushViewController:mainMenuVC animated:YES];
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
            //        SimobiLoginViewController *loginVC = [[SimobiLoginViewController alloc] initWithNibName:@"SimobiLoginViewController" bundle:nil];
            //        [self.navigationController pushViewController:loginVC animated:YES];
            
        });
        
    }
    
}



- (void)tapped

{
    [self.phoneNumberField resignFirstResponder];
    [self.mPinField resignFirstResponder];
    [self.mpin2Field resignFirstResponder];
    [self.otpField resignFirstResponder];
    [self.cardPanField resignFirstResponder];
    [self.confirmPin resignFirstResponder];
    [self.newpin resignFirstResponder];
    [self.bankPin resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.submitOTPRect = self.otpSubmitBUtton.frame;
    self.viewFrame = self.view.frame;
    self.resetPinRequested = NO;
    self.reactivationRequested = NO;
    self.confirmSelected = NO;
    
    [self showBackButton];
    if (ParentControllerTypeAccount == self.parentType) {
        
        self.activationView.hidden = YES;
        self.otpView.hidden = NO;
        self.resendOTPButton.hidden = YES;
        self.otpSubmitBUtton.hidden = YES;
        self.otpField.secureTextEntry = YES;
        self.mPinField.secureTextEntry = YES;
        self.mpin2Field.secureTextEntry = YES;
        self.lblOldpin.hidden = YES;
        self.inputOldpin.hidden = YES;
        
    } else if (ParentControllerTypeAccountChange == self.parentType) {
        
        self.activationView.hidden = YES;
        self.otpView.hidden = NO;
        self.resendOTPButton.hidden = YES;
        self.otpSubmitBUtton.hidden = YES;
        self.otpField.secureTextEntry = YES;
        self.mPinField.secureTextEntry = YES;
        self.mpin2Field.secureTextEntry = YES;
        self.lblOldpin.hidden = NO;
        self.inputOldpin.hidden = NO;
        
    } else {
        self.otpField.secureTextEntry = YES;
        self.mPinField.secureTextEntry = YES;
        self.mpin2Field.secureTextEntry = YES;
        self.otpView.hidden = YES;
        self.activationView.hidden = NO;
        self.changePinSubmitButton.hidden = YES;
        
    }
    
    self.reactivationView.hidden = YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        CGRect _frame = CGRectMake(14.0, 150.0, 290.0, 240.0);
        self.activationView.frame = _frame;
        
        _frame = self.otpView.frame;
        _frame.origin.y = 150.0f;
        self.otpView.frame = _frame;
        CGRect _reactiveFrame = _frame;
        _reactiveFrame.size.height = CGRectGetHeight(self.reactivationView.frame);
        self.reactivationView.frame = _reactiveFrame;
    } else {
        CGRect _frame = CGRectMake(14.0, 75.0, 290.0, 240.0);
        self.activationView.frame = _frame;
        _frame = self.otpView.frame;
        _frame.origin.y = 75.0f;
        self.otpView.frame = _frame;
        
        CGRect _reactiveFrame = _frame;
        _reactiveFrame.size.height = CGRectGetHeight(self.reactivationView.frame);
        self.reactivationView.frame = _reactiveFrame;
        
    }
    self.activationView.layer.cornerRadius = 10.0f;
    self.activationView.layer.borderWidth = 3.0f;
    self.activationView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.reactivationView.layer.cornerRadius = 10.0f;
    self.reactivationView.layer.borderWidth = 3.0f;
    self.reactivationView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    
    self.otpView.layer.cornerRadius = 10.0f;
    self.otpView.layer.borderWidth = 3.0f;
    self.otpView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    self.otpField.delegate = self;
    self.mPinField.delegate = self;
    self.mpin2Field.delegate = self;
    self.newpin.delegate = self;
    self.cardPanField.delegate = self;
    self.confirmPin.delegate = self;
    self.bankPin.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonAction:(id)sender
{
    // self.resetPinRequested = YES;
    // [self setUpActivationOTPUI];
     
    if ([self.phoneNumberField isValid]) {
        if ([self.otpField isValid]) {
            //Service Calll
            [self.phoneNumberField resignFirstResponder];
            
            [self.otpField resignFirstResponder];
            
            Reachability *rechability = [Reachability reachabilityWithHostname:@"www.google.com"];
            
            if ([rechability currentReachabilityStatus] == NotReachable) {
                
                [self noNetworkAlert];
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD displayWithMessage:@"Loading"];
            });
            
            NSString *normalisedMdn = [self getNormalisedMDN:self.phoneNumberField.text];
            NSString *otp = self.otpField.text;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:normalisedMdn,SOURCEMDN,SERVICE_ACCOUNT,SERVICE,TXN_REGISTRATION,TXNNAME,otp,ACTIVATION_OTP, nil];
            NSLog(@"%@", params);
            [[SimobiManager shareInstance] setSourceMDN:normalisedMdn];
            NSString *urlAPI      = SIMOBI_URL;
            NSString *urlString   = [urlAPI constructUrlStringWithParams:params];
            
            
            [SimobiServiceModel connectURL:urlString successBlock:^(NSDictionary *response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [ProgressHUD hide];
                    
                    if ([[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"code"]) {
                        
                        [SimobiAlert showAlertWithMessage:OBJECTFORKEY(response, @"message")];
                        return;
                    }
                    
                    if ([OBJECTFORKEY(response, @"Status") isEqualToString:@"Active"]) {
                        
                        //Check for Reset Pin
                        
                        if ([OBJECTFORKEY(response, @"ResetPinRequested") isEqualToString:@"true"]){
                            
                            self.resetPinRequested = YES;
                            [self setUpActivationOTPUI];
                        } else {
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Simobi" message:@"Dear user, your mbanking account is active.\n If you forget your MPIN, please contact customer care to reset your MPIN." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            alert.tag = 101;
                            [alert show];
                            
                        }
                        
                    } else {
                        
                        if ([OBJECTFORKEY(response, @"IsAlreadyActivated") isEqualToString:@"false"]) {
                            
                            NSDictionary *textData = [[SimobiManager shareInstance] textDataForLanguage];
                            
                            if ([OBJECTFORKEY(response, @"RegistrationMedium") isEqualToString:@"BulkUpload"]){
                                
                                self.reactivationRequested = YES;
                                
                                [self title:[textData objectForKey:REACTIVATION_TITLE]];
                                
                                [self setUpReactivationUI];
                                
                            } else {
                                
                                [self title:[textData objectForKey:RESET_MPIN_TITLE]];
                                [self setUpActivationOTPUI];
                            }
                        } else {
                            [self setUpActivationOTPUI];
                        }
                        
                    }
                    
                    //CONDITIONLOG(DEBUG_MODE,@"Response:%@",response);
                });
                
            } failureBlock:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [ProgressHUD hide];
                    
                    // [SimobiAlert showAlertWithMessage:error.localizedDescription];
                    NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                    [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
                });
                
            }];

        } else {
            [SimobiAlert showAlertWithMessage:@"Please enter otp"];
        }
        
    } else {
        
        [SimobiAlert showAlertWithMessage:@"Please enter phone number"];
    }
    
}

- (IBAction)resendOTPButtonAction:(id)sender
{
    if ([self.phoneNumberField isValid]) {
        Reachability *rechability = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        if ([rechability currentReachabilityStatus] == NotReachable) {
            
            [self noNetworkAlert];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD displayWithMessage:@"Loading"];
        });
        NSString *normalisedMdn = [self getNormalisedMDN:self.phoneNumberField.text];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:normalisedMdn,SOURCEMDN,SERVICE_ACCOUNT,SERVICE,TXN_RESENDOTP,TXNNAME, nil];
        [[SimobiManager shareInstance] setSourceMDN:normalisedMdn];
        NSString *urlAPI      = SIMOBI_URL;
        NSString *urlString   = [urlAPI constructUrlStringWithParams:params];
        
        //CONDITIONLOG(DEBUG_MODE,@"Response:%@",urlString);
        
        [SimobiServiceModel connectURL:urlString successBlock:^(NSDictionary *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [ProgressHUD hide];
                
                if ([[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"code"]) {
                    [SimobiAlert showAlertWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"]];
                }
                //CONDITIONLOG(DEBUG_MODE,@"Response:%@",response);
            });
            
        } failureBlock:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [ProgressHUD hide];
                //[SimobiAlert showAlertWithMessage:error.localizedDescription];
                NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
            });
            
        }];
        
    } else {
        
        [SimobiAlert showAlertWithMessage:@"Please enter phone number"];
    }
    
}

- (void)backButtonAction:(id)sender

{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpReactivationUI

{
    
    self.lab4.text = @"Card Pan";
    self.lab5.text = @"Bank mPin";
    
    self.reactivationView.hidden = NO;
    self.activationView.hidden = YES;
    self.otpView.hidden = YES;
    
    self.bankPin.secureTextEntry     = YES;
    self.newpin.secureTextEntry      = YES;
    self.confirmPin.secureTextEntry = YES;
    
    
    UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [subBtn addTarget:self action:@selector(reactivationSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    CGSize butonSize = CGSizeMake(75.0f, 35.0f);
    [subBtn setFrame:CGRectMake((CGRectGetWidth(self.reactivationView.frame) - butonSize.width)/2, CGRectGetHeight(self.reactivationView.frame) - butonSize.height - 10.0f, butonSize.width, butonSize.height)];
    
    [subBtn setBackgroundImage:[UIImage imageNamed:@"button_empty.png"] forState:UIControlStateNormal];
    subBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    subBtn.titleLabel.textColor = [UIColor whiteColor];
    
    NSDictionary *textData = [[SimobiManager shareInstance] textDataForLanguage];
    [subBtn setTitle:[textData objectForKey:SUBMIT] forState:UIControlStateNormal];
    
    
    [self.reactivationView addSubview:subBtn];
    
}

- (void)reactivationSubmitAction

{
    if ([self.cardPanField isValid]) {
        
        if ([self.bankPin isValid]) {
            
            if ([self.newpin isValid]) {
                
                if ([self.confirmPin isValid]) {
                    
                    
                    if (!self.eula) {
                        self.eula = [[Eula alloc] initWithFrame:SIMOBI_KEY_WINDOW.frame];
                        self.eula.delegate = self;
                        [self.view addSubview:self.eula];
                    }
                    
                    
                } else {
                    
                    [SimobiAlert showAlertWithMessage:@"Please enter Confirm mPin"];
                    
                }
            } else {
                [SimobiAlert showAlertWithMessage:@"Please enter new mPin"];
                
            }
        } else {
            
            [SimobiAlert showAlertWithMessage:@"Please enter bank Pin"];
        }
        
        
    } else {
        [SimobiAlert showAlertWithMessage:@"Please enter card pan"];
    }
    
}
- (void)setUpActivationOTPUI
{
    self.activationView.hidden = YES;
    //    CGRect _frame = CGRectMake(14.0, 101.0, 290.0, 233.0);
    //    self.otpView.frame = _frame;
    self.otpView.hidden = NO;
    
    if (self.resetPinRequested) {
        NSDictionary *textData = [[SimobiManager shareInstance] textDataForLanguage];
        [self title:@"Reset mPIN"];
        self.lab1.text = @"OTP";
        self.lab2.text = [textData objectForKey:NEWPIN];
        self.lab3.text = [textData objectForKey:CONFIRMPIN];
        self.resendOTPButton.hidden = YES;
        self.otpSubmitBUtton.hidden = YES;
        self.changePinSubmitButton.hidden = NO;
        self.otpField.secureTextEntry = YES;
        self.mPinField.secureTextEntry = YES;
        self.mpin2Field.secureTextEntry = YES;
        self.lblOldpin.hidden = YES;
        self.inputOldpin.hidden = YES;
    } else {
        if (self.parentType ==ParentControllerTypeAccountChange) {
            NSDictionary *textData = [[SimobiManager shareInstance] textDataForLanguage];
            
            [self title:@"Change mPIN"];
            self.lblOldpin.text = @"Old mPIN";
            self.lab2.text = [textData objectForKey:NEWPIN];
            self.lab3.text = [textData objectForKey:CONFIRMPIN];
            self.resendOTPButton.hidden = YES;
            self.otpSubmitBUtton.hidden = YES;
            self.changePinSubmitButton.hidden = NO;
            self.otpField.secureTextEntry = YES;
            self.mPinField.secureTextEntry = YES;
            self.mpin2Field.secureTextEntry = YES;
            self.lblOldpin.hidden = NO;
            self.inputOldpin.hidden = NO;
        } else {
            NSDictionary *textData = [[SimobiManager shareInstance] textDataForLanguage];
            
            self.lab2.text = [textData objectForKey:NEWPIN];
            self.lab3.text = [textData objectForKey:CONFIRMPIN];
            self.resendOTPButton.hidden = YES;
            self.otpSubmitBUtton.hidden = YES;
            self.changePinSubmitButton.hidden = NO;
            self.otpField.secureTextEntry = YES;
            self.mPinField.secureTextEntry = YES;
            self.mpin2Field.secureTextEntry = YES;
            self.lblOldpin.hidden = YES;
            self.inputOldpin.hidden = YES;
        }
    }
    
    
}

- (IBAction)otpSubmitBUttonAction:(id)sender
{
    BOOL isEnglish = [[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH];
    
    if (self.parentType == ParentControllerTypeAccountChange) {
        
        if ([self.inputOldpin isValid]) {
            
            if ([self.mPinField isValid]) {
            
                if ([self.mpin2Field isValid]) {
                    if ((self.mPinField.text.length < 6) || (self.mpin2Field.text.length < 6) ) {
                        [SimobiAlert showAlertWithMessage:isEnglish ? ENGLISH_SIX_DIGIT_ACTIVATION: BAHASA_SIX_DIGIT_ACTIVATION];
                        return;
                    }
                    
                    NSString *pin = [[SimobiManager shareInstance] sourcePIN];
                    
                    if (COMPARE(self.inputOldpin.text, pin)) {
                        
                        if(COMPARE(self.mPinField.text, self.mpin2Field.text)) {
                            
                            [self.otpField resignFirstResponder];
                            [self.mPinField resignFirstResponder];
                            [self.mpin2Field resignFirstResponder];
                            
                            NSString *mdn = [[SimobiManager shareInstance] sourceMDN];
                            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
                            
                            [params setObject:mdn forKey:SOURCEMDN];
                            [params setObject:self.inputOldpin.text forKey:SOURCEPIN];
                            [params setObject:self.mPinField.text forKey:CHANGEPIN_NEWPIN];
                            [params setObject:self.mpin2Field.text forKey:CHANGEPIN_CONFIRMPIN];
                            [params setObject:INQUIRY forKey:MFATRANSACTION];
                            [params setObject:SERVICE_ACCOUNT forKey:SERVICE];
                            [params setObject:TXN_INQUIRY_CHANGEMPIN forKey:TXNNAME];
                            
                            NSString *url = [SIMOBI_URL constructUrlStringWithParams:params];
                            
                            [[[SimobiManager shareInstance] responseData] removeAllObjects];
                            [[[SimobiManager shareInstance] responseData] addEntriesFromDictionary:params];
                            [[SimobiManager shareInstance] setPIN:self.mpin2Field.text];
                            [self performServicecallWithUrlstring:url];
                        } else {
                            
                            [SimobiAlert showAlertWithMessage:@"newpin does not match"];
                        }
                        
                    } else {
                        
                        [SimobiAlert showAlertWithMessage:@"please enter correct mpin"];
                    }
                
                } else {
                    [SimobiAlert showAlertWithMessage:@"please  enter re-enter mpin"];
                }
                
            } else {
                [SimobiAlert showAlertWithMessage:@"please enter mpin"];
            }
        } else {
            [SimobiAlert showAlertWithMessage:@"please enter old mpin"];
        }


    } else {
        
        if ([self.mPinField isValid]) {
            
            if ([self.mpin2Field isValid]) {
                if ((self.mPinField.text.length < 6) || (self.mpin2Field.text.length < 6) ) {
                    [SimobiAlert showAlertWithMessage:isEnglish ? ENGLISH_SIX_DIGIT_ACTIVATION: BAHASA_SIX_DIGIT_ACTIVATION];
                    return;
                }
                
                // Call Activation Service
                if (!self.resetPinRequested && !self.confirmSelected) {
                    if (!self.eula) {
                        self.eula = [[Eula alloc] initWithFrame:SIMOBI_KEY_WINDOW.frame];
                        self.eula.delegate = self;
                        [self.view addSubview:self.eula];
                    }
                    
                    return;
                    
                }
                
                if(COMPARE(self.mPinField.text, self.mpin2Field.text)) {
                    
                    [self.otpField resignFirstResponder];
                    [self.mPinField resignFirstResponder];
                    [self.mpin2Field resignFirstResponder];
                    
                    XRSA *rsa = [[XRSA alloc] initWithPublicKeyModulus:[[[SimobiManager shareInstance] publicKeyDict] objectForKey:@"modulus"] withPublicKeyExponent:[[[SimobiManager shareInstance] publicKeyDict] objectForKey:@"exponent"]];
                    
                    NSString *encryptedStr = [rsa encryptToString:self.mPinField.text];
                    
                    
                    [self displayProgressHudWithMessage:@"Loading"];
                    
                    NSString *mdn             = [[SimobiManager shareInstance] sourceMDN];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                    
                    if (self.resetPinRequested)  {
                        
                        [dict setObject:SERVICE_ACCOUNT forKey:SERVICE];
                        [dict setObject:TXN_RESETPIN forKey:TXNNAME];
                        
                    } else {
                    
                        [dict setObject:SERVICE_ACCOUNT forKey:SERVICE];
                        [dict setObject:TXN_INQUIRY_ACTIVATION forKey:TXNNAME];
                        [dict setObject:INQUIRY forKey:MFATRANSACTION];
                        
                    }
                    
                    [dict setObject:mdn forKey:SOURCEMDN];
                    [dict setObject:self.otpField.text forKey:OTP];
                    [dict setObject:encryptedStr forKey:ACTIVATION_NEWPIN];
                    [dict setObject:encryptedStr forKey:ACTIVATION_CONFORMPIN];
                    
                    NSString *urlstring = [SIMOBI_URL constructUrlStringWithParams:dict];
                    
                    [[[SimobiManager shareInstance] responseData] removeAllObjects];
                    [[[SimobiManager shareInstance] responseData] addEntriesFromDictionary:dict];
                    
                    [self performServicecallWithUrlstring:urlstring];
                    
                } else {
                    [SimobiAlert showAlertWithMessage:@"mpin fields do not match"];
                }

            } else {
                [SimobiAlert showAlertWithMessage:@"please  enter re-enter mpin"];
            }
            
        } else {
            [SimobiAlert showAlertWithMessage:@"please enter mpin"];
        }
        
    }
    
//    if ([self.otpField isValid]) {
//        if ([self.mPinField isValid]) {
//            
//            if ([self.mpin2Field isValid]) {
//                if ((self.mPinField.text.length < 6) || (self.mpin2Field.text.length < 6) ) {
//                    [SimobiAlert showAlertWithMessage:isEnglish ? ENGLISH_SIX_DIGIT_ACTIVATION: BAHASA_SIX_DIGIT_ACTIVATION];
//                    return;
//                }
//                
//                if (self.parentType == ParentControllerTypeAccount) {
//                   
//                    
//                } else {
//                    
//                   
//                }
//                
//            } else {
//                
//                [SimobiAlert showAlertWithMessage:@"please  enter re-enter mpin"];
//            }
//            
//        } else {
//            
//            [SimobiAlert showAlertWithMessage:@"please enter mpin"];
//        }
//        
//    } else{
//        [SimobiAlert showAlertWithMessage:@"Please enter otp number"];
//    }
}

- (IBAction)changePinSubmitButton:(id)sender {
    
    [self otpSubmitBUttonAction:nil];
}


- (void)performServicecallWithUrlstring:(NSString *)urlString
{
    CONDITIONLOG(DEBUG_MODE,@"Service:::%@",urlString);
    
    Reachability *rechability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if ([rechability currentReachabilityStatus] == NotReachable) {
        
        [self noNetworkAlert];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD displayWithMessage:@"Loading"];
    });
    
    [SimobiServiceModel connectURL:urlString successBlock:^(NSDictionary *response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD hide];
            //   NSString *message = OBJECTFORKEY(response, @"message");
            
            //CONDITIONLOG(DEBUG_MODE,@"Response:%@",response);
            
            if (self.parentType == ParentControllerTypeRoot) {
                [[[SimobiManager shareInstance] responseData] setObject:@"Confirm" forKey:MFATRANSACTION];
            } else {
                [[[SimobiManager shareInstance] responseData] setObject:@"Confirm" forKey:MFATRANSACTION];
            }
            
            if (OBJECTFORKEY(response, @"sctlID"))  {
                [[[SimobiManager shareInstance] responseData] setObject:OBJECTFORKEY(response, @"sctlID") forKey:PARENTTXNID];//parentTxnID
            }
            
            Service service;
            if (self.parentType == ParentControllerTypeAccountChange) {
                service = Service_CHANGEPIN;
            } else if (self.reactivationRequested){
                service = Service_REACTIVATION;
            } else if (self.resetPinRequested ) {
                service = Service_RESETPIN;
            } else {
                service = Service_ACTIVATION;
            }
            
            
            CONDITIONLOG(DEBUG_MODE,@"Service:::%d",service);
            CONDITIONLOG(DEBUG_MODE,@"Service:::%@",response);
            NSString *code = response[@"response"][@"message"][@"code"];
            if ([code isEqualToString:SIMOBI_SUCCESS_CHANGE_MPIN]
                && service == Service_CHANGEPIN) {
                // if code is not success please do not show the display with message.
                [DialogHUD displayWithMessage:OBJECTFORKEY(response, @"message") withservice:service];
            } else if ([code isEqualToString:SIMOBI_LOGIN_EXPIRE_CODE]) {
                [self reLoginAlertWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"]];
            } else if ([code isEqualToString:SIMOBI_SUCCESS_ACTIVATION]) {
                // if code is wrong
                [DialogHUD displayWithMessage:OBJECTFORKEY(response, @"message") withservice:service];
            } else if ([code isEqualToString:SIMOBI_SUCCESS_RESET_MPIN]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Simobi" message:OBJECTFORKEY(response, @"message") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag = 101;
                [alert show];
                
            } else {
                [SimobiAlert showAlertWithMessage:OBJECTFORKEY(response, @"message")];
            }
            
        });
    } failureBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD hide];
            
            // [SimobiAlert showAlertWithMessage:error.localizedDescription];
            NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
            [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
        });
    }];
    
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    
    if (![[self.navigationController viewControllers] containsObject: self]) {
        
        [[NSNotificationCenter defaultCenter]  removeObserver:self name:kCHANGEPINNOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        
        [self setActivationView:nil];
        [self setOtpView:nil];
        [self setPhoneNumberField:nil];
        [self setOtpField:nil];
        [self setMPinField:nil];
        [self setMpin2Field:nil];
        
        [self setLab1:nil];
        [self setLab2:nil];
        [self setLab3:nil];
        
        [self setOtpSubmitBUtton:nil];
        [self setResendOTPButton:nil];
        [self setSubmitButton:nil];
        
    }
    
    [super viewWillDisappear:animated];
    
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.mPinField || textField == self.mpin2Field || textField == self.otpField){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 6) ? NO : YES;
    }
    
    return YES;
}


#pragma mark - EULA View Delagate Methods

- (void)confirmAction
{
    self.confirmSelected = YES;
    
    [self.eula removeFromSuperview],self.eula = nil;
    
    if (self.reactivationRequested) {
        
        NSString *mdn             = [[SimobiManager shareInstance] sourceMDN];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
        
        XRSA *rsa = [[XRSA alloc] initWithPublicKeyModulus:[[[SimobiManager shareInstance] publicKeyDict] objectForKey:@"modulus"] withPublicKeyExponent:[[[SimobiManager shareInstance] publicKeyDict] objectForKey:@"exponent"]];
        
        NSString *encryptedCardPan = [rsa encryptToString:self.cardPanField.text];
        NSString *encryptedBankPin = [rsa encryptToString:self.bankPin.text];
        NSString *encryptedNewPin = [rsa encryptToString:self.newpin.text];
        NSString *encryptedConfirmPin = [rsa encryptToString:self.confirmPin.text];
        
        [params setObject:mdn                                          forKey:SOURCEMDN];
        [params setObject:encryptedBankPin                       forKey:SOURCEPIN];
        [params setObject:encryptedCardPan                       forKey:CARDPAN];
        [params setObject:encryptedNewPin                        forKey:CHANGEPIN_NEWPIN];
        [params setObject:encryptedConfirmPin                   forKey:CHANGEPIN_CONFIRMPIN];
        [params setObject:SERVICE_ACCOUNT                    forKey:SERVICE];
        [params setObject:TXN_REACTIVATION                    forKey:TXNNAME];
        [params setObject:INQUIRY                                     forKey:MFATRANSACTION];
        
        [[[SimobiManager shareInstance] responseData] removeAllObjects];
        [[[SimobiManager shareInstance] responseData] addEntriesFromDictionary:params];
        
        NSString *urlString = [SIMOBI_URL constructUrlStringWithParams:params];
        
        [self performServicecallWithUrlstring:urlString];
        
    } else {
        
        [self otpSubmitBUttonAction:nil];
    }
    
}

- (void)cancelAction
{
    if (self.eula)  {
        [self.eula removeFromSuperview];
        self.eula = nil;
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (101 == alertView.tag) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - Keyboard Handling

-(void)keyboardDidShowNotification:(NSNotification *)notification
{
    
    self.viewFrame = self.view.frame;
    
    if (self.activeTextField.tag <= 0) {
        return;
    }
    float Y_POS = 0.0f;
    
    if ([self.activeTextField isEqual:self.otpField] || [self.activeTextField isEqual:self.newpin] || [self.activeTextField isEqual:self.cardPanField]) {
        
        Y_POS = 70.0f;
        
    } else if ([self.activeTextField isEqual:self.mPinField] || [self.activeTextField isEqual:self.confirmPin]) {
        
        Y_POS = 100.0f;
        
    } else {
        
        Y_POS = 120.0f;
        
    }
    NSTimeInterval interval = [ [ [ notification userInfo ] objectForKey:UIKeyboardAnimationDurationUserInfoKey ] doubleValue ];
    
    [ UIView animateWithDuration:interval animations:^{
        [self.view setFrame:CGRectMake(0, -Y_POS - 20.0f, self.view.frame.size.width, self.view.frame.size.height)];
    } ];
}

-(void)keyboardWillHideNotification:(NSNotification *)notification
{
    
    if (self.activeTextField.tag <= 0) {
        return;
    }
    
    NSTimeInterval interval = [ [ [ notification userInfo ] objectForKey:UIKeyboardAnimationDurationUserInfoKey ] doubleValue ];
    
    [ UIView animateWithDuration:interval animations:^{
        [self.view setFrame:self.viewFrame];
    } ];
}

-(NSString *) getNormalisedMDN:(NSString *) mdnString {
    
    if ([mdnString hasPrefix:@"0"] && [mdnString length] > 1) {
        mdnString = [mdnString substringFromIndex:1];
        return [NSString stringWithFormat:@"62%@",mdnString];
    }
    if (![mdnString hasPrefix:@"62"]) {
        return [NSString stringWithFormat:@"62%@",mdnString];
    }
    return mdnString;
}

@end
