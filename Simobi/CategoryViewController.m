//
//  CategoryViewController.m
//  Simobi
//
//  Created by Ravi on 10/15/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "CategoryViewController.h"
#import "UITextField+Extension.h"
#import "NSString+Extension.h"
#import "TransferDetailsViewController.h"
#import "Reachability.h"


#define kIndex  0
#define MobileCategory @"Mobile Phone"

@interface CategoryViewController ()
{
    UIView *maskView;
    UIPickerView *_providerPickerView;
    UIView *_providerToolbar;
}
@property (nonatomic,strong)UIButton *btnBarDone;
@property (nonatomic,strong)UIButton *btnBarCancel;
@property (nonatomic,strong)NSMutableDictionary *metaDictionary;

@property (assign)BOOL isAirtime;

@end

@implementation CategoryViewController


@synthesize metaDictionary;
@synthesize fieldType;
@synthesize parentClass,pickerView,isAirtime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (instancetype)initWithParentClass:(ParentClass)parent
{

    self = [super initWithNibName:@"CategoryViewController" bundle:nil];
    if (self) {
        // Custom initialization
        
        self.parentClass = parent;
    }
    return self;


}

#pragma mark - ViewLifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.metaDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];

    self.bgView.layer.cornerRadius = 10.0f;
    self.bgView.layer.borderWidth  = 3.0f;
    self.bgView.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    UIImageView *imgView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TRANSPARENT SCREEN.png"]];
    imgView.frame = CGRectMake(0.0f,0.0f,CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame));
    imgView.userInteractionEnabled = YES;
    [self.bgView insertSubview:imgView atIndex:0];
    
    CGRect _frame = self.bgView.frame;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))  {
        
        _frame.origin.y = 150.0f;
    } else {
        _frame.origin.y = 75.0f;
        
    }
    self.bgView.frame = _frame; 
    
    self.isAirtime = NO;
   [self getDataFromService];
    self.submitBtn.layer.cornerRadius = 10.0f;
    self.submitBtn.clipsToBounds = YES;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showHomeButton];
    [self showBackButton];
    
    NSDictionary * dict = [[SimobiManager shareInstance] textDataForLanguage];
    [self.submitBtn setTitle:[dict objectForKey:NEXT] forState:UIControlStateNormal];
    [self title:(self.parentClass == ParentClass_Payment) ? [dict objectForKey:PAYMENT] : [dict objectForKey:PURCHASE]];

    self.categoriesLBL.text = (self.parentClass == ParentClass_Payment) ? [dict objectForKey:PAYMENTCATEGORY] : [dict objectForKey:PURCHASECATEGORY];
    self.billerLBL.text = (self.parentClass == ParentClass_Payment) ? [dict objectForKey:BILLER] : [dict objectForKey:BILLER];
    self.productLBL.text = (self.parentClass == ParentClass_Payment) ? [dict objectForKey:PAYMENTPRODUCT] : [dict objectForKey:PURCHASEPRODUCT];

}
/*
 *Call Web Service to Display Data
 */
- (void)getDataFromService
{
    Reachability *rechability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if ([rechability currentReachabilityStatus] == NotReachable) {
        
        [self noNetworkAlert];
        return;
    }
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD displayWithMessage:@"Loading"];
        });
        NSString *urlString = (self.parentClass == ParentClass_Payment) ? SIMOBI_PAYMENT_DATA_URL : SIMOBI_PURCHASE_DATA_URL;
        [SimobiServiceModel connectJSONURL:urlString successBlock:^(NSData *responseData)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 id JSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                 
                 NSDictionary *dataDict = [NSDictionary dictionary];
                 if ( [NSJSONSerialization isValidJSONObject:JSON ] )
                 {
                     dataDict  = (NSDictionary *)JSON;
                     
                 }
                 NSString *mainKey = (self.parentClass == ParentClass_Payment) ? @"paymentData" : @"purchaseData";
                 NSArray*categoryArray = [dataDict objectForKey:mainKey];
                

                 [categoryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                     
                     NSDictionary *category = (NSDictionary *)[categoryArray objectAtIndex:idx];
                     
                     NSArray *providers = [category objectForKey:@"providers"];
                     
                     __block NSMutableArray *providersArray = [NSMutableArray array];
                     
                     [providers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         
                         NSDictionary *provider = [providers objectAtIndex:idx];
                         
                         [providersArray addObject:[NSDictionary dictionaryWithObject:[provider objectForKey:@"products"] forKey:[provider objectForKey:@"providerName"]]];
                     }];
                     
                     [self.metaDictionary setObject:providersArray forKey:[category objectForKey:@"productCategory"]];
                 }];
                 

                 [ProgressHUD hide];
                 
             });
             
             
         } failureBlock:^(NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [ProgressHUD hide];
                 
                 //[SimobiAlert showAlertWithMessage:error.localizedDescription];
                 NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                 [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
                 
             });
         }];

    

}
- (void)viewDidUnload
{
    
    self.actionSheet = nil;
    self.metaDictionary = nil;
    [self setPickerView:nil];
    [self setCategoryField:nil];
    [self setBillerField:nil];
    [self setProductField:nil];
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createPickerView {
    
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

- (void)enableActionSheet
{

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

- (void)btnBarCancelClicked:(id)sender
{
    [self.actionSheet dismissWithClickedButtonIndex:kIndex animated:YES];

}

- (void)btnBarDoneClicked:(id)sender
{
    
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];

    if ([self.metaDictionary allKeys] == 0) {
    
        return;
    }

    NSInteger row ;
    [self dismissActionSheet:sender];
    row = [_providerPickerView selectedRowInComponent:kIndex];
    /*
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
    }else{
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        row = [self.pickerView selectedRowInComponent:kIndex];
    }
     */
    
    NSArray *dataSource = [self dataForPickerWithFieldType:self.fieldType];
    
    switch (self.fieldType) {
        case FieldType_Category:
        {
            NSString *text = self.categoryField.text;
            if (![text isEqualToString:[dataSource objectAtIndex:row]]) {
               
                self.billerField.text = @"";
                self.productField.text = @"";
             }
            self.categoryField.text = [dataSource objectAtIndex:row];
        }
            break;
        case FieldType_Biller:
        {
            
            NSString *text = self.billerField.text;
            if (![text isEqualToString:[dataSource objectAtIndex:row]]) {
                self.productField.text = @"";
            }

            self.billerField.text = [dataSource objectAtIndex:row];
      
        }
            break;
        case FieldType_Product:
        {
            NSDictionary *d = [dataSource objectAtIndex:row];
            self.productField.text = [d objectForKey:@"productName"];
            
        
        }
            break;
            
        default:
            break;
    }
}

- (void)dismissActionSheet:(id)sender{
    
    [maskView removeFromSuperview];
    [_providerPickerView removeFromSuperview];
    [_providerToolbar removeFromSuperview];
    
}
#pragma mark - UIPickerViewDataSource

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { 
    NSUInteger numRows = [self rowsCountForFieldType:self.fieldType];
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = nil;
    
    NSArray *dataSource = [self dataForPickerWithFieldType:self.fieldType];
    
    id class = [dataSource objectAtIndex:row];
    
    if (self.fieldType == FieldType_Product) {
        
            if ([class isKindOfClass:[NSDictionary class]]) {
            NSDictionary *d = [dataSource objectAtIndex:row];
            title = [d objectForKey:@"productName"];
        }
    }else {
        title = [dataSource objectAtIndex:row];
    }
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}



#pragma mark - Convience Methods

- (IBAction)submitButtonAction:(id)sender
{
    if ([self performTextFieldValidation]) {
    
      //To do Service Call
        [[[SimobiManager shareInstance] responseData] removeAllObjects];
        
        __block NSDictionary *productData = nil;

        NSArray *dataSource = [self dataForPickerWithFieldType:self.fieldType];
        [dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *d = [dataSource objectAtIndex:idx];
            if ([[d objectForKey:@"productName"] isEqualToString:self.productField.text]) {
            
                
                productData = d;

                *stop = YES;
            }
        }];
        //CONDITIONLOG(DEBUG_MODE,@"Data:%@",productData);

        
        TransferDetailsViewController *transferVC = [[TransferDetailsViewController alloc] initWithTranferType:(self.parentClass == ParentClass_Payment) ? TRANSFER_TYPE_PAYMENT : TRANSFER_TYPE_PURCHASE];
        transferVC.categoryDict = productData;
        NSString *mdn = [[SimobiManager shareInstance] sourceMDN];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];

        if (self.parentClass == ParentClass_Purchase) {
            
            if ([self.categoryField.text isEqualToString:@"Mobile Phone"]) {
                [params setObject:SERVICE_PURCHASE_AIRTIME                  forKey:SERVICE];
                [params setObject:TXN_INQUIRY_PURCHASE_AIRTIME              forKey:TXNNAME];
                [params setObject:[productData objectForKey:@"productCode"] forKey:COMPANYID];
                [params setObject:[productData objectForKey:@"paymentMode"] forKey:@"paymentMode"];

            } else {
            
                [params setObject:SERVICE_PAYMENT                           forKey:SERVICE];
                [params setObject:TXN_INQUIRY_PAYMENT                       forKey:TXNNAME];
                [params setObject:[productData objectForKey:@"productCode"] forKey:BILLERCODE];
                [params setObject:[productData objectForKey:@"paymentMode"] forKey:@"paymentMode"];
            
            }
            
            [params setObject:@"Purchase" forKey:@"type"];
        
        } else {
            [params setObject:SERVICE_PAYMENT                           forKey:SERVICE];
            [params setObject:[productData objectForKey:@"productCode"] forKey:BILLERCODE];
            [params setObject:[productData objectForKey:@"paymentMode"] forKey:@"paymentMode"];
            [params setObject:@"Payment" forKey:@"type"];


        }
        [params setObject:mdn forKey:SOURCEMDN];

        [[[SimobiManager shareInstance] responseData] addEntriesFromDictionary:params];
        [self.navigationController pushViewController:transferVC animated:YES];

    }
}

- (BOOL)performTextFieldValidation
{
    BOOL _valid = NO;
    if ([self.categoryField isValid]) {
        
        if ([self.billerField isValid]) {
            
            if ([self.productField isValid]) {
                
                _valid = YES;
            } else {
                [SimobiAlert showAlertWithMessage:@"please choose product"];
                
            }
        } else {
            
            [SimobiAlert showAlertWithMessage:@"please choose biller"];

        }
    } else {
        [SimobiAlert showAlertWithMessage:@"please choose category"];

    }

    return _valid;
}
- (IBAction)dropDownBtnAction:(id)sender {
    
    
    UIButton *target = (UIButton *)sender;
    
    switch (target.tag) {
        case FieldType_Category:
            
            self.fieldType = FieldType_Category;
            
            break;
            
        case FieldType_Biller:
            
            self.fieldType = FieldType_Biller;

            if (![self.categoryField isValid]) {
              
                [SimobiAlert showAlertWithMessage:@"please choose category"];
                return;

            }
    

            break;
            
        case FieldType_Product:
            
            //[self performTextFieldValidation];
            self.fieldType = FieldType_Product;
            if (![self.categoryField isValid]) {
                [SimobiAlert showAlertWithMessage:@"please choose category"];
                return;

            } else if (![self.billerField isValid]) {
                [SimobiAlert showAlertWithMessage:@"please choose biller"];
                return;
            }


            break;
            
        default:
            break;
    }
    
    
    [self.pickerView reloadComponent:0];
    [self createPickerView];
    /*
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        [self createPickerView];
    else
        [self enableActionSheet];
*/
}


- (NSInteger)rowsCountForFieldType:(FieldType)type
{
   // NSInteger rows = 0;
__block NSArray *data = [NSArray array];
    
    switch (type) {
        case FieldType_Category:
        {
            data = [self.metaDictionary allKeys];
            //rows = [dataArray count];
        
        }
            break;
            
            case FieldType_Biller:
        {
            data = [self.metaDictionary objectForKey:self.categoryField.text];
            
            __block NSMutableArray *array = [NSMutableArray array];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *d = [data objectAtIndex:idx];
                [array addObject:[[d allKeys] objectAtIndex:kIndex]];
                
            }];
            data = array;
            
        }
            break;
            
        case FieldType_Product:
        {
            __block NSMutableArray *array = [NSMutableArray array];

            data = [self.metaDictionary objectForKey:self.categoryField.text];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *d = [data objectAtIndex:idx];
                if ([[d allKeys] indexOfObject:self.billerField.text] != NSNotFound) {
                    array = [d objectForKey:self.billerField.text];
                    
                    *stop = YES;
                }
            }];
            
            data = array;
            //CONDITIONLOG(DEBUG_MODE,@"Data:%d",data.count);
        }
            break;

        
        default:
            break;
    }
    
    return data.count;
    
}


- (NSArray *)dataForPickerWithFieldType:(FieldType)type
{

   __block NSArray *data = [NSArray array];
    
    switch (type) {
        case FieldType_Category:
        {
            data = [self.metaDictionary allKeys];
            
        }
            break;
            
        case FieldType_Biller:
        {
            data = [self.metaDictionary objectForKey:self.categoryField.text];
            __block NSMutableArray *array = [NSMutableArray array];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *d = [data objectAtIndex:idx];
                [array addObject:[[d allKeys] objectAtIndex:kIndex]];
                

            }];
            
            data = array;

        }
            break;
            
        case FieldType_Product:
        {
            __block NSMutableArray *array = [NSMutableArray array];

            data = [self.metaDictionary objectForKey:self.categoryField.text];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *d = [data objectAtIndex:idx];
                if ([[d allKeys] indexOfObject:self.billerField.text] != NSNotFound) {
                    
                    
                    array = [d objectForKey:self.billerField.text];
                    
                    *stop = YES;
                }
            }];
            
            data = array;
            //CONDITIONLOG(DEBUG_MODE,@"Data:%@",data);


        }
            break;
            
            
        default:
            break;
    }
    
    
    
    return data;

}
@end
