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

- (void)tapped

{
    // Tapped
}

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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

    //CONDITIONLOG(DEBUG_MODE,@"MDN:%@",[[SimobiManager shareInstance] sourcePIN]);
    
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
- (IBAction)buttonActionMigration:(id)sender
{
    
    BOOL isDownloaded = [SimobiUtility canOpenAppsWithUrlScheme:@"SimoboPlus://"];
    if (isDownloaded) {
        // [ProgressHUD displayWithMessage:@"Loading"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"SimoboPlus://"]];
    } else {
        NSString *url = @"https://itunes.apple.com/id/app/simobiplus/id938705552";
        if ([SimobiUtility canOpenAppsWithUrlScheme:url]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }

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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    [DIMOPay closeSDK];
}




@end
