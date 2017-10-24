//
//  MainMenuViewController.m
//  Simobi
//
//  Created by Ravi on 10/8/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "MainMenuViewController.h"
#import "TransferMenuViewController.h"
#import "CategoryViewController.h"
#import "AccountViewController.h"
#import "Reachability.h"
#import "ASIFormDataRequest.h"
#import "XMLReader.h"
#import "SimobiServiceModel.h"
#import "NSString+Extension.h"
#import "AppDelegate.h"
#import "SimobiPINHUD.h"
#import "SimobiLoginViewController.h"
#import "SimobiUtility.h"

#import <DIMOPayiOS/DIMOPayiOS.h>
#define EulaTermsText @"<html><p style='font-family:Montserrat;'>Dengan menyetujui Syarat dan Ketentuan Pembayaran QR ini, maka saya menyatakan bahwa saya telah menerima dan menyetujui untuk tunduk dan terikat pada ketentuan-ketentuan sebagai berikut:<br><br>1. Pembayaran QR hanya dapat dilakukan pada merchant-merchant atau outlet-outlet yang berpartisipasi.<br><br>2. Pembayaran QR ini menggunakan teknologi Pay by QR.<br><br>3. Segala ketentuan mengenai penggunaan pembayaran QR mengacu kepada ketentuan induk yang tertera pada Syarat dan Ketentuan Umum SIMOBI.</p></html>"

@interface MainMenuViewController () <DIMOPayDelegate>

@property (assign) BOOL isFlashizInitialized;

@property (nonatomic, copy) NSString *loggedInUserKey;

@property (nonatomic, copy) NSString *flashizMesgtxt;

@property (nonatomic, retain) ASIHTTPRequest *inqueryRequest;

@property (nonatomic, strong) NSMutableDictionary *inqueryData;
@property (weak, nonatomic) IBOutlet UILabel *promoPayByQR;
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@property (weak, nonatomic) IBOutlet UIButton *purchaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
@property (weak, nonatomic) IBOutlet UIButton *payByQrBtn;
@property (weak, nonatomic) IBOutlet UIButton *promoBtn;

@property UIView *viewSimobiPlusUpgrade;
@property UIView *viewInfo;
@property UIWindow *viewWindow;
@property NSString *token;

@end

@implementation MainMenuViewController

@synthesize isFlashizInitialized,loggedInUserKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)tapped {
    // Tapped
}

- (void)showSimobiPlusUpgrade {
    self.viewSimobiPlusUpgrade = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.viewSimobiPlusUpgrade.backgroundColor = [self colorWithHexString:@"D8D8D8"];
    
    float heightTopView = 230.0f;
    float sizeImage = 86;
    float topText = 116;
    if (IS_IPHONE_4_OR_LESS) {
        heightTopView = 200.0f;
        sizeImage = 66;
        topText = 96;
    }
    
    UIImageView *imgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smbplus"]];
    [imgIcon setFrame:CGRectMake((CGRectGetWidth(self.viewSimobiPlusUpgrade.frame) - sizeImage)/2, 20, sizeImage, sizeImage)];
    
    UILabel *lbl0 = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.viewSimobiPlusUpgrade.frame) - 260)/2, topText, 260, 45)];
    NSString *myString = @"Get better banking experience with New SimobiPlus";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
    NSRange range = [myString rangeOfString:@"New SimobiPlus"];
    [attString addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"E30717"] range:range];
    lbl0.attributedText = attString;
    //lbl0.text = @"Get better banking experience with New SimobiPlus";
    lbl0.numberOfLines = 0;
    lbl0.font = [UIFont fontWithName:@"Helvetica Neue" size:19];
    lbl0.textAlignment = NSTextAlignmentLeft;
    
    UIView *viewIcon =[[UIView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.viewSimobiPlusUpgrade.frame) - 218)/2, topText + 60, 218, 40)];
    UIImageView *imgAppStore = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appstore"]];
    [imgAppStore setFrame:CGRectMake(0, 0, 104, 30)];
    UIImageView *imgPlayStore = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playstore"]];
    [imgPlayStore setFrame:CGRectMake(114, 0, 104, 30)];
    [viewIcon addSubview:imgAppStore];
    [viewIcon addSubview:imgPlayStore];
    
    [self.viewSimobiPlusUpgrade addSubview: viewIcon];
    [self.viewSimobiPlusUpgrade addSubview: lbl0];
    [self.viewSimobiPlusUpgrade addSubview: imgIcon];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel addTarget:self action:@selector(actionCancelSimobiPlusUpgrade) forControlEvents:UIControlEventTouchUpInside];
    CGSize btnCancelCancel = CGSizeMake(40.0f, 40.0f);
    [btnCancel setFrame:CGRectMake((CGRectGetWidth(self.viewSimobiPlusUpgrade.frame) - btnCancelCancel.width), 0, btnCancelCancel.width, btnCancelCancel.height)];
    [btnCancel setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imgClose = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Close"]];
    [imgClose setFrame:CGRectMake((CGRectGetWidth(self.viewSimobiPlusUpgrade.frame) - 28), 12, 16, 16)];
    UIView *viewButtom =[[UIView alloc]initWithFrame:CGRectMake(0, heightTopView,CGRectGetWidth(self.viewSimobiPlusUpgrade.frame),  (CGRectGetHeight(self.viewSimobiPlusUpgrade.frame) - heightTopView))];
    [viewButtom setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *tick1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick"]];
    [tick1 setFrame:CGRectMake(40, 12, 14, 10)];
    UIImageView *tick2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick"]];
    [tick2 setFrame:CGRectMake(40, 54, 14, 10)];
    UIImageView *tick3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick"]];
    [tick3 setFrame:CGRectMake(40, 100, 14, 10)];
    UIImageView *tick4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick"]];
    [tick4 setFrame:CGRectMake(40, 132, 14, 10)];
    
    [viewButtom addSubview:tick1];
    [viewButtom addSubview:tick2];
    [viewButtom addSubview:tick3];
    [viewButtom addSubview:tick4];
    
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(61, 8, (CGRectGetWidth(self.viewSimobiPlusUpgrade.frame) - 111), 32)];
    lbl1.text = @"Payment for Go-Pay, insurance, transport and other bill payments";
    lbl1.numberOfLines = 0;
    lbl1.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    lbl1.textAlignment = NSTextAlignmentLeft;
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(61, 49, (CGRectGetWidth(self.viewSimobiPlusUpgrade.frame) - 111), 32)];
    lbl2.text = @"Pay by QR, experience cashless and enjoy discounts";
    lbl2.numberOfLines = 0;
    lbl2.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    lbl2.textAlignment = NSTextAlignmentLeft;
    UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(61, 95, (CGRectGetWidth(self.viewSimobiPlusUpgrade.frame) - 111), 16)];
    lbl3.text = @"Pay credit card bills form all banks*";
    lbl3.numberOfLines = 0;
    lbl3.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    lbl3.textAlignment = NSTextAlignmentLeft;
    UILabel *lbl4 = [[UILabel alloc]initWithFrame:CGRectMake(61, 125, (CGRectGetWidth(self.viewSimobiPlusUpgrade.frame) - 111), 32)];
    lbl4.text = @"Open time deposit start from IDR 500.000 (7% interest)";
    lbl4.numberOfLines = 0;
    lbl4.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    lbl4.textAlignment = NSTextAlignmentLeft;
    UILabel *lbl5 = [[UILabel alloc]initWithFrame:CGRectMake(61, 164, (CGRectGetWidth(self.viewSimobiPlusUpgrade.frame) - 111), 15)];
    lbl5.text = @"*Terms and conditions apply";
    lbl5.numberOfLines = 0;
    lbl5.textColor = [UIColor grayColor];
    lbl5.font = [UIFont fontWithName:@"Helvetica Neue" size:11];
    lbl5.textAlignment = NSTextAlignmentLeft;
    UILabel *lbl6 = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewButtom.frame) - 250)/2, CGRectGetHeight(viewButtom.frame) - 32, 250, 15)];
    lbl6.text = @"*Your details from previous Simobi account is safe";
    lbl6.numberOfLines = 1;
    lbl6.font = [UIFont fontWithName:@"Helvetica Neue" size:11];
    lbl6.textAlignment = NSTextAlignmentLeft;
    
    [viewButtom addSubview:lbl1];
    [viewButtom addSubview:lbl2];
    [viewButtom addSubview:lbl3];
    [viewButtom addSubview:lbl4];
    [viewButtom addSubview:lbl5];
    [viewButtom addSubview:lbl6];
    
    UIButton *btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOk addTarget:self action:@selector(actionSimobiPlusUpgrade) forControlEvents:UIControlEventTouchUpInside];
    CGSize butonSize = CGSizeMake(250.0f, 35.0f);
    [btnOk setFrame:CGRectMake((CGRectGetWidth(viewButtom.frame) - butonSize.width)/2, CGRectGetHeight(viewButtom.frame) - butonSize.height - 37, butonSize.width, butonSize.height)];
    btnOk.layer.cornerRadius = 15;
    btnOk.clipsToBounds = YES;
    [btnOk setBackgroundColor:[self colorWithHexString:@"E30717"]];
    btnOk.titleLabel.textColor = [UIColor whiteColor];
    [btnOk setTitle:@"UPGRADE NOW" forState:UIControlStateNormal];
    [btnOk.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    [viewButtom addSubview: btnOk];
    
    [self.viewSimobiPlusUpgrade addSubview:viewButtom];
    NSString *simobiPlusUpgrade = [[NSUserDefaults standardUserDefaults] objectForKey:@"simobiPlusUpgrade"];
    if ([simobiPlusUpgrade isEqual: @"1"]) {
        [self.viewSimobiPlusUpgrade addSubview:imgClose];
        [self.viewSimobiPlusUpgrade addSubview:btnCancel];
    }

    [self.viewWindow addSubview:_viewSimobiPlusUpgrade];
}

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.token = @"";
    // Do any additional setup after loading the view from its nib.
    
    if (IS_IPHONE_5) {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 70;
        self.bgView.frame = bgviewFrame;
        
        CGRect contactviewFrame = self.logoutBtn.frame;
        contactviewFrame.origin.y -= 15;
        self.logoutBtn.frame = contactviewFrame;
        
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 40;
        self.bgView.frame = bgviewFrame;
        CGRect contactviewFrame = self.logoutBtn.frame;
        contactviewFrame.origin.y -= 160;
        self.logoutBtn.frame = contactviewFrame;
    }else{
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 35;
        self.bgView.frame = bgviewFrame;
        CGRect contactviewFrame = self.logoutBtn.frame;
        contactviewFrame.origin.y -= 87;
        self.logoutBtn.frame = contactviewFrame;
    }
    
    CGRect contactviewFrame = self.logoutBtn.frame;
    contactviewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - 44.f;
    self.logoutBtn.frame = contactviewFrame;
    self.purchaseBtn.layer.cornerRadius = 10;
    self.purchaseBtn.clipsToBounds = YES;
    self.accountBtn.layer.cornerRadius = 10;
    self.accountBtn.clipsToBounds = YES;
    self.transferBtn.layer.cornerRadius = 10;
    self.transferBtn.clipsToBounds = YES;
    self.paymentBtn.layer.cornerRadius = 10;
    self.paymentBtn.clipsToBounds = YES;
    self.payByQrBtn.layer.cornerRadius = 10;
    self.payByQrBtn.clipsToBounds = YES;
    self.promoBtn.layer.cornerRadius = 10;
    self.promoBtn.clipsToBounds = YES;
    
    self.viewWindow = [[UIApplication sharedApplication] keyWindow];
    [self showSimobiPlusUpgrade];
    // CONDITIONLOG(DEBUG_MODE,@"MDN:%@",[[SimobiManager shareInstance] sourcePIN]);
    NSString *simobiPlusUpgrade = [[NSUserDefaults standardUserDefaults] objectForKey:@"simobiPlusUpgrade"];
    if (![simobiPlusUpgrade  isEqual: @"0"]) {
        [self showSimobiPlusUpgrade];
        [self showInfo];
    }

}

- (void)actionCloseInfo {
    [self.viewInfo removeFromSuperview];
    if (IS_IPHONE_5) {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 70;
        self.bgView.frame = bgviewFrame;
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 40;
        self.bgView.frame = bgviewFrame;
    } else {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 35;
        self.bgView.frame = bgviewFrame;
    }
}

- (void)actionShowSimobiupgrade {
    [self showSimobiPlusUpgrade];
}

- (void)showInfo {
    
    if (IS_IPHONE_5) {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 100;
        self.bgView.frame = bgviewFrame;
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 70;
        self.bgView.frame = bgviewFrame;
    } else{
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 95;
        self.bgView.frame = bgviewFrame;
    }
    
    self.viewInfo =[[UIView alloc]initWithFrame:CGRectMake(0, 64 ,CGRectGetWidth(self.view.frame),  60)];
    self.viewInfo.backgroundColor = [self colorWithHexString:@"E30717"];
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel addTarget:self action:@selector(actionCloseInfo) forControlEvents:UIControlEventTouchUpInside];
    CGSize btnCancelCancel = CGSizeMake(40.0f, 60.0f);
    [btnCancel setFrame:CGRectMake((CGRectGetWidth(self.viewInfo.frame) - btnCancelCancel.width), 0, btnCancelCancel.width, btnCancelCancel.height)];
    [btnCancel setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imgClose = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Close"]];
    [imgClose setFrame:CGRectMake((CGRectGetWidth(self.viewInfo.frame) - 28), 22, 16, 16)];
    
    UIImageView *simobiLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"simobi_plus"]];
    [simobiLogo setFrame:CGRectMake(20, 15, 90, 30)];
    simobiLogo.image = [simobiLogo.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [simobiLogo setTintColor:[UIColor whiteColor]];
    
    UIButton *btnUpgrade = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnUpgrade addTarget:self action:@selector(actionShowSimobiupgrade) forControlEvents:UIControlEventTouchUpInside];
    [btnUpgrade setFrame:CGRectMake(130, 15, 130, 30)];
    btnUpgrade.layer.cornerRadius = 15;
    btnUpgrade.clipsToBounds = YES;
    [btnUpgrade setBackgroundColor:[UIColor whiteColor]];
    btnUpgrade.titleLabel.textColor = [UIColor whiteColor];
    [btnUpgrade setTitle:@"UPGRADE NOW" forState:UIControlStateNormal];
    [btnUpgrade setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnUpgrade.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:11]];
    
    [self.viewInfo addSubview:btnUpgrade];
    [self.viewInfo addSubview:simobiLogo];
    [self.viewInfo addSubview:imgClose];
    [self.viewInfo addSubview:btnCancel];
    [self.view addSubview:self.viewInfo];
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    
    NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
    
    self.purchaseLBL.text = [textDict objectForKey:PURCHASE];
    self.paymentLBL.text = [textDict objectForKey:PAYMENT];
    self.transferLBL.text  = @"Transfer"; //[textDict objectForKey:TRANSFER];
    self.accountLBL.text  = [textDict objectForKey:ACCOUNT];
    self.payByQRLBL.text  = [textDict objectForKey:PAYBYQR];
    self.promoPayByQR.text = [NSString stringWithFormat:@"Promo\n%@", self.payByQRLBL.text];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *invoiceId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultPayInAPP];
    NSString *backUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultPayInAPPBackURL];
    if (invoiceId && invoiceId.length > 0) {
        //there is invoice id for inapp
        [self flashizInitSDK];
        [DIMOPay closeSDK];
        [DIMOPay startSDK:self withDelegate:self invoiceId:invoiceId andCallBackURL:backUrl];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultPayInAPP];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultPayInAPPBackURL];
    }
}

- (void)viewWillUnload
{
    
    [self setPurchaseLBL:nil];
    [self setPaymentLBL:nil];
    [self setTransferLBL:nil];
    [self setAccountLBL:nil];
    [self setBgView:nil];

    [super viewDidUnload];
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *PURCHASE Button Action: Navigate to CategoryViewController
 */
- (IBAction)purchaseButtonAction:(id)sender
{
    
    [[[SimobiManager shareInstance] responseData] removeAllObjects];
    CategoryViewController *catVC = [[CategoryViewController alloc] initWithParentClass:ParentClass_Purchase];
    [self.navigationController pushViewController:catVC animated:YES];
}

/*
 *Transfer Button Action: Navigate to TransferMenuViewController
 */

- (IBAction)transferButtonAction:(id)sender
{
    [[[SimobiManager shareInstance] responseData] removeAllObjects];
    TransferMenuViewController *vContoller = [[TransferMenuViewController alloc] initWithNibName:@"TransferMenuViewController" bundle:nil];
    [self.navigationController pushViewController:vContoller animated:YES];
}

/*
 *PURCHASE Button Action: Navigate to CategoryViewController
 */

- (IBAction)paymentButtonAction:(id)sender
{
    [[[SimobiManager shareInstance] responseData] removeAllObjects];
    CategoryViewController *catVC = [[CategoryViewController alloc] initWithParentClass:ParentClass_Payment];
    [self.navigationController pushViewController:catVC animated:YES];

}

/*
 *PURCHASE Button Action: Navigate to CategoryViewController
 */

- (IBAction)accountButtonAction:(id)sender
{
    AccountViewController *accountVC = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
    [self.navigationController pushViewController:accountVC animated:YES];
    
}


/*
 *QR Payment Button Action: Navigate to CategoryViewController
 */

- (IBAction)qrPaymentButtonAction:(id)sender
{
    // notifications from hotSpotA should call hotSpotATouched:
    [self flashizInitSDK];
    [DIMOPay startSDK:self withDelegate:self];
}
- (IBAction)promoButtonAction:(id)sender {
    [self flashizInitSDK];
    [DIMOPay startLoyalty:self withDelegate:self];
}

/*
 * LOGOUT Button Action
 */
- (IBAction)logOutButtonAction:(id)sender
{
    NSArray *navigationStack = [self.navigationController viewControllers];
    for (UIViewController *vC in navigationStack) {
        if ([vC isKindOfClass:[SimobiLoginViewController class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:vC animated:YES];
            });
            
            return;
            break;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 * Migration Button Action
 */
- (void)actionSimobiPlusUpgrade {
    BOOL isDownloaded = [SimobiUtility canOpenAppsWithUrlScheme:@"smbplus://"];
    if (isDownloaded) {
        
        Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        if ([reachability currentReachabilityStatus] == NotReachable) {
            // [SimobiAlert showAlertWithMessage:@"No Network connection\n Please try again later."];
            
            NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
            [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
            return;
        }
        
        [self displayProgressHudWithMessage:@"Loading"];
        NSString *mdn = [[SimobiManager shareInstance] sourceMDN];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
        [params setObject:mdn forKey:@"sourceMDN"];
        [params setObject:@"GenerateMigrateToken" forKey:@"txnName"];
        [params setObject:@"Account" forKey:@"service"];
        [params setObject:@"7" forKey:@"channelID"];
        
        NSString *normalisedUrl =  [SIMOBI_URL constructUrlStringWithParams:params];
        
        CONDITIONLOG(DEBUG_MODE,@"normalisedUrl:%@",normalisedUrl);

        [SimobiServiceModel connectURL:normalisedUrl successBlock:^(NSDictionary *response) {
            
            [self hideProgressHud];
            CONDITIONLOG(DEBUG_MODE,@"Response:%@",response);
            
            NSString *code = [[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"code"];
            
            if ([code isEqualToString:@"2183"]) {
                self.token = [[[response objectForKey:@"response"] objectForKey:@"migrateToken"] objectForKey:@"text"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Simobi" message:@"You have SimobiPlus on your phone" delegate:self cancelButtonTitle:@"Register Now" otherButtonTitles:nil, nil];
                alert.tag = 122;
                [alert show];
            } else {
                [SimobiAlert showAlertWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"] ];
            }
            
        }
            failureBlock:^(NSError *error) {dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD hide];
                NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
              
            });
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Simobi" message:@"You dont have on your phoneSimobiPlus" delegate:self cancelButtonTitle:@"Install Now" otherButtonTitles:nil, nil];
        alert.tag = 121;
        [alert show];
       
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (121 == alertView.tag) {
        NSString *url = @"https://itunes.apple.com/id/app/simobiplus/id938705552";
        if ([SimobiUtility canOpenAppsWithUrlScheme:url]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    } else if (alertView.tag == 122) {
        if (![self.token  isEqual: @""]) {
            NSString *depplink = [NSString stringWithFormat:@"smbplus://migrate/#%@", self.token];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:depplink]];
        } else {
            [SimobiAlert showAlertWithMessage:@"Please generate toke first!"];
        }
    
    } else {
        [DIMOPay closeSDK];
    }
    
}


- (void)actionCancelSimobiPlusUpgrade
{
    
    [self.viewSimobiPlusUpgrade removeFromSuperview];
    
}

- (void)flashizInitSDK
{
    [DIMOPay setServerURL:FLASHiZ_SERVER];
    // [DIMOPay setIsPolling:NO];
    [DIMOPay setMinimumTransaction:1000];
}

#pragma mark - Actions

- (IBAction)closeSDKChoice:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/// This function will be called when EULA state is false
/// Return view controller, there is a standard view controller for eula or using your own EULA view controller
/// example : [DIMOPay EULAWithStringHTML:@"test<br>Test2"];
- (UIViewController *)callbackShowEULA {
    return [DIMOPay EULAWithStringHTML:EulaTermsText];
}

/// This function will be called when the EULA state changed
- (void)callbackEULAStateChanged:(BOOL)state {
    
}

/// This function will be called when the SDK opened at the first time or there is no user api key found
- (void)callbackGenerateUserAPIKey {
    [self generateUserkey];
}

/// This function will be called when user cancel process payment or close invoice summary
- (void)callbackUserHasCancelTransaction {
    
}

/// This function will be called when user clicked pay button and host-app need to doing payment here
- (void)callbackPayInvoice:(DIMOInvoiceModel *)invoice {
    [self payInvoice:invoice.invoiceId
  withOriginalAmount:invoice.originalAmount
 andDiscountedAmount:invoice.paidAmount
     andMerchantName:invoice.merchantName
      andNbOfCoupons:invoice.numberOfCoupons
   andTypeOfDiscount:invoice.discountType
andLoyaltyProgramName:invoice.loyaltyProgramName
   andDiscountAmount:invoice.amountOfDiscount
     tippingAmount:invoice.tipAmount
    pointsRedeemed:0 amountRedeemed:0];
}

/// This function will be called when isUsingCustomDialog is Yes, and host-app need to show their own dialog
- (void)callbackShowDialog:(PaymentStatus)paymentStatus withMessage:(NSString *)message {
    
}

/// This function will be called when the sdk has been closed
- (void)callbackSDKClosed {
    self.isFlashizInitialized = NO;
}

/// This function will be called when lost internet connection error page appear
- (void)callbackLostConnection {
    
}

/// Return true to close sdk
/// This function will be called when invalid qr code error page appear
- (BOOL)callbackInvalidQRCode {
    return NO;
}

/// Return true to close sdk
/// This function will be called when payment failed error page appear
- (BOOL)callbackTransactionStatus:(PaymentStatus)paymentStatus withMessage:(NSString *)message {
    return NO;
}

/// Return true to close sdk
/// This function will be called when unknown error page appear
- (BOOL)callbackUnknowError {
    return NO;
}

/// This function will be called when authentication error page appear
- (void)callbackAuthenticationError {
}

#pragma mark - private function
-(NSString*)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge  CFStringRef)unencodedString;
    NSString *s = ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8));
    CFRelease(originalStringRef);
    return s;
}

- (NSString *)escapeValueForURLParameter:(NSString *)valueToEscape {
    return ( NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) valueToEscape,
                                                                                   NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}

- (void)payInvoice:(NSString *)invoiceId withOriginalAmount:(double)amount andDiscountedAmount:(double)discountedAmount andMerchantName:(NSString *)merchantName andNbOfCoupons:(int)nbOfCoupons andTypeOfDiscount:(NSString *)discountType andLoyaltyProgramName:(NSString *)loyaltyProgramName andDiscountAmount:(double)amountOfDiscount tippingAmount:(double)tippingAmount
    pointsRedeemed:(int)pointsRedeemed
    amountRedeemed:(int)amountRedeemed {
    CONDITIONLOG(DEBUG_MODE, @"PayInvoice.");
    //do you payInvoice here
    
    
    if (amount == 0) {
        [SimobiAlert showAlertWithMessage:@"Loading ...."];
        return;
    }
    
    
    self.inqueryData =  [[NSMutableDictionary alloc] init];
    [self.inqueryData  setValue:[NSString stringWithFormat:@"%f",amount] forKey:@"amount"];
    [self.inqueryData  setValue:invoiceId forKey:@"invoiceId"];
    [self.inqueryData  setValue:merchantName forKey:@"merchantName"];
    [self.inqueryData  setValue:loyaltyProgramName forKey:@"loyaltyProgramName"];
    [self.inqueryData  setValue:loyaltyProgramName forKey:@"loyaltyProgramName"];
    [self.inqueryData  setValue:loyaltyProgramName forKey:@"loyaltyProgramName"];
    
    [self.inqueryData  setValue:[NSString stringWithFormat:@"%d",nbOfCoupons] forKey:@"nbOfCoupons"];
    [self.inqueryData  setValue:[NSString stringWithFormat:@"%0.2f",discountedAmount] forKey:@"discountedAmount"];
    [self.inqueryData  setValue:[NSString stringWithFormat:@"%0.2f",amountOfDiscount] forKey:@"amountOfDiscount"];
    [self.inqueryData  setValue:discountType forKey:@"discountType"];
    [self.inqueryData  setValue:[NSString stringWithFormat:@"%0.2f",tippingAmount] forKey:@"tippingAmount"];
    [self.inqueryData  setValue:[NSString stringWithFormat:@"%d",pointsRedeemed] forKey:@"pointsRedeemed"];
    [self.inqueryData  setValue:[NSString stringWithFormat:@"%d",amountRedeemed] forKey:@"amountRedeemed"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flashizinqueryCancel:) name:@"FlashizInqueryCancel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flashizinquery:) name:@"FlashizInquery" object:nil];
    
    [SimobiPINHUD displayWithMessage:self.flashizMesgtxt];

}


- (void)flashizinquery:(NSNotification *)notification{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlashizInquery" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlashizInqueryCancel" object:nil];
    
    
    //Get Match List here
    
    NSString *otpText = [notification.userInfo valueForKey:@"PINTEXT"];
    
    //Perform Service Call
    Reachability *rechability = [Reachability reachabilityWithHostname:@"www.google.com"];
    if ([rechability currentReachabilityStatus] == NotReachable) {
        [self noNetworkAlert];
        return;
    }
    
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"GetUserAPIKey"]) {
        self.loggedInUserKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"GetUserAPIKey"];
    }
    
    NSString *userKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"GetUserAPIKey"];
    //do you payInvoice here
    NSURL* reqUrl = [[NSURL alloc] initWithString:SIMOBI_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:reqUrl];
    [request setTimeOutSeconds:90];
    [request setPostValue:[[SimobiManager shareInstance] sourceMDN] forKey:SOURCEMDN];
    [request setPostValue:SERVICE_PAYMENT forKey:SERVICE];
    [request setPostValue:TXN_FlashIz_BillPay_Inquiry forKey:TXNNAME];
    //[request setPostValue:@"HUB" forKey:InstitutionID];
    [request setPostValue:@"2" forKey:SOURCEPOCKETCODE];
    [request setPostValue:@"7" forKey:@"channelID"];
    
    [request setPostValue:@"QRFLASHIZ" forKey:@"billerCode"];
    [request setPostValue:[self.inqueryData valueForKey:@"invoiceId"] forKey:@"billNo"];
    [request setPostValue:otpText forKey:SOURCEPIN];
    [request setPostValue:@"QRPayment" forKey:@"paymentMode"];
    [request setPostValue:[self.inqueryData valueForKey:@"merchantName"]  forKey:@"merchantData"];
    [request setPostValue:userKey forKey:@"userAPIKey"];
    [request setPostValue:[self.inqueryData valueForKey:@"loyaltyProgramName"] forKey:@"loyalityName"];
    
    [request setPostValue:[self.inqueryData valueForKey:@"nbOfCoupons"] forKey:@"numberOfCoupons"];
    [request setPostValue:[self.inqueryData valueForKey:@"discountedAmount"] forKey:@"amount"];
    [request setPostValue:[self.inqueryData valueForKey:@"amountOfDiscount"] forKey:@"discountAmount"];
    [request setPostValue:[self.inqueryData valueForKey:@"tippingAmount"] forKey:@"tippingAmount"];
    [request setPostValue:[self.inqueryData valueForKey:@"pointsRedeemed"] forKey:@"pointsRedeemed"];
    [request setPostValue:[self.inqueryData valueForKey:@"amountRedeemed"] forKey:@"amountRedeemed"];
    //[request setPostValue:[UangkuUtility getDataFromPlistForKey:User_Profile_ID] forKey:Profile_ID];
    
    if( [self.inqueryData valueForKey:@"discountType"] == NULL || ([self.inqueryData valueForKey:@"discountType"] == (NSString*)[ NSNull null ]) || [[self.inqueryData valueForKey:@"discountType"] isEqualToString:@"null"] ||[[self.inqueryData valueForKey:@"discountType"] isEqualToString:@"(null)"])
        [request setPostValue:@"" forKey:@"discountType"];
    else
        [request setPostValue:[self.inqueryData valueForKey:@"discountType"] forKey:@"discountType"];
    
    [request setValidatesSecureCertificate:NO];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request  setShouldStreamPostDataFromDisk:YES];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    request.showAccurateProgress = TRUE;
    [request setDelegate:self];
    //[request setTimeOutSeconds:60000];
    request.shouldAttemptPersistentConnection = NO;
    
    [request setDidFinishSelector:@selector(inqueryRequestFinished:)];
    [request setDidFailSelector:@selector(inqueryRequestFailed:)];
    [request startAsynchronous];
    
    //[ProgressHUD displayWithMessage:@"Loading"];
}

- (void)flashizinqueryCancel:(NSNotification *)notification{
    
    //Get Match List here
    //[_aFlashizFacade hideLoadingView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlashizConfirmation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlashizInqueryCancel" object:nil];
    
    [SimobiPINHUD hide];
    
    [ProgressHUD hide];
    
    [DIMOPay closeSDK];
}


- (IBAction)inqueryRequestFailed:(ASIHTTPRequest *)theRequest
{
    
    [ProgressHUD hide];
    [DIMOPay notifyTransaction:PaymentStatusFailed
                   withMessage:theRequest.error.localizedDescription ? theRequest.error.localizedDescription : @""
               isDefaultLayout:YES];
    return;
    
    UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Simobi" message:theRequest.error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertMsg show];
}

- (IBAction)inqueryRequestFinished:(ASIHTTPRequest *)theRequest
{
    
    _inqueryRequest = theRequest;
    
    NSError *error;
    NSDictionary *response = (NSDictionary *)[XMLReader dictionaryForXMLString:theRequest.responseString error:&error];
    
    CONDITIONLOG(DEBUG_MODE, @"Inquery Post Data :  %@",[theRequest valueForKey:@"postData"]);
    CONDITIONLOG(DEBUG_MODE, @"Inquery  Response :  %@",response);
    
    if ([GetResponseCode(response) isEqualToString:FlashIS_Inquery_SuccessCode]) {
        // notifications from hotSpotA should call hotSpotATouched:
        
        self.flashizMesgtxt = [NSString stringWithFormat:@"%@",[response valueForKeyPath:@"response.message.text"]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flashizConfirmation:) name:@"FlashizConfirmation" object:nil];
        [DialogHUD displayWithMessage:self.flashizMesgtxt withservice:SERVICE_FLASHIZ];
    }
    else {
        [ProgressHUD hide];
        NSString *message = GetMessageText(response);
        if (!message) message = @"";
        [DIMOPay notifyTransaction:PaymentStatusFailed withMessage:message isDefaultLayout:YES];
        return;

        UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Simobi" message:GetMessageText(response) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertMsg show];
    }
}


- (void)flashizConfirmation:(NSNotification *)notification
{
    

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlashizConfirmation" object:nil];
    
     NSError *error;
     NSDictionary *response = (NSDictionary *)[XMLReader dictionaryForXMLString:_inqueryRequest.responseString error:&error];
    
     NSString *otpText = [notification.userInfo valueForKey:@"OTPTEXT"];
    
    if (otpText.length > 0) {
        NSArray *postDataArray = [_inqueryRequest valueForKey:@"postData"];
        NSString *merchantData;
        NSString *bilNumber;
        NSString *discountType;
        NSString *noOfCoupons ;
        NSString *loyaltyProgramName;
        NSString *amountOFDiscount;
        NSString *tippingAmount, *pointsRedeemed, *amountRedeemed;
     
        for(NSDictionary *postObj in postDataArray){
            if ([[postObj valueForKey:@"key"] isEqualToString:@"discountType"]) {
                discountType = [NSString stringWithFormat:@"%@",[postObj valueForKey:@"value"]];
            }
            
            if ([[postObj valueForKey:@"key"] isEqualToString:@"numberOfCoupons"]) {
                noOfCoupons = [NSString stringWithFormat:@"%@",[postObj valueForKey:@"value"]];
            }
            
            if ([[postObj valueForKey:@"key"] isEqualToString:@"loyalityName"]) {
                loyaltyProgramName = [NSString stringWithFormat:@"%@",[postObj valueForKey:@"value"]];
            }
            
            if ([[postObj valueForKey:@"key"] isEqualToString:@"discountAmount"]) {
                amountOFDiscount = [NSString stringWithFormat:@"%@",[postObj valueForKey:@"value"]];
            }
            
            if ([[postObj valueForKey:@"key"] isEqualToString:@"merchantData"]) {
                merchantData = [NSString stringWithFormat:@"%@",[postObj valueForKey:@"value"]];
            }
            
            if ([[postObj valueForKey:@"key"] isEqualToString:@"billNo"]) {
                bilNumber = [NSString stringWithFormat:@"%@",[postObj valueForKey:@"value"]];
            }
            
            if ([[postObj valueForKey:@"key"] isEqualToString:@"tippingAmount"]) {
                tippingAmount = [NSString stringWithFormat:@"%@",[postObj valueForKey:@"value"]];
            }
            
            if ([[postObj valueForKey:@"key"] isEqualToString:@"pointsRedeemed"]) {
                pointsRedeemed = [NSString stringWithFormat:@"%@",[postObj valueForKey:@"value"]];
            }
            if ([[postObj valueForKey:@"key"] isEqualToString:@"amountRedeemed"]) {
                amountRedeemed = [NSString stringWithFormat:@"%@",[postObj valueForKey:@"value"]];
            }
        }
        
        
        
        NSString *userKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"GetUserAPIKey"];
        //do you payInvoice here
        NSURL* reqUrl = [[NSURL alloc] initWithString:SIMOBI_URL];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:reqUrl];
        [request setTimeOutSeconds:90];
        [request setPostValue:[[SimobiManager shareInstance] sourceMDN] forKey:SOURCEMDN];
        [request setPostValue:TXN_FlashIz_BillPay_Confirmation forKey:TXNNAME];
        [request setPostValue:SERVICE_PAYMENT forKey:SERVICE];
        [request setPostValue:otpText forKey:@"mfaOtp"];
        // [request setPostValue:@"HUB" forKey:InstitutionID];
        [request setPostValue:@"2" forKey:SOURCEPOCKETCODE];
        [request setPostValue:[[SimobiManager shareInstance] sourcePIN] forKey:SOURCEPIN];
        [request setPostValue:@"7" forKey:@"channelID"];
        [request setPostValue:userKey forKey:@"userAPIKey"];
        [request setPostValue:@"true" forKey:@"confirmed"];
        [request setPostValue:@"QRPayment" forKey:@"paymentMode"];
        [request setPostValue:@"QRFLASHIZ" forKey:@"billerCode"];
        [request setPostValue:[response valueForKeyPath:@"response.parentTxnID.text"] forKey:@"parentTxnID"];
        [request setPostValue:[response valueForKeyPath:@"response.transferID.text"] forKey:@"transferID"];
        
        if( discountType == NULL || ( discountType == (NSString*)[ NSNull null ]) || [discountType isEqualToString:@"null"] ||[discountType isEqualToString:@"(null)"])
            [request setPostValue:@"" forKey:@"discountType"];
        else
            [request setPostValue:discountType forKey:@"discountType"];
        
        [request setPostValue:bilNumber forKey:@"billNo"];
        [request setPostValue:merchantData forKey:@"merchantData"];
        [request setPostValue:noOfCoupons forKey:@"numberOfCoupons"];
        [request setPostValue:loyaltyProgramName forKey:@"loyalityName"];
        [request setPostValue:amountOFDiscount forKey:@"discountAmount"];
        [request setPostValue:tippingAmount forKey:@"tippingAmount"];
        [request setPostValue:pointsRedeemed forKey:@"pointsRedeemed"];
        [request setPostValue:amountRedeemed forKey:@"amountRedeemed"];
        //[request setPostValue:[UangkuUtility getDataFromPlistForKey:User_Profile_ID] forKey:Profile_ID];
        [request setValidatesSecureCertificate:NO];
        [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [request  setShouldStreamPostDataFromDisk:YES];
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        request.showAccurateProgress = TRUE;
        [request setDelegate:self];
        request.shouldAttemptPersistentConnection = NO;
        
        
        
        [request setDidFinishSelector:@selector(qpPaymentConfirmRequestFinished:)];
        [request setDidFailSelector:@selector(qpPaymentConfirmRequestFailed:)];
        [request startAsynchronous];
        
        //[ProgressHUD displayWithMessage:@"Loading"];
        
        
    } else {
        [DIMOPay closeSDK];
        [ProgressHUD hide];
        return;
    }
}

- (IBAction)qpPaymentConfirmRequestFailed:(ASIHTTPRequest *)theRequest
{
    [ProgressHUD hide];
    
    [DIMOPay notifyTransaction:PaymentStatusFailed
                   withMessage:theRequest.error.localizedDescription ? theRequest.error.localizedDescription : @""
               isDefaultLayout:YES];
    return;
    
    UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Simobi" message:theRequest.error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertMsg show];
}

- (IBAction)qpPaymentConfirmRequestFinished:(ASIHTTPRequest *)theRequest
{
    [ProgressHUD hide];
    
    NSError *error;
    NSDictionary *response = (NSDictionary *)[XMLReader dictionaryForXMLString:theRequest.responseString error:&error];
    CONDITIONLOG(DEBUG_MODE, @"Confirmation Post Data :  %@",[theRequest valueForKey:@"postData"]);
    CONDITIONLOG(DEBUG_MODE, @"Confirmation Response :  %@",response);
    
    if ([GetResponseCode(response) isEqualToString:FlashIS_Confirmation_SuccessCode]) {
        // AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        // appDelegate.isFlashizTransFailed = YES;
        [DIMOPay notifyTransaction:PaymentStatusSuccess withMessage:@"" isDefaultLayout:YES];
    } else {
        
        //[DimoAlert alertWithMessage:GetMessageText(response)];
        NSString *message = GetMessageText(response);
        if (!message) message = @"";
        
        [DIMOPay notifyTransaction:PaymentStatusFailed withMessage:message isDefaultLayout:YES];
        return;
        
        UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Simobi" message:GetMessageText(response) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertMsg show];
        
    }
}
- (void)generateUserkey {
    
    //do you payInvoice here
    
    NSString *userKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"GetUserAPIKey"];
    
    if (userKey != nil && userKey.length > 0  && ![userKey isEqualToString:@"(null)"]) {
        self.loggedInUserKey = userKey;
        [DIMOPay setUserAPIKey:userKey];
    }else{
        //Perform Service Call
        //Perform Service Call
        Reachability *rechability = [Reachability reachabilityWithHostname:@"www.google.com"];
        if ([rechability currentReachabilityStatus] == NotReachable) {
            [self noNetworkAlert];
            return;
        }
        
        //[ProgressHUD displayWithMessage:@"Loading"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[[SimobiManager shareInstance] sourceMDN] forKey:SOURCEMDN];
        [params setObject:SERVICE_ACCOUNT forKey:SERVICE];
        [params setObject:@"HUB"                                           forKey:@""];
        [params setObject:TXN_GetUserKey forKey:TXNNAME];
        [params setObject:@"subapp" forKey:@"apptype"];
        [params setObject:@"1.0"    forKey:@"appversion"];
        [params setObject:@"iOS"    forKey:@"appos"];
        [params setObject:[[SimobiManager shareInstance] sourcePIN]  forKey:@"authenticationString"];
        
        
        NSString *urlString = [SIMOBI_URL constructUrlStringWithParams:params];
        [SimobiServiceModel connectURL:urlString successBlock:^(NSDictionary *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD hide];
                CONDITIONLOG(DEBUG_MODE, @"User Key Response :  %@",response);
                if ([response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"html"]) {
                    [SimobiAlert showAlertWithMessage:REQUEST_TIME_OUT_ERROR];
                    return ;
                }
                if ([GetResponseCode(response) isEqualToString:FlashIS_User_Key_SuccessCode]) {

                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:[response valueForKeyPath:@"response.userAPIKey.text"] forKey:@"GetUserAPIKey"];
                    [defaults synchronize];
                    
                    
                    self.loggedInUserKey = [response valueForKeyPath:@"response.userAPIKey.text"];;
                    [DIMOPay setUserAPIKey:[response valueForKeyPath:@"response.userAPIKey.text"]];
                    
                } else {
                    //[DimoAlert alertWithMessage:GetMessageText(response)];
                    
                    UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Simobi" message:GetMessageText(response) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertMsg show];
                    
                }
            });
        } failureBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD hide];
                [SimobiAlert showAlertWithMessage:error.localizedDescription];
            });
            
        }];
    }
}


- (double)timeBetweenEachPollCall {
    return 500;
}

- (double)timeBeforeStartingPoll {
    return 1000;
}

#pragma mark - showEulaView delegate method

- (void)didRefuseEula
{
    CONDITIONLOG(DEBUG_MODE, @"didRefuseEula");
    
    self.isFlashizInitialized = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)didAcceptEula
{
    CONDITIONLOG(DEBUG_MODE, @"didAcceptEula");
    
}

#pragma mark - Close SDK Delegate

- (void) didCloseSdk
{
    CONDITIONLOG(DEBUG_MODE, @"didCloseSdk");
   // [self.navigationController popViewControllerAnimated:YES];
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end
