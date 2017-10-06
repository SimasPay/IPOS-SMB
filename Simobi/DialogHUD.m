//
//  DialogView.m
//  Simobi
//
//  Created by Ravi on 11/8/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "DialogHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "SimobiConstants.h"
#import "SimobiManager.h"
#import "SimobiServiceModel.h"
#import "NSString+Extension.h"
#import "ProgressHUD.h"
#import "SimobiAlert.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "AppDelegate.h"
#import "BaseViewController.h"

#define FONT [UIFont boldSystemFontOfSize:14.0f]
#define TITLE_LABEL_SIZE CGSizeMake(130.0f, 35.0f)
#define TITLE_FONT [UIFont fontWithName:@"Helvetica" size:17.0f]

@interface DialogView: UIView <UIAlertViewDelegate,UITextFieldDelegate>

@property (copy )  NSString *message;
@property (retain) NSDictionary *params;
@property (retain) UITextField *otpField;

@property (assign) Service type;
@property (assign) BOOL submitted;
@property (assign) CGRect viewFrame;

- (void)destroy;
@end

@implementation DialogView

@synthesize type,submitted,otpField;

-(id)initWithMessage:(NSString *)description frame:(CGRect)frame serviceType:(Service) service
{
    self = [ super initWithFrame:frame ];
    
    if ( self )
    {
        self.message     = description;
        self.type        = service;
        self.submitted   = NO;
        // make sure we "listen" for the keyboard so we can adjust the underlying view
        [ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardWillShowNotification object:nil ];
        [ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil ];
    }
    
    return self;
}


-(id)initWithParameters:(NSDictionary *)parameters frame:(CGRect)frame serviceType:(Service) service
{
    self = [ super initWithFrame:frame ];
    
    if ( self )
    {
        self.type      = service;
        self.params    = parameters;
        self.submitted = NO;
        self.message   = nil;
        // make sure we "listen" for the keyboard so we can adjust the underlying view
        [ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardWillShowNotification object:nil ];
        [ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil ];
        
    }
    
    return self;
    
}

- (void)tapped

{
    if (self.otpField) {
        [otpField resignFirstResponder];
    }
}
//get the height of label based on it's text

- (float)heightForText:(NSString *)textStr withFont:(UIFont *)labelFont

{
    CGSize _expectedSize = CGSizeMake(280.0f, FLT_MAX);
    
    CGSize _finalSize = [textStr sizeWithFont:labelFont constrainedToSize:_expectedSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return _finalSize.height;
}

- (NSString *)getTitle
{
    
    NSString *key = nil;
    switch (self.type) {
        case Service_BALANCE:{
            key = BALANCE;
            
        }
            break;
        case Service_TRANSACTION: {
            key = TRANSACTION;
            
        }
            break;
        case Service_PURCHASE:{
            key = PURCHASE;
            
        }
            break;
        case Service_PAYMENT:{
            key = PAYMENT;
            
        }
            break;
        case Service_SELFBANK:{
            key = TRANSFER;
            
        }
            break;
        case Service_ACTIVATION:{
            key = ACTIVATION;
        }
            break;
            
        case Service_OTHERBANK: {
            key = TRANSFER;
            
        }
            break;
        case Service_CHANGEPIN: {
            key = CHANGEPIN;
            
        }
            break;
            
            
        default:{
            key = @"NIL";
        }
            break;
    }
    
    NSDictionary *testData = [ [ SimobiManager shareInstance  ] textDataForLanguage ];
    return [testData objectForKey:key];
    
}

//layout subviews
- (void)layoutSubviews
{
    
    @autoreleasepool {
        
        [ self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) ];
        //CONDITIONLOG(DEBUG_MODE,@"Message:%@",self.message);
        //         UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - TITLE_LABEL_SIZE.width)/2, 15.0f,TITLE_LABEL_SIZE.width, TITLE_LABEL_SIZE.height)];
        //         //titleLabel.center = CGPointMake(self.center.x, 125.0f);
        //         titleLabel.font      = [UIFont boldSystemFontOfSize:17.0];
        //         titleLabel.text      = [self getTitle];
        //        titleLabel.textAlignment = NSTextAlignmentCenter;
        //         titleLabel.textColor = [UIColor whiteColor];
        //         [self addSubview:titleLabel];
        
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
        
        
        CGFloat padding = 20.0f;
        
        CGFloat height   = [self heightForText:self.message withFont:FONT];
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(padding, 55.0f, CGRectGetWidth(self.frame) - padding*2, 400.0f)];//height + padding + DIALOG_BUTTON_SIZE.height
        [scroll setUserInteractionEnabled:YES];
        scroll.pagingEnabled = NO;
        scroll.bounces = NO;
        [scroll setCanCancelContentTouches:NO];
        scroll.clipsToBounds=YES;
        scroll.layer.cornerRadius = 4.0f;
        scroll.layer.borderColor = [UIColor lightGrayColor].CGColor;
        scroll.layer.borderWidth = 3.0f;
        //set background image
        
        CGRect _frame = [UIApplication sharedApplication].keyWindow.bounds;
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
        backgroundView.frame        = _frame;
        [self insertSubview:backgroundView atIndex:0];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [self addGestureRecognizer:tapGesture];
        [self addSubview:scroll];
        
        [self insertSubview:scroll atIndex:1];
        // [scroll setBackgroundColor:[UIColor redColor]];
        //set transparent image
        UIImageView *dialog           = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TRANSPARENT SCREEN.png"]];
        
        
        dialog.userInteractionEnabled = YES;
        //CGRect _parentFrame = self.frame;
        
        
        dialog.frame = CGRectMake(padding, 150.0f, CGRectGetWidth(self.frame) - padding*2, height + padding + DIALOG_BUTTON_SIZE.height);
        
        CGFloat labelWidth = CGRectGetWidth(dialog.frame) - 20.0f;
        
        UILabel *messageLabel      = [[UILabel alloc] init];
        messageLabel.frame         = CGRectMake((CGRectGetWidth(scroll.frame) - labelWidth)/2, 15.0f, labelWidth, height + padding);
        messageLabel.font          = FONT;
        messageLabel.textColor     = [UIColor whiteColor];
        messageLabel.text          = self.message;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentLeft;
        messageLabel.backgroundColor = [UIColor clearColor];
        
        [scroll addSubview:messageLabel];
        
        if (self.type != Service_TRANSACTION)
            messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        BOOL isEnglish = [[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH];
            
        if (((self.type == Service_TRANSFER) || (self.type == Service_UANGKU) || (self.type == Service_PAYMENT) || (self.type == Service_PURCHASE) || (self.type == Service_ACTIVATION) || (self.type == Service_CHANGEPIN)|| (self.type == Service_REACTIVATION) || (self.type == SERVICE_FLASHIZ))&& (!self.submitted)) {
            
            CGFloat finalHeight = 0.0f;
            if (self.type == Service_TRANSFER) {
                
                [messageLabel setHidden:YES];
                CGFloat lblHeight   = 25.0f;
                NSArray *keyArray = [NSArray arrayWithObjects: @"Account owner",@"Destination bank",@"Destination number",@"Amount", nil];
                NSArray *keyArrayBahasa = [NSArray arrayWithObjects: @"Pemilik Rekening",@"Bank Tujuan",@"Nomor Tujuan",@"Jumlah", nil];
           
                for (int i = 0;i < 4;i ++) {
                    
                    //RIGHT LABLE CRAETION
                    UILabel *textLabel        = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, lblHeight*i + 10.0f, 135.0f, 25.0f)];
                    textLabel.font            = FONT;
                    textLabel.text            = isEnglish? [keyArray objectAtIndex:i] : [keyArrayBahasa objectAtIndex:i];
                    textLabel.textColor       = [UIColor whiteColor];
                    textLabel.backgroundColor = [UIColor clearColor];
                    [scroll addSubview:textLabel];
                    
                    //LEFT LABLE CRAETION
                    UILabel *detailTextLabel        = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(scroll.frame) - 120.0f - 10.0f, lblHeight*i + 10.0f, 120.0f, 25.0f)];
                    detailTextLabel.font            = FONT;
                    detailTextLabel.text            = [NSString stringWithFormat:@": %@",[self.params objectForKey:[keyArray objectAtIndex:i]]];
                    detailTextLabel.textColor       = [UIColor whiteColor];
                    detailTextLabel.lineBreakMode   = NSLineBreakByWordWrapping;
                    detailTextLabel.backgroundColor = [UIColor clearColor];
                    [scroll addSubview:detailTextLabel];
                    
                    
                    finalHeight = lblHeight*i + 10.0f;
                    
                }
                
                finalHeight = finalHeight + padding*1.5;
                
            } else if(self.type == Service_UANGKU){
            
                [messageLabel setHidden:YES];
                CGFloat lblHeight   = 25.0f;
                NSArray *keyArray = [NSArray arrayWithObjects:@"Name",@"Mobile Number",@"Amount", nil];
                NSArray *keyArrayBahasa = [NSArray arrayWithObjects:@"Nama",@"Nomor HP",@"Jumlah", nil];
                for (int i = 0;i < 3;i ++) {
                    
                    //RIGHT LABLE CRAETION
                    UILabel *textLabel        = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, lblHeight*i + 10.0f, 135.0f, 25.0f)];
                    textLabel.font            = FONT;
                    textLabel.text            = isEnglish? [keyArray objectAtIndex:i] : [keyArrayBahasa objectAtIndex:i];
                    textLabel.textColor       = [UIColor whiteColor];
                    textLabel.backgroundColor = [UIColor clearColor];
                    [scroll addSubview:textLabel];
                    
                    //LEFT LABLE CRAETION
                    UILabel *detailTextLabel        = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(scroll.frame) - 120.0f - 10.0f, lblHeight*i + 10.0f, 120.0f, 25.0f)];
                    detailTextLabel.font            = FONT;
                    detailTextLabel.text            = [NSString stringWithFormat:@": %@",[self.params objectForKey:[keyArrayBahasa objectAtIndex:i]]];
                    detailTextLabel.textColor       = [UIColor whiteColor];
                    detailTextLabel.lineBreakMode   = NSLineBreakByWordWrapping;
                    detailTextLabel.backgroundColor = [UIColor clearColor];
                    [scroll addSubview:detailTextLabel];
                    
                    
                    finalHeight = lblHeight*i + 10.0f;
                    
                }
                
                finalHeight = finalHeight + padding*1.5;

            
            
            
            }
            else{
                
                finalHeight = messageLabel.frame.origin.y + [self heightForText:self.message withFont:FONT];
                
            }
            
            finalHeight = (finalHeight < 120.0f) ? 120.0f : finalHeight;
            float height = 0.0f;
            float max_Y_POS = 50.0f;
            
            if (IS_IPHONE_5) {
                height = 270.0f;
            } else {
                height = 180.0f;
                
            }
            
            finalHeight = (finalHeight > height) ? height : finalHeight;
            scroll.frame = CGRectMake(padding, max_Y_POS, CGRectGetWidth(self.frame) - padding*2, finalHeight);
            
            
            
            UILabel *otpLBL = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - CGRectGetWidth(dialog.frame))/2, scroll.frame.origin.y + CGRectGetHeight(scroll.frame) +padding/1.5, CGRectGetWidth(dialog.frame), 60.0f)];
            otpLBL.textAlignment = NSTextAlignmentCenter;
            
            CGRect _otpLBLFrame = otpLBL.frame;
            float sipHeight = 0.0f;
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                //max_Y_POS = 75.0f;
                sipHeight = padding*2;
            } else
            {
                // max_Y_POS = 20.0f;
                _otpLBLFrame.origin.y -= padding;
                sipHeight = padding/2;
            }
            otpLBL.text          = isEnglish? [NSString stringWithFormat:@"%@",OTP_MESSAGE] :[NSString stringWithFormat:@"%@", OTP_MESSAGE_BAHASA];
            
            otpLBL.frame = _otpLBLFrame;
            otpLBL.lineBreakMode = NSLineBreakByWordWrapping;
            otpLBL.numberOfLines = 0;
            otpLBL.textColor     = [UIColor whiteColor];
            otpLBL.backgroundColor = [UIColor clearColor];
            otpLBL.font          = [UIFont boldSystemFontOfSize:16.0f];
            [self addSubview:otpLBL];
            
            
            otpField = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)- 100)/2, otpLBL.frame.origin.y + CGRectGetHeight(otpLBL.frame), 100.0f, 40.0f)];
            otpField.placeholder = @"Enter code";
            otpField.borderStyle = UITextBorderStyleRoundedRect;
            otpField.textAlignment = NSTextAlignmentCenter;
            otpField.textColor = [UIColor blackColor];
            otpField.delegate = self;
            otpField.tag = 200;
            otpField.keyboardType = UIKeyboardTypeNumberPad;
            otpField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            otpField.secureTextEntry = YES;
            [self addSubview:otpField];
            
            
            //create confirm button
            UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            ButtonImage(confirmBtn, @"button_empty.png");
            [confirmBtn setTitle:isEnglish? @"Confirm" : @"Konfirmasi"  forState:UIControlStateNormal];
            [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
            [confirmBtn addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            confirmBtn.frame = CGRectMake(CGRectGetWidth(self.frame)/2 + (CGRectGetWidth(self.frame)/2 -DIALOG_BUTTON_SIZE.width - padding * 2), CGRectGetHeight(otpField.frame) + otpField.frame.origin.y + padding /3 + 3.0f
                                          , DIALOG_BUTTON_SIZE.width, DIALOG_BUTTON_SIZE.height);
            [self addSubview:confirmBtn];
            
            
            //create cancel button
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            ButtonImage(cancelBtn, @"button_empty.png");
            [cancelBtn setTitle:isEnglish? @"Cancel": @"Batal"  forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
            [cancelBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cancelBtn.frame =CGRectMake(CGRectGetMinX(self.frame) + padding * 2, CGRectGetHeight(otpField.frame) + otpField.frame.origin.y+padding/3+3.0f, DIALOG_BUTTON_SIZE.width, DIALOG_BUTTON_SIZE.height);
            
            //CONDITIONLOG(DEBUG_MODE,@"CancerlButton Frmwe:%@",NSStringFromCGRect(self.frame));
            [self addSubview:cancelBtn];
            
            // float maxHeight = CGRectGetHeight(otpField.frame) + otpField.frame.origin.y+padding/6+3.0f + DIALOG_BUTTON_SIZE.height;
            //CONDITIONLOG(DEBUG_MODE,@"MAX Float:%f VireFrame:%f",maxHeight,(CGRectGetHeight(self.frame) - max_Y_POS- DIALOG_BUTTON_SIZE.height - padding*2));
            //CONDITIONLOG(DEBUG_MODE,@"ScrollFRame:%@",NSStringFromCGRect(scroll.frame));
            scroll.contentSize = CGSizeMake(CGRectGetWidth(scroll.frame), messageLabel.frame.origin.y + CGRectGetHeight(messageLabel.frame));
            
        } else {
            
            CGFloat dialogheight = messageLabel.frame.origin.y + CGRectGetHeight(messageLabel.frame)+ padding;
            
            //CONDITIONLOG(DEBUG_MODE,@"dialogheight %f",dialogheight);
            if (IS_IPHONE_5) {
                
                if (dialogheight > 300.0) {
                    dialogheight = 300.0;
                }
                
            } else {
                if (dialogheight > 250.0) {
                    dialogheight = 250.0;
                }
                
            }
            float _Y = 100.0f;
            if (((self.type == Service_PAYMENT) || (self.type == Service_PURCHASE)) && self.submitted) {
                _Y = (dialogheight < 150.0f) ? 75.0f : 20.0f;
            }
            
            if (self.type == Service_TRANSACTION)
            {
                
                
                if (IS_IPHONE_4_OR_LESS) {
                    scroll.frame = CGRectMake(padding, 35.0f, CGRectGetWidth(self.frame) - padding*2, 250);
                }else if (IS_IPHONE_5)
                {
                    scroll.frame = CGRectMake(padding, 35.0f, CGRectGetWidth(self.frame) - padding*2, 300.0f);
                }else if (IS_IPHONE_6 || IS_IPHONE_6P)
                {
                    scroll.frame = CGRectMake(padding, 35.0f, CGRectGetWidth(self.frame) - padding*2, 400.0f);
                }
                
                CGRect currentFrame = messageLabel.frame;
                CGSize max = CGSizeMake(messageLabel.frame.size.width, 500);
                CGSize expected = [messageLabel.text boundingRectWithSize:max
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName: messageLabel.font}
                                                                  context:nil].size;
                currentFrame.size.height = expected.height;
                messageLabel.frame = currentFrame;
                
            }else{
                scroll.frame = CGRectMake(padding, _Y, CGRectGetWidth(scroll.frame), dialogheight);
            }

            
            
            //create ok button
            UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //button_empty.png
            if (self.type == Service_ACTIVATION || self.type == Service_RESETPIN) {
                [OKBtn setBackgroundImage:[UIImage imageNamed:@"button_empty.png"] forState:UIControlStateNormal];
                [OKBtn setTitle:@"OK" forState:UIControlStateNormal];
            } else {
                [OKBtn setBackgroundImage:[UIImage imageNamed:@"button_empty.png"] forState:UIControlStateNormal];
            }
            
            // ButtonImage(OKBtn, (self.type == Service_ACTIVATION || self.type == Service_RESETPIN ) ? @"BUTTON LOGIN.png" : @"button_empty.png");
            if (self.type != Service_ACTIVATION && self.type != Service_RESETPIN) {
                [OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [OKBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:19.0f]];
                [OKBtn setTitle:@"OK" forState:UIControlStateNormal];
            }
            if (self.type == Service_ACTIVATION || self.type == Service_RESETPIN ||  self.type == Service_REACTIVATION)
                self.submitted = YES;
            
            [OKBtn addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            OKBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - DIALOG_BUTTON_SIZE.width)/2, CGRectGetHeight(scroll.frame)+ scroll.frame.origin.y+ padding, DIALOG_BUTTON_SIZE.width, DIALOG_BUTTON_SIZE.height);
            [self addSubview:OKBtn];
            
            scroll.contentSize = CGSizeMake(CGRectGetWidth(scroll.frame), messageLabel.frame.origin.y + CGRectGetHeight(messageLabel.frame));
            
        }
        
    }
    if (self.type ==  SERVICE_FLASHIZ) {
        CGRect frame = self.frame;
        frame.origin = CGPointZero;
        self.frame = frame;
    }

}


- (void)confirmButtonAction:(id)sender
{
    
    [self.otpField resignFirstResponder];
    // NSString *key = (self.type == Service_ACTIVATION) ? OTP : MFAOTP;
    //   NSString *otp = [[[SimobiManager shareInstance] responseData] objectForKey:key];
    
    if (self.otpField.text.length) {
        
        if (self.type == SERVICE_FLASHIZ) {
            
            NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:self.otpField.text,@"OTPTEXT",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashizConfirmation" object:self userInfo:dataDict];
            [DialogHUD hide];
            
        }else
            [self  performserviceCall];
        
    } else {
        
        [SimobiAlert showAlertWithMessage:@"please enter simobi code"];
    }
}
- (void)cancelButtonAction:(id)sender
{
    
    if (self.type == SERVICE_FLASHIZ) {
        
        NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"OTPTEXT",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashizConfirmation" object:self userInfo:dataDict];
        [DialogHUD hide];
        
    }
    
    [DialogHUD hide];
    
}
- (void)okButtonAction:(id)senders
{
    if (self.submitted) {
        [DialogHUD hide];
        if (self.type == Service_CHANGEPIN || self.type == Service_ACTIVATION || self.type == Service_RESETPIN || self.type == Service_REACTIVATION) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCHANGEPINNOTIFICATION object:Nil];
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSUCCESSTRANASACTION object:Nil];
        }
    } else {
        [DialogHUD hide];
    }
    
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
            
            NSString *code = [[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"code"];
            
            if ([code isEqualToString:SIMOBI_LOGIN_EXPIRE_CODE]) {
                [DialogHUD hide];
                AppDelegate *delegate =  [UIApplication sharedApplication].delegate;
                [((BaseViewController *)delegate.navigationController.childViewControllers.lastObject) reLoginAlertWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"]];
                return;
            }
            
            self.message   = [[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"];
            
            self.message = [ self.message stringByAppendingString:@"\n"];
            
            if ([[response objectForKey:@"response"] objectForKey:@"AdditionalInfo"]) {
                NSString *additionalInfo = OBJECTFORKEY(response, @"AdditionalInfo");
                self.message = [self.message stringByAppendingString:[additionalInfo stringByReplacingOccurrencesOfString:@"|" withString:@"\n"]];
            }
            //CONDITIONLOG(DEBUG_MODE,@"Response:%@",response);
            self.submitted = YES;
            
            if (self.type == Service_CHANGEPIN && [code isEqualToString:@"26"]) {
                
                NSString *pin = [[SimobiManager shareInstance] pIN];
                [[SimobiManager shareInstance] setSourcePIN:pin];
                //CONDITIONLOG(DEBUG_MODE,@"RESET PIN:%@",[[SimobiManager shareInstance] pIN]);
                //CONDITIONLOG(DEBUG_MODE,@"OL:D:%@  NewPIN:%@",[[SimobiManager shareInstance] sourceMDN],[[SimobiManager shareInstance] sourceMDN]);
            } else if (self.type == Service_CHANGEPIN && [code isEqualToString:@"2000"]) {
                [SimobiAlert showAlertWithMessage:self.message];
                return;
            }
            [self layoutSubviews];
            
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD hide];
            
            
            if ((self.type == Service_TRANSFER) || (self.type == Service_TRANSFER)|| (self.type == Service_PAYMENT) || (self.type == Service_PURCHASE))
            {
                NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR_FINANCE]];
            }else{
                NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
            }
            
            
            /*if (error.code == NSURLErrorTimedOut) {
             // Handle time out here
             NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
             [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
             }else{
             [SimobiAlert showAlertWithMessage:error.localizedDescription];
             }*/
            
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

static DialogView *_dialogView = nil;

@implementation DialogHUD
+(void)displayWithMessage:(NSString *)message withservice:(Service)service
{
    [self displayWithMessage:message withservice:service withData:nil];
}

+(void)displayWithMessage:(NSString *)message withservice:(Service)service withData:(NSDictionary *)data
{
    UIView *view = SIMOBI_KEY_WINDOW;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nil != _dialogView) {
            
            [_dialogView removeFromSuperview];
            _dialogView = nil;
        }
        CGRect _frame = view.bounds;
        _frame.origin.y += _frame.size.height + 10.0f;
        
        if (service == Service_TRANSACTION || service == Service_BALANCE) {
            // if service == transaction
            BOOL isEnglish = [[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH];
            
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            CGRect finalFrame = CGRectMake(0, 64, screenSize.width, screenSize.height - 64);
            CGRect startFrame = CGRectMake(0, screenSize.height, screenSize.width, screenSize.height - 64);
            float padding = 20;
            
            UIView *temp = [[UIView alloc] initWithFrame:startFrame];
            CGRect _frame = [UIApplication sharedApplication].keyWindow.bounds;
            UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
            backgroundView.frame = _frame;
            [temp addSubview:backgroundView];
            [view addSubview:temp];
            
            
            //create ok button
            UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [OKBtn setBackgroundImage:[UIImage imageNamed:@"button_empty.png"] forState:UIControlStateNormal];
            [OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [OKBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:19.0f]];
            [OKBtn setTitle:@"OK" forState:UIControlStateNormal];
            
            [OKBtn addTarget:temp action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
            
            if (service == Service_TRANSACTION) {
                float heightScroll = screenSize.height - finalFrame.origin.y - 100 - padding * 2;
                UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(padding, padding, screenSize.width - padding * 2, screenSize.height - finalFrame.origin.y - 100 - padding * 2)];
                scroll.clipsToBounds=YES;
                scroll.layer.cornerRadius = 4.0f;
                scroll.layer.borderColor = [UIColor lightGrayColor].CGColor;
                scroll.layer.borderWidth = 3.0f;
                [temp addSubview:scroll];
                
                float y = 0;
                if (data[@"transactionDetails"]) {
                    if (data[@"transactionDetails"][@"transactionDetail"]) {
                        id temp = data[@"transactionDetails"][@"transactionDetail"];
                        NSArray *details;
                        if ([temp isKindOfClass:[NSArray class]]) {
                            details = temp;
                        } else {
                            details = @[temp];
                        }
                        
                        y += padding / 2;
                        BOOL isfirstRow = true;
                        details = [@[@{
                                         @"transactionType" : @{@"text" : isEnglish ? @"Trx Type" : @"Tipe Trx"},
                                         @"transactionTime" : @{@"text" : isEnglish ? @"Date" : @"Tanggal"},
                                         @"amount" : @{@"text" : isEnglish ? @"Amount" : @"Jumlah"},
                                    },] arrayByAddingObjectsFromArray:details];
                        for (NSDictionary *dict in details) {
                            NSString *amount = dict[@"amount"][@"text"];
                            NSString *transactionType = dict[@"transactionType"][@"text"];
                            NSString *transactionTime = dict[@"transactionTime"][@"text"];
                            
                            NSString *codeTransactionType = @"";
                            if (transactionType.length > 4 && !isfirstRow) {
                                // means have (C)
                                codeTransactionType = [transactionType substringFromIndex:transactionType.length - 3];
                                transactionType = [transactionType stringByReplacingOccurrencesOfString:codeTransactionType withString:@""];   
                            }
                            
                            UIFont *font = [UIFont systemFontOfSize:11.5f];
                            if (isfirstRow) {
                                font = [UIFont boldSystemFontOfSize:11.5f];
                            } else {
                                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                                [format setDateFormat:@"yyyyMMdd"];
                                NSDate *date = [format dateFromString:transactionTime];
                                [format setDateFormat:@"dd/MM/yy"];
                                transactionTime = [format stringFromDate:date];
                            }
                            
                            CGRect frameFirst = CGRectMake(padding / 2, y, 60, 21);
                            UILabel *lbl = [[UILabel alloc] initWithFrame:frameFirst];
                            lbl.textColor = [UIColor whiteColor];
                            lbl.font = font;
                            lbl.text = transactionTime;
                            [scroll addSubview:lbl];
                            
                            float widthAmount = 70;
                            lbl = [[UILabel alloc] initWithFrame:CGRectMake(scroll.frame.size.width - widthAmount - padding / 2, y, widthAmount, 21)];
                            lbl.textColor = [UIColor whiteColor];
                            lbl.font = font;
                            lbl.textAlignment = NSTextAlignmentRight;
                            lbl.text = amount;
                            lbl.minimumScaleFactor = 0.25;
                            lbl.adjustsFontSizeToFitWidth = YES;
                            [scroll addSubview:lbl];
                            
                            CGRect tempFrame = lbl.frame;
                            lbl = [[UILabel alloc] initWithFrame:CGRectMake(tempFrame.origin.x - 50, y, 50, 21)];
                            lbl.textColor = [UIColor whiteColor];
                            lbl.font = font;
                            lbl.text = isfirstRow ? @"D/C" : [NSString stringWithFormat:@"%@   %@", codeTransactionType, isEnglish ? @"IDR" : @"Rp"];
                            [scroll addSubview:lbl];
                            
                            tempFrame = lbl.frame;
                            float width = scroll.frame.size.width - padding / 2 - (scroll.frame.size.width - tempFrame.origin.x) - frameFirst.size.width;
                            lbl = [[UILabel alloc] initWithFrame:CGRectMake(tempFrame.origin.x - width, y, width, 21)];
                            lbl.textColor = [UIColor whiteColor];
                            lbl.font = font;
                            lbl.text = transactionType;
                            [scroll addSubview:lbl];
                            
                            y += padding;
                            isfirstRow = false;
                        }
                    }
                }
                
                scroll.contentSize = CGSizeMake(0, y + padding / 2);
                float heightContent = y + padding / 2 ;
                if (heightContent >= heightScroll) {
                    CGRect frame = scroll.frame;
                    frame.size.height = heightScroll;
                    scroll.frame = frame;
                } else {
                    CGRect frame = scroll.frame;
                    frame.size.height = heightContent;
                    scroll.frame = frame;
                }
                
                OKBtn.frame = CGRectMake((screenSize.width - DIALOG_BUTTON_SIZE.width)/2, CGRectGetHeight(scroll.frame)+ scroll.frame.origin.y + padding, DIALOG_BUTTON_SIZE.width, 44.f);
                [temp addSubview:OKBtn];
            } else {
                // create container & content + add okBtn to container
                CGSize screenSize = [UIScreen mainScreen].bounds.size;
                float padding = 20;
                float top = 60;
                float width = screenSize.width - (2 * padding);
                UIView *viewBalance = [[UIView alloc]initWithFrame:CGRectMake(padding,top,width, 0)];
                viewBalance.layer.borderColor = [UIColor lightGrayColor].CGColor;
                viewBalance.layer.borderWidth = 3.0f;
                viewBalance.clipsToBounds=YES;
                viewBalance.layer.cornerRadius = 4.0f;
                [temp addSubview:viewBalance];
                NSString *amount = data[@"amount"][@"text"];
                NSString *transactionTime = data[@"transactionTime"][@"text"];
                NSString *accountNumber = data[@"accountNumber"][@"text"];
                NSLog(@"%@ %@",amount,transactionTime);
                NSArray *arrayData;
                arrayData = @[
                              @{@"key" : isEnglish ? @"Date/Time" : @"Tanggal/Waktu", @"value" :[NSString stringWithFormat:@": %@",transactionTime]},
                              @{@"key" : isEnglish ? @"Account No." : @"No. Rekening", @"value" :[NSString stringWithFormat:@": %@",accountNumber]},
                              @{@"key" : isEnglish ? @"Balance" : @"Saldo",@"value" :[NSString stringWithFormat:@": %@ %@", isEnglish ? @"IDR" : @"Rp",amount] },
                              ];

                float y = 0;
                for (NSDictionary *dic in arrayData) {
                    y += padding /2;
                    float heightLbl = 21.f;
                    
                    UILabel *keyLbl = [[UILabel alloc]initWithFrame:CGRectMake(padding, y, width / 2.7 , heightLbl)];
                    keyLbl.textColor = [UIColor whiteColor];
                    keyLbl.font = [UIFont systemFontOfSize:14.0f];
                    keyLbl.text = dic[@"key"];
                    [viewBalance addSubview:keyLbl];
                    
                    UILabel *valueLbl = [[UILabel alloc]initWithFrame:CGRectMake(padding + width /2.7 , y, width - padding + (width /3) , heightLbl)];
                    valueLbl.textColor = [UIColor whiteColor];
                    valueLbl.font = [UIFont systemFontOfSize:14.0f];
                    valueLbl.text = dic[@"value"];
                    [viewBalance addSubview:valueLbl];
                    
                    y += 10;
                }
                
                y += 21.f;
                OKBtn.frame = CGRectMake((width - DIALOG_BUTTON_SIZE.width)/2, y, DIALOG_BUTTON_SIZE.width, 44.f);
                [viewBalance addSubview:OKBtn];
                
                CGRect frame = viewBalance.frame;
                frame.size.height = OKBtn.frame.size.height + y + padding / 2;
                viewBalance.frame = frame;
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                temp.frame = finalFrame;
            }];
            return;
        }
        
        _dialogView = [[DialogView alloc] initWithMessage:message frame:_frame serviceType:service];
        
        //_dialogView.message = message;
        view.userInteractionEnabled = YES;
        _dialogView.userInteractionEnabled = YES;
        [view addSubview:_dialogView];
        [view bringSubviewToFront:_dialogView];
        
        
        [UIView animateWithDuration:.50f animations:^{
            //
            CGRect _finalFrame = view.frame;
            _finalFrame.origin.y += 64.0f;
            _dialogView.frame = _finalFrame;
            
        } completion:^(BOOL finished) {
            
            //CONDITIONLOG(DEBUG_MODE,@"");
        }];
    });
    
}



+(void)displayWithParameters:(NSDictionary *)params withservice:(Service)service

{
    
    UIView *view = [UIApplication sharedApplication].keyWindow;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nil != self) {
            
            _dialogView = nil;
        }
        CGRect _frame = view.bounds;
        _frame.origin.y += _frame.size.height + 10.0f;
        _dialogView = [[DialogView alloc] initWithParameters:params frame:_frame serviceType:service];
        
        //_dialogView.message = message;
        [view addSubview:_dialogView];
        [view bringSubviewToFront:_dialogView];
        
        
        [UIView animateWithDuration:.50f animations:^{
            //
            CGRect _finalFrame = view.frame;
            _finalFrame.origin.y += 64.0f;
            _dialogView.frame = _finalFrame;
            
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSUCCESSTRANASACTION object:nil];
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
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
@end






