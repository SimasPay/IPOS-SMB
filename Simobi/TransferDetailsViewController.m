//
//  TransferDetailsViewController.m
//  Simobi
//
//  Created by Ravi on 10/15/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "TransferDetailsViewController.h"
#import "BillInquiryViewController.h"
#import "UITextField+Extension.h"
#import "NSString+Extension.h"
#import "DialogHUD.h"
#import "SimobiConstants.h"
#import "Reachability.h"


#define KEY_AVAILABLE(x,y)[x isEqualToString:y]
#define kZeroAmount @"ZeroAmount"
#define kFreeAmount @"FreeAmount"
#define kPackageType @"PackageType"

@interface TransferDetailsViewController (){
    UIView *maskView;
    UIPickerView *_providerPickerView;
    UIView *_providerToolbar;
}
@property (assign) CGRect viewFrame;

@property (nonatomic,strong)UIButton *btnBarDone;
@property (nonatomic,strong)UIButton *btnBarCancel;
@property (assign) UITextField *activeTextField;
@property (retain) UIActionSheet *actionSheet;
@property (retain) UIPickerView *pickerView;
@property (retain) NSArray *denomArr;

@end

@implementation TransferDetailsViewController
@synthesize transferType,categoryDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithTranferType:(TRANSFER_TYPE) transfer
{
    
    self = [super initWithNibName:@"TransferDetailsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.transferType = transfer;
        
    }
    return self;
    
}

#pragma mark - UIView LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.accountNumberField.delegate = self;
    self.amountField.delegate = self;
    self.mpinField.delegate = self;
    
    
   // NSDictionary * categoryData = [[[SimobiManager shareInstance] responseData] objectForKey:@"categoryData"];
   // CONDITIONLOG(DEBUG_MODE,@"categoryData:%@",self.categoryDict);
    
    CGFloat padding = 20.0f;
    UIImageView *backGroubImage = [[UIImageView alloc] initWithFrame:CGRectMake(padding, 140.0f, CGRectGetWidth(self.view.frame) - padding*2, 230.0f)];
    
    
    backGroubImage.image = [UIImage imageNamed:@"TRANSPARENT SCREEN.png"];
    backGroubImage.layer.cornerRadius = 10.0f;
    backGroubImage.layer.borderWidth  = 3.0f;
    backGroubImage.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    backGroubImage.userInteractionEnabled = YES;
    
    CGSize _labelSize = CGSizeMake(172.0f, 21.0f);
    CGSize _fieldSize = CGSizeMake(259.0f, 30.0f);
    
    self.firstLabel = [self createLabelwithFrame:CGRectMake(padding/1.5, padding/2.5, _labelSize.width, _labelSize.height)];
    [backGroubImage addSubview:self.firstLabel];
    
    NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];

    self.accountNumberField = [self createTextFieldwithFrame:CGRectMake(10.0f, self.firstLabel.frame.origin.y + CGRectGetHeight(self.firstLabel.frame) +padding/5, _fieldSize.width, _fieldSize.height)];
    [backGroubImage addSubview:self.accountNumberField];
    
    /*
     * New Parameters April/14
     */
    BOOL isCCPayment = NO;
    BOOL isNotPLNPrePaid = NO;
    
    if ([self.categoryDict objectForKey:@"isCCPayment"]) {
       
        isCCPayment = (BOOL)[self.categoryDict objectForKey:@"isCCPayment"];
    }
    
    if ([self.categoryDict objectForKey:@"isPLNPrepaid"]) {
        isNotPLNPrePaid = YES;
    }
    
    
    [[[SimobiManager shareInstance] responseData] removeObjectForKey:@"type"];
    if (([[self.categoryDict objectForKey:@"paymentMode"] isEqualToString:kZeroAmount]) && [self.categoryDict objectForKey:@"isPLNPrepaid"]) {
        
        self.secondLabel = [self createLabelwithFrame:CGRectMake(padding/1.5, self.accountNumberField.frame.origin.y + CGRectGetHeight(self.accountNumberField.frame)+padding/6.4, _labelSize.width, _labelSize.height)];
        [backGroubImage addSubview:self.secondLabel];
        
        
        
        self.amountField = [self createTextFieldwithFrame:CGRectMake(10.0f, self.secondLabel.frame.origin.y+CGRectGetHeight(self.secondLabel.frame), _fieldSize.width, _fieldSize.height)];
        [backGroubImage addSubview:self.amountField];
        
        
        
    }
    if (([[self.categoryDict objectForKey:@"paymentMode"] isEqualToString:kZeroAmount]) || ([[self.categoryDict objectForKey:@"paymentMode"] isEqualToString:kFreeAmount]) || (isCCPayment) ) {
        
    }  else {
        
        
           self.secondLabel = [self createLabelwithFrame:CGRectMake(padding/1.5, self.accountNumberField.frame.origin.y + CGRectGetHeight(self.accountNumberField.frame)+padding/6.4, _labelSize.width, _labelSize.height)];
           [backGroubImage addSubview:self.secondLabel];
           
           
           
           self.amountField = [self createTextFieldwithFrame:CGRectMake(10.0f, self.secondLabel.frame.origin.y+CGRectGetHeight(self.secondLabel.frame), _fieldSize.width, _fieldSize.height)];
           [backGroubImage addSubview:self.amountField];
           
    }
    
    
    if (self.transferType == TRANSFER_TYPE_PURCHASE) {
        
        if ([self.categoryDict objectForKey:@"Denom"]) {
            
            UIButton *dropDown = [UIButton buttonWithType:UIButtonTypeCustom];
            [dropDown setImage:[UIImage imageNamed:@"BUTTON BACK.png"] forState:UIControlStateNormal];
            CGSize _btnSize = CGSizeMake(60, self.amountField.frame.size.height);
            dropDown.frame = CGRectMake(CGRectGetWidth(self.amountField.frame)-_btnSize.width + 20, self.amountField.frame.origin.y, _btnSize.width, _btnSize.height);
            
            [dropDown addTarget:self action:@selector(createPickerView) forControlEvents:UIControlEventTouchUpInside];
            /*
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
            else
                [dropDown addTarget:self action:@selector(amountButtonTapped) forControlEvents:UIControlEventTouchUpInside];
             */
            [backGroubImage addSubview:dropDown];
            [self.amountField setUserInteractionEnabled:NO];
            
        }
        
        if ([[self.categoryDict objectForKey:@"paymentMode"] isEqualToString:kPackageType]) {
            
            self.denomArr = [[self.categoryDict objectForKey:@"Denom"] componentsSeparatedByString:@"|"];
            
            
            __block NSMutableArray *denom = [NSMutableArray array];
            
            [self.denomArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *str = (NSString *)[ self.denomArr objectAtIndex:idx ];
                str = [str substringFromIndex:[str rangeOfString:@"]"].location + 1];
                [denom addObject:str];
            }];
            
            self.denomArr = denom;
            
        } else {
            
            self.denomArr = [[self.categoryDict objectForKey:@"Denom"] componentsSeparatedByString:@"|"];
        }
        
        self.amountField.text = [self.denomArr objectAtIndex:0];
    }

    UITextField *field = (nil == self.amountField) ? self.accountNumberField : self.amountField;
    
    self.thirdLabel = [self createLabelwithFrame:CGRectMake(padding/1.5, field.frame.origin.y + CGRectGetHeight(field.frame), _fieldSize.width, _fieldSize.height)];
    [backGroubImage addSubview:self.thirdLabel];
    
    self.mpinField = [self createTextFieldwithFrame:CGRectMake(10.0f, self.thirdLabel.frame.origin.y+CGRectGetHeight(self.thirdLabel.frame), _fieldSize.width, _fieldSize.height)];
    self.mpinField.secureTextEntry = YES;
    [backGroubImage addSubview:self.mpinField];
    
    
    float Y_POS = 0.0F;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        Y_POS = 140.0f;
    } else {
        
        Y_POS = 75.0f;
        
    }
    
    


    backGroubImage.frame = CGRectMake(padding, Y_POS, CGRectGetWidth(self.view.frame) - padding*2,self.mpinField.frame.origin.y+CGRectGetHeight(self.mpinField.frame) + padding *2.8);
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake((CGRectGetWidth(self.view.frame) - DIALOG_BUTTON_SIZE.width)/2, backGroubImage.frame.origin.y+CGRectGetHeight(backGroubImage.frame) - DIALOG_BUTTON_SIZE.height - padding/4, DIALOG_BUTTON_SIZE.width, DIALOG_BUTTON_SIZE.height);
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button_empty.png"] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
        [submitButton setTitle:@"Next" forState:UIControlStateNormal];
    } else {
        [submitButton setTitle:@"Lanjut" forState:UIControlStateNormal];
    }
    
    [submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:submitButton aboveSubview:backGroubImage];
    
    [self.view insertSubview:backGroubImage atIndex:1];
    
    // make sure we "listen" for the keyboard so we can adjust the underlying view
   // [ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardWillShowNotification object:nil ];
    //[ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil ];
    
    [ [ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(successNofication:) name:kSUCCESSTRANASACTION object:nil ];
    
    
}


- (NSString *)titleSetUp
{
    NSString *t = nil;
    float _YPOS = 25.0f;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _YPOS = 75.0f;
    }

    
    switch (self.transferType) {
        case TRANSFER_TYPE_PAYMENT:
            t = PAYMENT;
            break;
            
        case TRANSFER_TYPE_PURCHASE:
            t= PURCHASE;
            break;
            
        case TRANSFER_TYPE_SELFBANK:
            t = SELF_BANK;
            if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
                [self subtitle:[NSString stringWithFormat:@"to %@",self.bankName]];
            } else {
                [self subtitle:[NSString stringWithFormat:@"ke %@",self.bankName]];
            }

            
            break;
        case TRANSFER_TYPE_UANGKU:
            t = SELF_BANK;
            if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
                [self subtitle:[NSString stringWithFormat:@"to UANGKU"]];
            } else {
                [self subtitle:[NSString stringWithFormat:@"ke UANGKU"]];
            }
            break;
        default:
            //t = OTHER_BANK;
            t= SELF_BANK;
            if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
                [self subtitle:[NSString stringWithFormat:@"to %@",self.bankName]];
            } else {
               [self subtitle:[NSString stringWithFormat:@"ke %@",self.bankName]];
            }
//            self.subTitleLabel.font         = [UIFont boldSystemFontOfSize:17.0];
//            self.subTitleLabel              = [[UILabel alloc] initWithFrame:CGRectMake(100.0, _YPOS-20 , 200.0, 30.0)];//(100.0, 50.0, 200.0, 30.0)

            break;
    }
    
    return t;
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    if (![[self.navigationController viewControllers] containsObject: self])
    {
        // the view has been removed from the navigation stack or hierarchy, back is probably the cause
        // this will be slow with a large stack however.
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kSUCCESSTRANASACTION object:nil];

    }
    
    [super viewWillDisappear:animated];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // self.firstLabel.text = @"account number";
    NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
    NSString *invoiceType = [self.categoryDict objectForKey:@"invoiceType"];

    if ((self.transferType == TRANSFER_TYPE_PURCHASE) || (self.transferType == TRANSFER_TYPE_PAYMENT)) {
        if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
            
            self.firstLabel.text = [[invoiceType componentsSeparatedByString:@"|"] objectAtIndex:0];
        } else {
            self.firstLabel.text = [[invoiceType componentsSeparatedByString:@"|"] objectAtIndex:1];
        }
    } else if (self.transferType == TRANSFER_TYPE_UANGKU) {
        if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
            self.firstLabel.text = @"Mobile Number";
        } else {
            self.firstLabel.text = @"Nomor Handphone";
        }
    } else {
        self.firstLabel.text = [textDict objectForKey:TRANSFER_ACCOUNT];

    }
    
    self.secondLabel.text = [textDict objectForKey:TRANSFER_AMOUNT];

    NSDictionary *parameters = [[SimobiManager shareInstance] responseData];
    
    if (([[parameters objectForKey:TXNNAME] isEqualToString:TXN_INQUIRY_PURCHASE_AIRTIME]) || ([[parameters objectForKey:TXNNAME] isEqualToString:TXN_CONFIRM_PURCHASE_AIRTIME])) {
        
        self.secondLabel.text = @"Available denoms";
    }

    self.thirdLabel.text = [textDict objectForKey:TRANSFER_MPIN];

    [self showHomeButton];
    [self showBackButton];
    [self title:[textDict objectForKey:[self titleSetUp]]];
    
}

- (UILabel *)createLabelwithFrame:(CGRect) frame
{
    
    UILabel *l = [[UILabel alloc] initWithFrame:frame];
    l.font            = [UIFont fontWithName:@"Helvetica" size:13.0f];
    l.text            = NSStringFromCGRect(frame);
    l.textColor       = [UIColor whiteColor];
    l.backgroundColor = [UIColor clearColor];
    return l;
    
}

- (UITextField *)createTextFieldwithFrame:(CGRect)frame
{
    
    UITextField *field = [[UITextField alloc] initWithFrame:frame];
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.delegate = self;
    field.keyboardType = UIKeyboardTypeNumberPad;
    return field;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)successNofication:(NSNotification*)notification
{
    
    NSArray *navigationStack = [self.navigationController viewControllers];
    
    @autoreleasepool {
        
        for (UIViewController *vC in navigationStack) {
            
            if ([vC isKindOfClass:[MainMenuViewController class]]) {
                
                [self.navigationController popToViewController:vC animated:YES];
                break;
            }
        }
    }
}

- (void) createPickerView {
    
    if (self.accountNumberField)
        [self.accountNumberField resignFirstResponder];
    if (self.mpinField)
        [self.mpinField resignFirstResponder];
    if (self.amountField)
        [self.amountField resignFirstResponder];
    
    
    
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [maskView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    
    [self.view addSubview:maskView];
    self.btnBarCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.btnBarCancel setTitle:@"Batal" forState:UIControlStateNormal];
    [self.btnBarCancel addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnBarDone = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44)];
    [self.btnBarDone setTitle:@"Pilih" forState:UIControlStateNormal];
    [self.btnBarDone addTarget:self action:@selector(btnBarDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _providerToolbar = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 344 +100, [UIScreen mainScreen].bounds.size.width, 44)];
    _providerToolbar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [_providerToolbar addSubview:self.btnBarCancel];
    [_providerToolbar addSubview:self.btnBarDone];
    [self.view addSubview:_providerToolbar];
    
    _providerPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300 + 100, 0, 0)];
    _providerPickerView.backgroundColor = [UIColor lightGrayColor];
    _providerPickerView.showsSelectionIndicator = YES;
    _providerPickerView.dataSource = self;
    _providerPickerView.delegate = self;
    
    [self.view addSubview:_providerPickerView];
    
    [self.view bringSubviewToFront:maskView];
    [self.view bringSubviewToFront:_providerToolbar];
    [self.view bringSubviewToFront:_providerPickerView];
}

- (void)amountButtonTapped
{
    if (self.accountNumberField)
        [self.accountNumberField resignFirstResponder];
    if (self.mpinField)
        [self.mpinField resignFirstResponder];
    if (self.amountField)
        [self.amountField resignFirstResponder];
    
    
    if (self.actionSheet) {
        
        [self.actionSheet.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self setActionSheet:nil];
    }
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:@"Simobi" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if (!self.pickerView) {
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0.0, 44.0, 320.0, 250.0)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.backgroundColor = [UIColor lightGrayColor];
    }
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlack;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    
    UIBarButtonItem *btnBarCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnBarCancelClicked:)];
    [barItems addObject:btnBarCancel];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *btnBarDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnBarDoneClicked:)];
    [barItems addObject:btnBarDone];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [self.actionSheet addSubview:pickerToolbar];
    [self.actionSheet addSubview:self.pickerView];
    
    flexSpace = nil;
    
    btnBarCancel = nil;
    
    barItems = nil;
    
    pickerToolbar = nil;
    [self.actionSheet showInView:SIMOBI_KEY_WINDOW];
    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 470.0)];
    
    
    
}


- (void)tapped
{

    [self.accountNumberField resignFirstResponder];
    [self.amountField resignFirstResponder];
    [self.mpinField resignFirstResponder];
    
}
- (void)btnBarCancelClicked:(id)sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void)dismissActionSheet:(id)sender{
    
    [maskView removeFromSuperview];
    [_providerPickerView removeFromSuperview];
    [_providerToolbar removeFromSuperview];
    
}

- (void)btnBarDoneClicked:(id)sender
{
    NSInteger index = [self.pickerView selectedRowInComponent:0];
    
    [self dismissActionSheet:sender];
    index= [_providerPickerView selectedRowInComponent:0];
    /*
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
    }else{
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        index = [self.pickerView selectedRowInComponent:0];
    }
     */
    
    self.amountField.text = [self.denomArr objectAtIndex:index];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)submitButtonAction:(id)sender
{
    if ([self.accountNumberField isValid]) {
        
        if ([self.amountField isValid] || self.amountField == nil) {
            
            if ([self.mpinField isValid]) {
                
                [self.activeTextField resignFirstResponder];
                [self.mpinField resignFirstResponder];
                
                NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithCapacity:0];
                NSString *mdn              = [[SimobiManager shareInstance] sourceMDN];
                NSString *amount = (nil == self.amountField) ? @"0" : self.amountField.text;
                [parms setObject:mdn                          forKey:SOURCEMDN];
                [parms setObject:amount                       forKey:AMOUNT];
                [parms setObject:self.mpinField.text          forKey:SOURCEPIN];
                
                /////////////////ADD PARAMETERS BASED ON TRANSFERTYPE////////////////////////////
                
                switch (self.transferType) {
                    case TRANSFER_TYPE_PAYMENT:
                    {
                        [parms setObject:self.accountNumberField.text forKey:BILLNO];
                        [parms setObject:POCKETCODE                   forKey:SOURCEPOCKETCODE];
                        [parms setObject:TXN_INQUIRY_PAYMENT          forKey:TXNNAME];

                    } break;
                    case TRANSFER_TYPE_PURCHASE:
                    {
                        if ([[self.categoryDict objectForKey:@"paymentMode"]isEqualToString:kPackageType]) {
                            
                            NSInteger index = [self.denomArr indexOfObject:self.amountField.text];
                            NSString *amountStr = [[[self.categoryDict objectForKey:@"Denom"] componentsSeparatedByString:@"|"] objectAtIndex:index];
                            
                            amountStr = [amountStr substringWithRange:NSMakeRange(1, [amountStr rangeOfString:@"]"].location - 1)];
                            [parms setObject:amountStr                       forKey:AMOUNT];
                        }
                        
                        
                          NSDictionary *d = [[SimobiManager shareInstance] responseData];

                        if ([[d objectForKey:TXNNAME] isEqualToString:TXN_INQUIRY_PURCHASE_AIRTIME]) {
                        
                            [parms setObject:self.accountNumberField.text forKey:DESTMDN];

                        } else {
                            [parms setObject:self.accountNumberField.text forKey:BILLNO];

                        }
                        [parms setObject:POCKETCODE                         forKey:SOURCEPOCKETCODE];
                        
                      //  NSDictionary *d = [[SimobiManager shareInstance] responseData];
                        
                        //CONDITIONLOG(DEBUG_MODE,@"Adam Testing the Purchase Inquiry Airtime or not:%@",[d objectForKey:SERVICE]);
                       // [parms setObject:([[d objectForKey:SERVICE] isEqualToString:TXN_CONFIRM_PURCHASE_AIRTIME])  ? TXN_INQUIRY_PURCHASE_AIRTIME : TXN_INQUIRY_PURCHASE forKey:TXNNAME];
                        
                       //[parms setObject:([[d objectForKey:SERVICE] isEqualToString:TXN_CONFIRM_PURCHASE_AIRTIME])  ? TXN_INQUIRY_PURCHASE : TXN_INQUIRY_PURCHASE_AIRTIME forKey:TXNNAME];

                        
                    } break;
                        
                    case TRANSFER_TYPE_SELFBANK: {
                        
                        [parms setObject:self.accountNumberField.text forKey:DESTBANKACCOUNT];
                        [parms setObject:TXN_INQUIRY_SELFBANK         forKey:TXNNAME];
                        [parms setObject:SERVICE_BANK                 forKey:SERVICE];
                        [parms setObject:POCKETCODE                   forKey:SOURCEPOCKETCODE];
                        [parms setObject:POCKETCODE                   forKey:DESTPOCETCODE];
                        
                    } break;
                        
                    case TRANSFER_TYPE_UANGKU: {
                        
                        [parms setObject:self.accountNumberField.text forKey:DESTACCOUNTNUMBER];
                        [parms setObject:TXN_INQUIRY_UANGKU         forKey:TXNNAME];
                        [parms setObject:SERVICE_BANK                 forKey:SERVICE];
                        [parms setObject:POCKETCODE                   forKey:SOURCEPOCKETCODE];
                        
                    } break;
                        
                    case TRANSFER_TYPE_OTHERBANK: {
                        [parms setObject:TXN_INQUIRY_OTHERBANK        forKey:TXNNAME];
                        [parms setObject:SERVICE_BANK                 forKey:SERVICE];
                        [parms setObject:POCKETCODE                   forKey:SOURCEPOCKETCODE];
                        [parms setObject:self.accountNumberField.text forKey:DESTACCOUNTNUMBER];
                        
                    } break;
                        
                    default:
                        break;
                }
                ////////////////////////////////////////////////////////////////
                
                
                [[[SimobiManager shareInstance] responseData] addEntriesFromDictionary:parms];
                [[[SimobiManager shareInstance] responseData] removeObjectForKey:CONFIRMED];
                [[[SimobiManager shareInstance] responseData] removeObjectForKey:PARENTTXNID];
                [[[SimobiManager shareInstance] responseData] removeObjectForKey:TRANSFERID];

                
                
                BOOL isCCPayment = NO;
                
                if ([self.categoryDict objectForKey:@"isCCPayment"]) {
                    
                    isCCPayment = (BOOL)[self.categoryDict objectForKey:@"isCCPayment"];
                }
                
                NSString *urlString = [SIMOBI_URL constructUrlStringWithParams:[[SimobiManager shareInstance] responseData]];

                if (isCCPayment) {
                  
                    [[[SimobiManager shareInstance] responseData] setObject:TXN_BILLINQUIRY forKey:TXNNAME];
                    [[[SimobiManager shareInstance] responseData] removeObjectForKey:AMOUNT];
                    urlString = [SIMOBI_URL constructUrlStringWithParams:[[SimobiManager shareInstance] responseData]];
                    
                }

                
                
                [self performServiceCallWithUrlString:urlString];
                
            } else {
                
                [SimobiAlert showAlertWithMessage:@"please enter mPin"];
            }
            
        } else {
            
            [SimobiAlert showAlertWithMessage:@"please enter amount"];
        }
        
    } else {
        [SimobiAlert showAlertWithMessage:@"please enter account number"];
    }
}

#pragma mark - UITextFieldDelgates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.activeTextField isEqual:self.accountNumberField]) {
        // [self.accountNumberField resignFirstResponder];
        [self.amountField becomeFirstResponder];
    } else if ([self.activeTextField isEqual:self.amountField]) {
        
        //  [self.amountField resignFirstResponder];
        [self.mpinField becomeFirstResponder];
    } else {
        [self.mpinField resignFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.mpinField){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 6) ? NO : YES;
    }
    
    return YES;
}


#pragma mark - Keyboard Handling

-(void)keyboardDidShowNotification:(NSNotification *)notification
{
    self.viewFrame = self.view.frame;
    
    float Y_POS = 0.0f;
    
    if ([self.activeTextField isEqual:self.accountNumberField]) {
        
        Y_POS = 70.0f;
        
    } else if ([self.activeTextField isEqual:self.amountField]) {
        
        Y_POS = 100.0f;
        
    } else {
        
        Y_POS = 120.0f;
        
    }
    NSTimeInterval interval = [ [ [ notification userInfo ] objectForKey:UIKeyboardAnimationDurationUserInfoKey ] doubleValue ];
    
    [ UIView animateWithDuration:interval animations:^{

        [self.view setFrame:CGRectMake(0, -Y_POS, self.view.frame.size.width, self.view.frame.size.height)];
        //self.controlContainerView.frame = self.originalControlRect;
    } ];
}

-(void)keyboardWillHideNotification:(NSNotification *)notification
{
    
    //self.keyboardRect = CGRectZero;
    NSTimeInterval interval = [ [ [ notification userInfo ] objectForKey:UIKeyboardAnimationDurationUserInfoKey ] doubleValue ];
    
    [ UIView animateWithDuration:interval animations:^{
        [self.view setFrame:self.viewFrame];
    } ];
}

- (void)performServiceCallWithUrlString:(NSString *)urlString
{
    
    
    Reachability *rechability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if ([rechability currentReachabilityStatus] == NotReachable) {
        
        [self noNetworkAlert];
        return;
    }

    [self displayProgressHudWithMessage:@"Loading"];
    
    [SimobiServiceModel connectURL:urlString successBlock:^(NSDictionary *response) {
        
        CONDITIONLOG(DEBUG_MODE,@"Response:%@",response);
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD hide];
            NSString *code = [[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"code"];
            //CONDITIONLOG(DEBUG_MODE,@"Code:%@",code);
            
            if ([code isEqualToString:SIMOBI_LOGIN_EXPIRE_CODE]) {
                
                [self reLoginAlertWithMessage:[[[response objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"]];
                return ;
                
            } else if (([code isEqualToString:SIMOBI_PAYMENT_SUCCESSCODE]) || ([code isEqualToString:SIMOBI_SELFBANK_TRANSFER_SUCCESSCODE]) ||([code isEqualToString:SIMOBI_PURCHASE_SUCCESSCODE])) {
                
                [[[SimobiManager shareInstance] responseData] setObject:@"true" forKey:CONFIRMED];
                [[[SimobiManager shareInstance] responseData] setObject:[[[response objectForKey:@"response"] objectForKey:PARENTTXNID] objectForKey:@"text"]      forKey:PARENTTXNID];//parentTxnID
                [[[SimobiManager shareInstance] responseData] setObject:[[[response objectForKey:@"response"] objectForKey:@"transferID"] objectForKey:@"text"]     forKey:TRANSFERID];
                
                switch (self.transferType) {
                    case TRANSFER_TYPE_SELFBANK: {
                        
                        [[[SimobiManager shareInstance] responseData]setObject:TXN_CONFIRM_SELFBANK forKey:TXNNAME];
                        [[[SimobiManager shareInstance] responseData] removeObjectForKey:AMOUNT];
                        
                    } break;
                    case TRANSFER_TYPE_UANGKU: {
                        
                        [[[SimobiManager shareInstance] responseData]setObject:TXN_CONFIRM_UANGKU forKey:TXNNAME];
                        [[[SimobiManager shareInstance] responseData] removeObjectForKey:AMOUNT];
                        
                    } break;
                    case TRANSFER_TYPE_OTHERBANK:{
                        
                        [[[SimobiManager shareInstance] responseData] setObject:TXN_CONFIRM_OTHERBANK forKey:TXNNAME];
                        [[[SimobiManager shareInstance] responseData] removeObjectForKey:AMOUNT];
                        
                    } break;
                    case TRANSFER_TYPE_PAYMENT:  {
                        
                        [[[SimobiManager shareInstance] responseData]setObject:TXN_CONFIRM_PAYMENT forKey:TXNNAME];
                        
                    } break;
                    case TRANSFER_TYPE_PURCHASE: {
                        
                        if ([[[[SimobiManager shareInstance] responseData] objectForKey:TXNNAME] isEqualToString:TXN_INQUIRY_PURCHASE_AIRTIME]) {
                            
                            [[[SimobiManager shareInstance] responseData] setObject:TXN_CONFIRM_PURCHASE_AIRTIME forKey:TXNNAME];
                            
                        } else {
                            [[[SimobiManager shareInstance] responseData] setObject:TXN_CONFIRM_PAYMENT forKey:TXNNAME];
                        }
                    } break;
                        
                        
                    default:
                        break;
                }
                
                [[[SimobiManager shareInstance] responseData] removeObjectForKey:SOURCEPIN];
                
                // [self.navigationController presentViewController:navVC animated:YES completion:NULL];
                
                if (self.transferType == TRANSFER_TYPE_SELFBANK || self.transferType == TRANSFER_TYPE_OTHERBANK) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    
                    if (OBJECTFORKEY(response, @"destinationAccountNumber")) {
                        
                        [dict setObject:OBJECTFORKEY(response, @"destinationAccountNumber") forKey:@"Destination number"];
                    }
                    
                    if (OBJECTFORKEY(response, @"debitamt")) {
                        [dict setObject:OBJECTFORKEY(response, @"debitamt") forKey:@"Amount"];
                        
                    }
                    
                    if (OBJECTFORKEY(response, @"destinationBank")) {
                        [dict setObject:OBJECTFORKEY(response, @"destinationBank") forKey:@"Destination bank"];
                        
                    }
                    if (OBJECTFORKEY(response, @"destinationName")) {
                        [dict setObject:OBJECTFORKEY(response, @"destinationName") forKey:@"Account owner"];
                    }
                    
                    [DialogHUD displayWithParameters:dict withservice:[self getServiceType]];
                    
                } else if (self.transferType == TRANSFER_TYPE_UANGKU){
                
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    
                    if (OBJECTFORKEY(response, @"destinationAccountNumber")) {
                        
                        [dict setObject:OBJECTFORKEY(response, @"destinationAccountNumber") forKey:@"Nomor HP"];
                    }
                    
                    if (OBJECTFORKEY(response, @"debitamt")) {
                        [dict setObject:OBJECTFORKEY(response, @"debitamt") forKey:@"Jumlah"];
                        
                    }
                    
                    if (OBJECTFORKEY(response, @"destinationName")) {
                        [dict setObject:OBJECTFORKEY(response, @"destinationName") forKey:@"Nama"];
                    }
                    
                    [DialogHUD displayWithParameters:dict withservice:[self getServiceType]];
                
                
                
                }else if (self.transferType == TRANSFER_TYPE_PAYMENT || self.transferType == TRANSFER_TYPE_PURCHASE){
                    
                    NSString *messaage = OBJECTFORKEY(response, @"message");
                    
                    if (OBJECTFORKEY(response, @"AdditionalInfo")) {
                        messaage = [messaage stringByAppendingString:@"\n"];
                        NSString *additionalInfo = OBJECTFORKEY(response, @"AdditionalInfo");
                        messaage = [messaage stringByAppendingString:[additionalInfo stringByReplacingOccurrencesOfString:@"|" withString:@"\n"]];
                    }
                    
                    [DialogHUD displayWithMessage:messaage withservice:[self getServiceType]];
                    
                }
                
            } else if ([code isEqualToString:SIMOBI_BILLINQUIRY_CODE]) {
            
                BillInquiryViewController *bIVC = [[BillInquiryViewController alloc] init];
                
                NSString *messaage = OBJECTFORKEY(response, @"message");
                
                if (OBJECTFORKEY(response, @"AdditionalInfo")) {
                    messaage = [messaage stringByAppendingString:@"\n"];
                    
                    NSString *additionalInfo = OBJECTFORKEY(response, @"AdditionalInfo");
                    messaage = [messaage stringByAppendingString:[additionalInfo stringByReplacingOccurrencesOfString:@"|" withString:@"\n"]];
                }

                NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                
                
                [d setObject:OBJECTFORKEY(response, @"message") forKey:@"message"];
                [d setObject:OBJECTFORKEY(response, @"AdditionalInfo") forKey:@"additionalInfo"];
                [d setObject:OBJECTFORKEY(response, @"amount") forKey:@"amount"];
                bIVC.responseData = d;
                [self.navigationController pushViewController:bIVC animated:YES];

            } else {
                
                [SimobiAlert showAlertWithMessage:OBJECTFORKEY(response, @"message")];
            }
        });
    } failureBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD hide];
            
            NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
            [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
            
            
            /*if (error.code == NSURLErrorTimedOut) {
                // Handle time out here
                NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR_FINANCE]];
            }else{
                [SimobiAlert showAlertWithMessage:error.localizedDescription];
            }*/

        });
        
    }];
    
    
}

- (Service)getServiceType
{
    if (self.transferType == TRANSFER_TYPE_SELFBANK) {
        
        return Service_TRANSFER;
        
    } else if (self.transferType == TRANSFER_TYPE_PAYMENT) {
        return Service_PAYMENT;
        
        
    } else if (self.transferType == TRANSFER_TYPE_PURCHASE) {
        return Service_PURCHASE;
        
    } else if (self.transferType == TRANSFER_TYPE_OTHERBANK) {
        return Service_TRANSFER;
    }
    else if (self.transferType == TRANSFER_TYPE_UANGKU) {
        return Service_UANGKU;
    }
    
    return Service_BALANCE;
}


#pragma mark - UIPIckerView DataSource Methods

#pragma mark - UIPickerViewDataSource

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.denomArr count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = [self.denomArr objectAtIndex:row];
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}



- (void)viewDidUnload
{
    [self setAccountNumberField:nil];
    [self setAmountField:nil];
    [self setMpinField:nil];
    [self setDenomArr:nil];
    [self setActionSheet:nil];
    [self setPickerView:nil];
    [self setFirstLabel:nil];
    [self setSecondLabel:nil];
    [self setThirdLabel:nil];
    [super viewDidUnload];
}
@end
