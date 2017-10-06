//
//  AccountViewController.m
//  Simobi
//
//  Created by Ravi on 10/21/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "AccountViewController.h"
#import "NSString+Extension.h"
#import "ActivationViewController.h"
#import "LanguageViewController.h"
#import "DialogHUD.h"
#import "Reachability.h"


@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeMpinBtn;
@property (weak, nonatomic) IBOutlet UIButton *languageBtn;

@end

@implementation AccountViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self showBackButton];
    [self showHomeButton];
    
    //self.bgView.frame = CGRectMake(self.bgView.frame.origin.x,( CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.bgView.frame))/2 + 50.0f, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame));
    
    if (IS_IPHONE_5) {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y += 60;
        //self.bgView.frame = bgviewFrame;
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 100;
        self.bgView.frame = bgviewFrame;
    }else{
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y += 20;
    }
    self.balanceBtn.layer.cornerRadius = 10;
    self.balanceBtn.clipsToBounds = YES;
    self.historyBtn.layer.cornerRadius = 10;
    self.historyBtn.clipsToBounds = YES;
    self.changeMpinBtn.layer.cornerRadius = 10;
    self.changeMpinBtn.clipsToBounds = YES;
    self.languageBtn.layer.cornerRadius = 10;
    self.languageBtn.clipsToBounds = YES;
}


- (void)tapped

{
    // Tapped
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
    
    //CONDITIONLOG(DEBUG_MODE,@"TextData:%@",textDict);
    self.balanceLBL.text = [textDict objectForKey:BALANCE];
    self.transactionLBL.text = [textDict objectForKey:TRANSACTION];
    self.changePINLBL.text = [textDict objectForKey:CHANGEPIN];
    self.languageLBL.text = [textDict objectForKey:LANGUAGE];

    [self title:[textDict objectForKey:ACCOUNT]];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{

    [self setBalanceLBL:nil];
    [self setTransactionLBL:nil];
    [self setChangePINLBL:nil];
    [self setLanguageLBL:nil];
    [self setBgView:nil];
    
    [super viewWillUnload];
}


/*
 *Check Account Balance
 */
- (IBAction)balanceButtonAction:(id)sender
{
    
    
    //"https://dev.simobi.banksinarmas.com/webapi/sdynamic?channelID=7&txnName=CheckBalance&service=Bank&
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[[SimobiManager shareInstance] sourceMDN],SOURCEMDN,[[SimobiManager shareInstance] sourcePIN],SOURCEPIN,@"2",SOURCEPOCKETCODE,TXN_ACCOUNT_BALANCE,TXNNAME,SERVICE_BANK,SERVICE,nil];

    NSString *urlStr = [SIMOBI_URL constructUrlStringWithParams:params];
    [self processWithURLString:urlStr withservice:Service_BALANCE];

}

- (IBAction)transactionButtonAction:(id)sender
{

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[[SimobiManager shareInstance] sourceMDN],SOURCEMDN,[[SimobiManager shareInstance] sourcePIN],SOURCEPIN,@"2",SOURCEPOCKETCODE,TXN_ACCOUNT_HISTORY,TXNNAME,SERVICE_BANK,SERVICE,nil];
    
    NSString *urlStr = [SIMOBI_URL constructUrlStringWithParams:params];
    [self processWithURLString:urlStr withservice:Service_TRANSACTION];

}

- (IBAction)changemPinButtonAction:(id)sender {
    
    ActivationViewController *activityViewController = [[ActivationViewController alloc] initWithparent:ParentControllerTypeAccount];
    [self.navigationController pushViewController:activityViewController animated:YES];

}

- (IBAction)languageButtonAction:(id)sender
{
    
    LanguageViewController *languageVC = [[LanguageViewController alloc] initWithNibName:@"LanguageViewController" bundle:nil];
    UINavigationController *navVC      = [[UINavigationController alloc] initWithRootViewController:languageVC];
    [self.navigationController presentViewController:navVC animated:YES completion:Nil];
}


- (void)processWithURLString:(NSString *)url withservice:(Service)service
{
    
    Reachability *rechability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if ([rechability currentReachabilityStatus] == NotReachable) {
        
        [self noNetworkAlert];
        return;
    }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD displayWithMessage:@"Loading"];
        });
        
        [SimobiServiceModel connectURL:url successBlock:^(NSDictionary *response) {
            //
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CONDITIONLOG(DEBUG_MODE,@"Response:%@",response);
                
                [ProgressHUD hide];
                
                NSString *code = [[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"code"];
                
                if ([code isEqualToString:SIMOBI_LOGIN_EXPIRE_CODE]) {
                    [self reLoginAlertWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"]];
                    return;
                }
                
                if (([code isEqualToString:SIMOBI_SUCCESS_ACCOUNT_BALANCE_CODE]) || ([code isEqualToString:SIMOBI_SUCCESS_ACCOUNT_TRANSACTION_CODE])) {
                    [DialogHUD displayWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"] withservice:service withData:[response objectForKey:@"response"]];
                } else {
                    [SimobiAlert showAlertWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"] ];
                }
                
            });
            
            
        } failureBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD hide];
            });
            
            NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
            [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
            
            //[SimobiAlert showAlertWithMessage:error.localizedDescription];
        }];

}


@end
