//
//  LoginViewController.m
//  Simobi
//
//  Created by Ravi on 10/7/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "SimobiLoginViewController.h"
#import "MainMenuViewController.h"
#import "UITextField+Extension.h"
#import "XRSA.h"
#import "NSString+Extension.h"
#import "Reachability.h"
#import "SimobiUtility.h"
#import "ActivationViewController.h"
#import <DIMOPayiOS/DIMOPayiOS.h>

@interface SimobiLoginViewController ()<UIAlertViewDelegate>
// storing the position and size of the keyboad
@property (assign) CGRect viewFrame;


@end

@implementation SimobiLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)resetKeychain {
    [self deleteAllKeysForSecClass:kSecClassGenericPassword];
    [self deleteAllKeysForSecClass:kSecClassInternetPassword];
    [self deleteAllKeysForSecClass:kSecClassCertificate];
    [self deleteAllKeysForSecClass:kSecClassKey];
    [self deleteAllKeysForSecClass:kSecClassIdentity];
}

-(void)deleteAllKeysForSecClass:(CFTypeRef)secClass {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:(__bridge id)secClass forKey:(__bridge id)kSecClass];
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef) dict);
    NSAssert(result == noErr || result == errSecItemNotFound, @"Error deleting keychain data (%d)", (int)result);
}

- (void)viewDidLoad
{
    
    
    
    [self deleteAllKeysForSecClass:kSecClassGenericPassword];
    [self deleteAllKeysForSecClass:kSecClassInternetPassword];
    [self deleteAllKeysForSecClass:kSecClassCertificate];
    [self deleteAllKeysForSecClass:kSecClassKey];
    [self deleteAllKeysForSecClass:kSecClassIdentity];
    
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"GetUserAPIKey"];
    [defaults synchronize];
    
    
    //CONDITIONLOG(DEBUG_MODE,@"%@",[[SimobiManager shareInstance] language]);
    
    // Do any additional setup after loading the view from its nib.
    
    [self showBackButton];
    self.viewFrame = self.view.frame;

    self.loginView.layer.cornerRadius = 10.0f;
    self.loginView.layer.borderWidth  = 3.0f;
    self.loginView.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    
    
    
    CGRect _frame = self.loginView.frame;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))  {
        
        _frame.origin.y = 180.0f;
        self.loginView.frame = _frame;
        _frame = self.welcomeLBL.frame;
        
        _frame.origin.y += 75.0f;
        self.welcomeLBL.frame = _frame;
    } else {
        _frame.origin.y = 90.0f;
        self.loginView.frame = _frame;

    }
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.clipsToBounds = YES;
    
    //CONDITIONLOG(DEBUG_MODE,@"LoginViewFrame:%@",NSStringFromCGRect(self.loginView.frame));
    

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // make sure we "listen" for the keyboard so we can adjust the underlying view
    //[ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardWillShowNotification object:nil ];
    //[ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil ];

    NSDictionary *textData   = [[SimobiManager shareInstance] textDataForLanguage];
    self.phoneNumberLBL.text = [textData objectForKey:PHONE];
    self.mpinLBL.text        = [textData objectForKey:MPIN];
    if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
        self.welcomeLBL.text = @"Welcome!";
    } else {
        self.welcomeLBL.text = @"Selamat datang!";
    }
    
    //add phone number from nsuserdefalut
    NSString *phoneNumber =[[NSUserDefaults standardUserDefaults] objectForKey:SIMOBI_LOGIN_PHONE_NUMBER];
    if (phoneNumber == nil) {
        self.phoneNumberField.text = @"";
    } else {
        self.phoneNumberField.text = [[NSUserDefaults standardUserDefaults] objectForKey:SIMOBI_LOGIN_PHONE_NUMBER];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    //NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
//    self.phoneNumberLBL.text = @"Log in";
//    self.mpinLBL.text              = [textDict objectForKey:ACTIVATION];
    

    self.mPinField.text = @"";
}

- (void)setUPKeyBoardAccessoryView
{
    //UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous",@"Next", nil]];
    //segment.s

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tapped
{
    [self.phoneNumberField resignFirstResponder];
    [self.mPinField resignFirstResponder];
}
- (void)backButtonAction:(id)sender
{

    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)loginBudgetAction:(id)sender
{
    BOOL isEnglish = [[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH];
    if ([self.phoneNumberField isValid]) {
        [self.phoneNumberField resignFirstResponder];
        
        if ([self.mPinField isValid]) {
            
            [self.mPinField resignFirstResponder];
        
            if (self.mPinField.text.length < 6) {

            [SimobiAlert showAlertWithMessage:isEnglish ?ENGLISH_SIX_DIGIT_LOGIN: BAHASA_SIX_DIGIT_LOGIN];
                return;
            }
            
            Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];

            if ([reachability currentReachabilityStatus] == NotReachable) {
               // [SimobiAlert showAlertWithMessage:@"No Network connection\n Please try again later."];
                
                NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
                return;
            }
            
//            Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
//
//            NetworkStatus netStatus = [reachability currentReachabilityStatus];
//            
//            if (netStatus == NotReachable) {
//            
//                [SimobiAlert showAlertWithMessage:@"No Network connection\n Please try again later."];
//                return;
//            }

            [self displayProgressHudWithMessage:@"Loading"];
            NSString *normalisedMdn = [self getNormalisedMDN:self.phoneNumberField.text];
            

                // Start the notifier, which will cause the reachability object to retain itself!
                XRSA *rsa = [[XRSA alloc] initWithPublicKeyModulus:[[[SimobiManager shareInstance] publicKeyDict] objectForKey:@"modulus"] withPublicKeyExponent:[[[SimobiManager shareInstance] publicKeyDict] objectForKey:@"exponent"]];
                
                NSString *encryptedmPIN = [NSString string];
                if (rsa != nil) {
                    encryptedmPIN = [rsa encryptToString:self.mPinField.text];
                    //CONDITIONLOG(DEBUG_MODE,@"String:%@",encryptedmPIN);
                } else {
                    
                    //CONDITIONLOG(DEBUG_MODE,@"Error");
                }
                
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:normalisedMdn   forKey:@"sourceMDN"];
                [params setObject:encryptedmPIN forKey:@"authenticationString"];
                [params setObject:@"subapp"     forKey:@"apptype"];
                [params setObject:@"Login"      forKey:@"txnName"];
                [params setObject:@"Account"    forKey:@"service"];
                [params setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]        forKey:@"appversion"];
                [params setObject:@"ios"        forKey:@"appos"];
                
                NSString *normalisedUrl =  [SIMOBI_URL constructUrlStringWithParams:params];
            
                 CONDITIONLOG(DEBUG_MODE,@"normalisedUrl:%@",normalisedUrl);

            
                [SimobiServiceModel connectURL:normalisedUrl successBlock:^(NSDictionary *response) {
                    
                    [self hideProgressHud];
                    CONDITIONLOG(DEBUG_MODE,@"Response:%@",response);

                    //To Check IF success
                    NSString *simobiPlusUpgrade = @"0";
                    
                    if ([[response objectForKey:@"response"] objectForKey:@"simobiPlusUpgrade"] != nil ) {
                        simobiPlusUpgrade = [[[response objectForKey:@"response"] objectForKey:@"simobiPlusUpgrade"] objectForKey:@"text"];
                    }
                    
                    NSString *code = [[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"code"];
                    
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:[response valueForKeyPath:@"response.userAPIKey.text"] forKey:@"GetUserAPIKey"];
                    [defaults setObject:simobiPlusUpgrade forKey:@"simobiPlusUpgrade"];
                    [defaults synchronize];
                    
                    NSArray *mobileNoArray = [SimobiUtility getDataFromPlistForKey:SimobiLoginNOsArray];
                    
                    if (mobileNoArray.count > 0) {
                        
                        NSMutableArray *simobiLoginArray = [[NSMutableArray alloc] initWithArray:mobileNoArray];
                        if(![simobiLoginArray containsObject:normalisedMdn]){
                            [simobiLoginArray addObject:normalisedMdn];
                            
                            // Clear Session
                            [DIMOPay setEULAState:NO];
                        }
                        [SimobiUtility saveDataToPlist:simobiLoginArray key:SimobiLoginNOsArray];
                        
                    }else{
                        NSMutableArray *simobiLoginArray = [[NSMutableArray alloc] init];
                        [simobiLoginArray addObject:normalisedMdn];
                        [SimobiUtility saveDataToPlist:simobiLoginArray key:SimobiLoginNOsArray];
                        
                        // Clear Session
                        [DIMOPay setEULAState:NO];
                    }
                    
                    [DIMOPay resetUserAPIKey];
                    
                    
                    
                    [[SimobiManager shareInstance] setSourceMDN:normalisedMdn];
                    [[SimobiManager shareInstance] setSourcePIN:self.mPinField.text];
                    NSUserDefaults *defult = [[NSUserDefaults alloc]init];
                    [defult setObject:self.phoneNumberField.text forKey:SIMOBI_LOGIN_PHONE_NUMBER];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    
                    if ([code isEqualToString:SIMOBI_SUCCESS_LOGIN_CODE]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            MainMenuViewController *mainMenuVC = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:Nil];
                            [self.navigationController pushViewController:mainMenuVC animated:YES];
                        });
                        
                    } else if ([code isEqualToString:SIMOBI_FORCE_CHANGE_PIN_CODE]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH] ? @"Please change your mPIN before performing transaction." : @"Mohon ubah mPIN Anda sebelum melakukan transaksi." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            alertView.tag = 101;
                            [alertView show];
                        });
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{

                        [SimobiAlert showAlertWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"]];
                        });

                    }

                }
                                  failureBlock:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD hide];
                       // [SimobiAlert showAlertWithMessage:error.localizedDescription];
                        NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                        [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];

                    });
                }];
            
        } else {
            
        [SimobiAlert showAlertWithMessage:isEnglish ? ENGLISH_FILL_MPIN: BAHASA_FILL_MPIN];
        }
        
        
    } else {
       // Please enter Phone Number
        
        [SimobiAlert showAlertWithMessage:isEnglish ? ENGLISH_FILL_PHONE_NUMBER: BAHASA_FILL_PHONE_NUMBER];
    }
    
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phoneNumberField) {
    
        [self.mPinField becomeFirstResponder];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneNumberField) {
        
        [self.mPinField becomeFirstResponder];
    } else {
        
        [self loginBudgetAction:nil];
    
    }


    return YES;

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.mPinField){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 6) ? NO : YES;
    }
    
    return YES;
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView.tag == 101) {
        // force change mPin
        ActivationViewController *activityViewController = [[ActivationViewController alloc] initWithparent:ParentControllerTypeAccount];
        [self.navigationController pushViewController:activityViewController animated:YES];
    }
}

#pragma mark - Keyboard Handling


-(void)keyboardDidShowNotification:(NSNotification *)notification
{
    
    //CONDITIONLOG(DEBUG_MODE,@"Before Keyboard:%@",NSStringFromCGRect(self.view.frame));

//    NSValue *rectValue = [ [ notification userInfo ] objectForKey:UIKeyboardFrameEndUserInfoKey ];
//    
//    CGRect destinationFrame = [ rectValue CGRectValue ];
    
    self.viewFrame = self.view.frame;
    
    NSTimeInterval interval = [ [ [ notification userInfo ] objectForKey:UIKeyboardAnimationDurationUserInfoKey ] doubleValue ];
    
    [ UIView animateWithDuration:interval animations:^{
        [self.view setFrame:CGRectMake(0, -40, self.view.frame.size.width, self.view.frame.size.height)];
    } ];
    //[self.view setFrame:CGRectMake(0, -40, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)keyboardWillHideNotification:(NSNotification *)notification
{
    //CONDITIONLOG(DEBUG_MODE,@"After Keyboard:%@",NSStringFromCGRect(self.view.frame));

    NSTimeInterval interval = [ [ [ notification userInfo ] objectForKey:UIKeyboardAnimationDurationUserInfoKey ] doubleValue ];
    
   // [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [ UIView animateWithDuration:interval animations:^{
        [self.view setFrame:self.viewFrame];
       // self.controlContainerView.frame = self.keyboardRect;
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


- (void)viewDidUnload {
    [self setPhoneNumberField:nil];
    [self setMPinField:nil];
    [self setLoginView:nil];
    [self setWelcomeLBL:nil];
    [super viewDidUnload];
}

@end
