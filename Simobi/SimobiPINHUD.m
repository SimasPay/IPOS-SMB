//
//  SimobiPINHUD.m
//  Simobi
//
//  Created by Rajesh Pothuraju on 04/10/15.
//  Copyright (c) 2015 Mfino. All rights reserved.
//

#import "SimobiPINHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "SimobiConstants.h"
#import "SimobiManager.h"
#import "SimobiServiceModel.h"
#import "NSString+Extension.h"
#import "ProgressHUD.h"
#import "SimobiAlert.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "XRSA.h"
#import "NSString+Extension.h"
#import "Reachability.h"

#define FONT [UIFont boldSystemFontOfSize:14.0f]
#define TITLE_LABEL_SIZE CGSizeMake(130.0f, 35.0f)
#define TITLE_FONT [UIFont fontWithName:@"Helvetica" size:17.0f]

@interface SimobiPinView: UIView <UIAlertViewDelegate,UITextFieldDelegate>
{
     UITextField *mpinTextField;
}
@property (copy )  NSString *message;
@property (retain) NSDictionary *params;

@property (nonatomic,weak)UIButton *backButton;
@property (nonatomic,weak)UIButton *homeButton;

@property (nonatomic,retain)UILabel *titleLable;

@property (assign) BOOL submitted;
@property (assign) CGRect viewFrame;

- (void)destroy;
@end

@implementation SimobiPinView

@synthesize submitted;

-(id)initWithMessage:(NSString *)description frame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    
    if ( self )
    {
        self.message     = description;
        self.submitted   = NO;
        // make sure we "listen" for the keyboard so we can adjust the underlying view
        //[ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardWillShowNotification object:nil ];
        //[ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil ];
    }
    
    return self;
}

- (void)tapped
{
    [mpinTextField resignFirstResponder];
}
//get the height of label based on it's text

- (float)heightForText:(NSString *)textStr withFont:(UIFont *)labelFont

{
    CGSize _expectedSize = CGSizeMake(280.0f, FLT_MAX);
    
    CGSize _finalSize = [textStr sizeWithFont:labelFont constrainedToSize:_expectedSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return _finalSize.height;
}



//layout subviews
- (void)layoutSubviews
{
    
    @autoreleasepool {
        
        [ self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) ];
        //CONDITIONLOG(DEBUG_MODE,@"Message:%@",self.message);
        
        UIImageView *backGroundImg = [[UIImageView alloc] initWithFrame:self.bounds];
        [backGroundImg setImage:[UIImage imageNamed:@"Background.png"]];
        [self insertSubview:backGroundImg atIndex:0];
        
        //Setup image to NavigationBar
       // UIImage *image = [UIImage imageNamed: @"TOPBAR.png"];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [self addGestureRecognizer:tapGesture];
        
        //Set Up Logo to NavigationBar
        UIBarButtonItem * item                = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sina_logo.png"]]];
        item.enabled                          = NO;
        //self.navigationItem.leftBarButtonItem = item;
        
        CGRect _backBtnFrame     = CGRectMake((CGRectGetWidth(self.frame) - 100.0f)/2, CGRectGetHeight(self.frame) - 30.0f - 20.0f, 80.0f , 45.0);
        
        
        //Set Up for Back Button
        
             float _YPOS = 25.0f;
        
          /*  self.backButton        = [UIButton buttonWithType:UIButtonTypeCustom];
            _backBtnFrame          = CGRectMake(15.0, _YPOS, 30.0, 30.0);
            self.backButton.frame  = _backBtnFrame;
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"BUTTON BACK WHITE.png"] forState:UIControlStateNormal];
            [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.backButton];
        
        //Set Up for Home Button
        
        
            self.homeButton       = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect _homeBtnFrame  = CGRectMake(270.0, _YPOS, 33.0, 33.0);
            self.homeButton.frame = _homeBtnFrame;
            [self.homeButton setBackgroundImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
            [self.homeButton addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.homeButton]; */
        
        NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
        
        //Set Up title Label
        CGPoint _center           = CGPointMake(self.center.x, _YPOS + 15.0f);
        
            _titleLable                    = [[UILabel alloc] initWithFrame:CGRectMake(120.0, _YPOS, 200, 30.0)];//(120.0, 25.0, 200, 30.0)
            _titleLable.font               = [UIFont boldSystemFontOfSize:17.0];
            _titleLable.textColor          = [UIColor whiteColor];
            _titleLable.textAlignment      = NSTextAlignmentCenter;
            _titleLable.center             = _center;
            _titleLable.text = [textDict objectForKey:PAYBYQR];
            _titleLable.backgroundColor    = [UIColor clearColor];
            [self addSubview:_titleLable];
        

        
        UIView *transperentView = [[UIView alloc] init];
        transperentView.userInteractionEnabled = YES;
        transperentView.frame = CGRectMake(15, 80, self.frame.size.width-30, self.frame.size.height-120-50);
        transperentView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
        transperentView.layer.borderColor = [UIColor blackColor].CGColor;
        transperentView.layer.borderWidth = .6;
        transperentView.layer.cornerRadius = 10;
        
        [self addSubview:transperentView];
        
        UILabel *messageLabel      = [[UILabel alloc] init];
        messageLabel.frame         = CGRectMake(15, 15.0f, transperentView.frame.size.width-30, 21);
        messageLabel.font          = [UIFont boldSystemFontOfSize:14.0f];
        messageLabel.textColor     = [UIColor whiteColor];
        messageLabel.text          = @"mPIN";
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentLeft;
        messageLabel.backgroundColor = [UIColor clearColor];
        [transperentView addSubview:messageLabel];
        
        
        mpinTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, messageLabel.frame.origin.y+messageLabel.frame.size.height, transperentView.frame.size.width-30, 31.0f)];
        // mpinTextField.placeholder = @"Enter code";
        mpinTextField.borderStyle = UITextBorderStyleRoundedRect;
        mpinTextField.textColor = [UIColor blackColor];
        mpinTextField.delegate = self;
        mpinTextField.tag = 200;
        mpinTextField.keyboardType = UIKeyboardTypeNumberPad;
        mpinTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        mpinTextField.secureTextEntry = YES;
        [transperentView addSubview:mpinTextField];
        
        BOOL isEnglish = [[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH];
        UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        submitButton.frame = CGRectMake(self.frame.size.width/2,mpinTextField.frame.origin.y+mpinTextField.frame.size.height+10, DIALOG_BUTTON_SIZE.width, DIALOG_BUTTON_SIZE.height);        [submitButton setBackgroundImage:[UIImage imageNamed:@"button_empty.png"] forState:UIControlStateNormal];
        submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [submitButton setTitle:[textDict objectForKey:SUBMIT] forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [transperentView addSubview:submitButton];
            
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ButtonImage(cancelBtn, @"button_empty.png");
        [cancelBtn setTitle:isEnglish? @"Cancel": @"Batal" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:19.0f]];
        [cancelBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.frame = CGRectMake(CGRectGetMinX(self.frame) + 52.0f, mpinTextField.frame.origin.y+mpinTextField.frame.size.height+10, DIALOG_BUTTON_SIZE.width, DIALOG_BUTTON_SIZE.height);
        [transperentView addSubview:cancelBtn];
    }
}

#pragma mark - CustomMethods

- (void)cancelButtonAction:(id)senders
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashizInqueryCancel" object:self userInfo:nil];
    
    
}
- (void)okButtonAction:(id)senders
{
    
    if (mpinTextField.text.length > 0) {
        [mpinTextField resignFirstResponder];
        NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:mpinTextField.text,@"PINTEXT",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashizInquery" object:self userInfo:dataDict];
        [SimobiPINHUD hide];
    }else
    {
        [SimobiAlert showAlertWithMessage:@"Please enter mPin"];
    }
    
    
    
    
  /*  Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if ([reachability currentReachabilityStatus] == NotReachable) {
        NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
        [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
        return;
    }
    
    
    
    // Start the notifier, which will cause the reachability object to retain itself!
    XRSA *rsa = [[XRSA alloc] initWithPublicKeyModulus:[[[SimobiManager shareInstance] publicKeyDict] objectForKey:@"modulus"] withPublicKeyExponent:[[[SimobiManager shareInstance] publicKeyDict] objectForKey:@"exponent"]];
    
    NSString *encryptedmPIN = [NSString string];
    if (rsa != nil) {
        encryptedmPIN = [rsa encryptToString:mpinTextField.text];
    } else {
    }
    
    [ProgressHUD displayWithMessage:@"Loading"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:[[SimobiManager shareInstance] sourceMDN]   forKey:@"sourceMDN"];
    [params setObject:encryptedmPIN forKey:@"authenticationString"];
    [params setObject:@"subapp"     forKey:@"apptype"];
    [params setObject:@"Login"      forKey:@"txnName"];
    [params setObject:@"Account"    forKey:@"service"];
    [params setObject:@"1.0"        forKey:@"appversion"];
    
    NSString *normalisedUrl =  [SIMOBI_URL constructUrlStringWithParams:params];
    CONDITIONLOG(DEBUG_MODE,@"normalisedUrl:%@",normalisedUrl);
    
    [SimobiServiceModel connectURL:normalisedUrl successBlock:^(NSDictionary *response) {
        [ProgressHUD hide];
        CONDITIONLOG(DEBUG_MODE,@"Response:%@",response);
        NSString *code = [[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"code"];
        if ([code isEqualToString:SIMOBI_SUCCESS_LOGIN_CODE]) {
            
            
            //[SimobiPINHUD hide];
            

        } else {
            [SimobiAlert showAlertWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"]];
        }
    }
                      failureBlock:^(NSError *error) {
                          
                          [ProgressHUD hide];
                          // [SimobiAlert showAlertWithMessage:error.localizedDescription];
                          NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                          [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
                          
                      }]; */
}

- (void)performserviceCall
{
    
    NSDictionary *params = [[SimobiManager shareInstance] responseData];
    [self performServiceCallWithURLString:[SIMOBI_URL constructUrlStringWithParams:params]];
    
    
}



- (void)performServiceCallWithURLString:(NSString *)urlStr
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD displayWithMessage:@"Loading"];
    });
    [SimobiServiceModel connectURL:urlStr successBlock:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [ProgressHUD hide];
            
                        [self layoutSubviews];
            
            NSString *code = [[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"code"];
            if ([code isEqualToString:SIMOBI_LOGIN_EXPIRE_CODE]) {
                AppDelegate *delegate =  [UIApplication sharedApplication].delegate;
                [((BaseViewController *)delegate.navigationController.childViewControllers.lastObject) reLoginAlertWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"]];
            }
            
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD hide];
            
            
            
            
        });
        
    }];
    
}



#pragma mark - UITextField Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 200){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 6) ? NO : YES;
    }
    else
        return YES;
}




- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [[[SimobiManager shareInstance] responseData] setObject:textField.text forKey:MFAOTP];
    
}

#pragma mark - Keyboard Handling


-(void)keyboardDidShowNotification:(NSNotification *)notification
{
    self.viewFrame = self.frame;
    
    NSTimeInterval interval = [ [ [ notification userInfo ] objectForKey:UIKeyboardAnimationDurationUserInfoKey ] doubleValue ];
    
    [ UIView animateWithDuration:interval animations:^{
        [self setFrame:CGRectMake(0, -95.0f, self.frame.size.width, self.frame.size.height)];
    } ];
}

-(void)keyboardWillHideNotification:(NSNotification *)notification
{
    NSTimeInterval interval = [ [ [ notification userInfo ] objectForKey:UIKeyboardAnimationDurationUserInfoKey ] doubleValue ];
    
    // [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [ UIView animateWithDuration:interval animations:^{
        [self setFrame:self.viewFrame];
    } ];
}


- (void)destroy
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
@end

static SimobiPinView *_dialogView = nil;

@implementation SimobiPINHUD

+(void)displayWithMessage:(NSString *)message

{
    UIView *view = SIMOBI_KEY_WINDOW;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nil != _dialogView) {
            
            [_dialogView removeFromSuperview];
            _dialogView = nil;
        }
        CGRect _frame = view.bounds;
        _frame.origin.y -= _frame.size.height + 10.0f;
        _dialogView = [[SimobiPinView alloc] initWithMessage:message frame:_frame];
        
        //_dialogView.message = message;
        view.userInteractionEnabled = YES;
        _dialogView.userInteractionEnabled = YES;
        [view addSubview:_dialogView];
        [view bringSubviewToFront:_dialogView];
        
        
        [UIView animateWithDuration:.50f animations:^{
            //
            CGRect _finalFrame = view.frame;
            //_finalFrame.origin.y += 64.0f;
//            
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//                //if ios 7 above
//                _finalFrame.origin.y = 0;
//            }
            _finalFrame.origin.y = 0;
            
            _dialogView.frame = _finalFrame;
            
        } completion:^(BOOL finished) {
            
            //CONDITIONLOG(DEBUG_MODE,@"");
        }];
    });
    
}
+(void)hide
{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.50f animations:^{
            //
            // UIViewAnimationCurveEaseIn;
            CGRect _frame = SIMOBI_KEY_WINDOW.frame;
            _frame.origin.y += _frame.size.height + 10.0f;
            _dialogView.frame = _frame;
            
        } completion:^(BOOL finished) {
            
            if (nil != _dialogView) {
                [_dialogView destroy];
                [_dialogView removeFromSuperview];
                _dialogView = nil;
            }
        }];
        
    });
    
    
}
@end