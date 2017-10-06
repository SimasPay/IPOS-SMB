//
//  BillInquiryViewController.m
//  Simobi
//
//  Created by Ravi on 03/04/14.
//  Copyright (c) 2014 Mfino. All rights reserved.
//

#import "BillInquiryViewController.h"
#import "NSString+Extension.h"
#import  "DialogHUD.h"

@interface BillInquiryViewController ()

@property (retain)UITextField *amountField;
@end

@implementation BillInquiryViewController

@synthesize amountField,responseData;

#pragma mark - View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGFloat yPOS,padding = 0.0f;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))  {
        
        yPOS = 150.0f;
    } else {
        yPOS = 80.0f;
        
    }
    padding = 20.0f;
    
//   // self.responseData = [NSMutableDictionary dictionary];
//    [responseData setObject:@"Dear Subscriber your bill amount is 1.00" forKey:@"message"];
//    [responseData setObject:@"|PAYMENT : Axis Postpaid |IDPEL : 628382244000 |NAME : ARIEF SUSANTO MULAWARMAN |BILLING AMT: RP. 11.111 |ADMIN BANK : RP. 0 |PAYMENT AMT: RP. 11.111 | |" forKey:@"additionalInfo"];
//    [responseData setObject:@"1.0" forKey:@"amount"];


    NSString *additionalInfo = [[self.responseData objectForKey:@"additionalInfo"] stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
    
    BOOL isenglish = [[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH];
    NSString *otherMessage = isenglish ? @"Please input payment amount" : @"Masukkan jumlah pembayaran";
    NSString *messageText = [NSString stringWithFormat:@"%@\n\n%@\n\n\n%@",[self.responseData objectForKey:@"message"],otherMessage,additionalInfo];
    
    //CONDITIONLOG(DEBUG_MODE,@"Message Text:%@",responseData);
    float height = [self heightForText:messageText withFont:[UIFont boldSystemFontOfSize:13.0f]];
    
    float additionalHeight = [self heightForText:additionalInfo withFont:[UIFont boldSystemFontOfSize:13.0f]];
    float normalnewHeight = [self heightForText:[NSString stringWithFormat:@"%@\n\n%@",[self.responseData objectForKey:@"message"],otherMessage] withFont:[UIFont boldSystemFontOfSize:13.0f]];

   // CONDITIONLOG(DEBUG_MODE,@"Additional Height:%f \n Normal Height:%f",additionalHeight,normalnewHeight);
    UIView *containerView = [ [ UIView alloc ] initWithFrame:CGRectMake(padding, yPOS, CGRectGetWidth(self.view.frame) - 2*padding, height + padding*2.75)];
    containerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView  = [ [ UIImageView alloc ] initWithImage:[ UIImage imageNamed:@"TRANSPARENT SCREEN.png" ] ];
    
    containerView.layer.cornerRadius = 15.0f;
    containerView.layer.borderWidth = 3.0f;
    containerView.layer.borderColor = [UIColor grayColor].CGColor;
   // containerView.frame = CGRectMake(padding, yPOS, CGRectGetWidth(self.view.frame) - 2*padding, height + padding*4);
    imgView.frame = CGRectMake(0.0, -1.0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame) + 2.0f);
    //    [self.view insertSubview:imgView atIndex:0];

    
    UILabel *textLBL = [[UILabel alloc] initWithFrame:CGRectMake(padding/2, padding/2, CGRectGetWidth(imgView.frame) - 2*padding/2, 64.0f)];
    textLBL.backgroundColor = [UIColor clearColor];
    textLBL.textColor = [UIColor whiteColor];
    textLBL.lineBreakMode = NSLineBreakByWordWrapping;
    textLBL.numberOfLines = 0;
    textLBL.text = messageText;
    
    //CONDITIONLOG(DEBUG_MODE,@"Parameters:%@",[[SimobiManager shareInstance] responseData]);
    textLBL.font = [UIFont boldSystemFontOfSize:13.0f];
    [containerView addSubview:textLBL];
    
    
    
    
    amountField = [[UITextField alloc] initWithFrame:CGRectMake(padding,85.0f, CGRectGetWidth(imgView.frame) - 2*padding, 30.0f)];
    
    amountField.keyboardType = UIKeyboardTypeNumberPad;
    amountField.borderStyle = UITextBorderStyleRoundedRect;
    amountField.text = [self.responseData objectForKey:@"amount"];
    [containerView addSubview:amountField];
    
    
    UIScrollView *additionalInfoScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(padding/4, CGRectGetMinY(amountField.frame) + CGRectGetHeight(amountField.frame) - 16.0f, CGRectGetWidth(imgView.frame) - 2*(padding/4), 156.0f)];
    additionalInfoScroll.backgroundColor = [UIColor clearColor];
    
//    additionalInfoScroll.layer.cornerRadius = 3.0f;
//    additionalInfoScroll.layer.borderColor  = [UIColor grayColor].CGColor;
//    additionalInfoScroll.layer.borderWidth  = 2.0f;
    
    UILabel *additionalTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding/2, 2.0f, CGRectGetWidth(imgView.frame) - 2*(padding/4), additionalHeight - 15.0f)];
    additionalTextLabel.backgroundColor = [UIColor clearColor];
    additionalTextLabel.textColor = [UIColor whiteColor];
    additionalTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    additionalTextLabel.numberOfLines = 0;
    additionalTextLabel.text = additionalInfo;
    additionalTextLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [additionalInfoScroll addSubview:additionalTextLabel];
    
    [containerView addSubview:additionalInfoScroll];

    [additionalInfoScroll setContentSize:CGSizeMake(CGRectGetWidth(additionalInfoScroll.frame), additionalHeight)];
    NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];

    //Submit Button
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //submitButton.frame = CGRectMake((CGRectGetWidth(imgView.frame) - DIALOG_BUTTON_SIZE.width)/2,CGRectGetHeight(imgView.frame) - DIALOG_BUTTON_SIZE.height - padding/4, DIALOG_BUTTON_SIZE.width, DIALOG_BUTTON_SIZE.height);
    
    submitButton.frame = CGRectMake(padding,CGRectGetHeight(imgView.frame) - DIALOG_BUTTON_SIZE.height - padding/2, DIALOG_BUTTON_SIZE.width + 6.0f, DIALOG_BUTTON_SIZE.height);

    [submitButton setBackgroundImage:[UIImage imageNamed:@"button_empty.png"] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [submitButton setTitle:[textDict objectForKey:CONFIRM] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitBTNAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:submitButton];
    
    //Cancel
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake((CGRectGetWidth(imgView.frame) - DIALOG_BUTTON_SIZE.width) - padding,CGRectGetHeight(imgView.frame) - DIALOG_BUTTON_SIZE.height - padding/2, DIALOG_BUTTON_SIZE.width, DIALOG_BUTTON_SIZE.height);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"button_empty.png"] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [cancelButton setTitle:[textDict objectForKey:CANCEL] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBTNAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:cancelButton];

    
    [containerView insertSubview:imgView atIndex:0];
    
    [self.view addSubview:containerView];


}



-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self showHomeButton];
    [self showBackButton];
    
    NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
    
    
    [self title:[textDict objectForKey:PAYMENT]];
}

#pragma mark - Button Action

- (void)submitBTNAction
{
    
    [self.amountField resignFirstResponder];
    [ [ [ SimobiManager shareInstance ] responseData ] setObject:self.amountField.text forKey:AMOUNT ];
    [ [ [ SimobiManager shareInstance ] responseData ] setObject:TXN_INQUIRY_PAYMENT forKey:TXNNAME ];
    [self performServiceCallWithParameters:[ [ SimobiManager shareInstance ] responseData] ];

}



- (void)cancelBTNAction
{

    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - Convenience Methods

- (float)heightForText:(NSString *)textStr withFont:(UIFont *)labelFont

{
    CGSize _expectedSize = CGSizeMake(280.0f, FLT_MAX);
    
    CGSize _finalSize = [textStr sizeWithFont:labelFont constrainedToSize:_expectedSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return _finalSize.height + 10.0f;
}

- (void)tapped
{
    [self.amountField resignFirstResponder];
}

#pragma mark - Service Call


- (void)performServiceCallWithParameters:(NSDictionary *)params

{
    NSString *urlString = [ SIMOBI_URL constructUrlStringWithParams:params ];
    
    [ProgressHUD displayWithMessage:@"Loading"];
    
    
    [SimobiServiceModel connectURL:urlString successBlock:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD hide];
            NSString *code = [[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"code"];

            
            if ([code isEqualToString:SIMOBI_PAYMENT_SUCCESSCODE]) {
            
                   [[[SimobiManager shareInstance] responseData] setObject:@"true" forKey:CONFIRMED];
                   [[[SimobiManager shareInstance] responseData] setObject:[[[response objectForKey:@"response"] objectForKey:PARENTTXNID] objectForKey:@"text"]      forKey:PARENTTXNID];//parentTxnID
                   [[[SimobiManager shareInstance] responseData] setObject:[[[response objectForKey:@"response"] objectForKey:@"transferID"] objectForKey:@"text"]     forKey:TRANSFERID];
                [[[SimobiManager shareInstance] responseData]setObject:TXN_CONFIRM_PAYMENT forKey:TXNNAME];
                [[[SimobiManager shareInstance] responseData] removeObjectForKey:SOURCEPIN];

                NSString *messaage = OBJECTFORKEY(response, @"message");
                
                if (OBJECTFORKEY(response, @"AdditionalInfo")) {
                    messaage = [messaage stringByAppendingString:@"\n"];
                    
                    NSString *additionalInfo = OBJECTFORKEY(response, @"AdditionalInfo");
                    messaage = [messaage stringByAppendingString:[additionalInfo stringByReplacingOccurrencesOfString:@"|" withString:@"\n"]];
                }
                
                [DialogHUD displayWithMessage:messaage withservice:Service_PAYMENT];

            } else if ([code isEqualToString:SIMOBI_LOGIN_EXPIRE_CODE]) {
                
                [self reLoginAlertWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"]];
                return ;
                
            } else  {
               
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
