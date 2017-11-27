//
//  RootViewController.m
//  Simobi
//
//  Created by Ravi on 10/7/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "RootViewController.h"
#import "SimobiLoginViewController.h"
#import "ActivationViewController.h"
#import "ContactUSViewController.h"
#import "BillInquiryViewController.h"
#import "SimobiWrapper.h"
#import "TermsViewController.h"
@interface RootViewController ()
@property (nonatomic, strong) NSMutableArray *dataImageUrl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *activationBtn;

@property UIView *viewSimobiPlusUpgrade;
@property UIWindow *viewWindow;

@end

@implementation RootViewController
static int currentIndexImage = 0;

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
    
    if (IS_IPHONE_5) {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y += 60;
        self.bgView.frame = bgviewFrame;
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y += 10;
        self.bgView.frame = bgviewFrame;
    } else {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y += 40;
        self.bgView.frame = bgviewFrame;
    }
    
    if (IS_IPHONE_4_OR_LESS) {
        static float adjust = 90;
        // adjust button term and condition + contact
        CGRect frame = self.termConditionBtn.frame;
        frame.origin.y -= adjust;
        self.termConditionBtn.frame = frame;
        
        frame = self.contactUsBtn.frame;
        frame.origin.y -= adjust;
        self.contactUsBtn.frame = frame;
    }

    [self performSelectorInBackground:@selector(showSliderImage) withObject:nil];

    self.loginBtn.layer.cornerRadius = 10;
    self.loginBtn.clipsToBounds = YES;
    self.activationBtn.layer.cornerRadius = 10;
    self.activationBtn.clipsToBounds = YES;
    
    self.viewWindow = [[UIApplication sharedApplication] keyWindow];
    
    // [self showSimobiPlusUpgrade];
}
- (void)showSliderImage {
    //current index slider
    currentIndexImage = 0;
    NSMutableArray *arrayImageURL = [@[] mutableCopy];
    
    // get the data images url from banksinarmas
    NSString *stringUrl = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://banksinarmas.com/id/slidersimobi.php"] encoding:NSUTF8StringEncoding error:nil];
    stringUrl = [stringUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *filterArray = [stringUrl componentsSeparatedByString:@"\n"];
    
    if (filterArray.count > 0) {
        int i = 1;
        for (NSString *str in filterArray) {
            NSString *imgUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if (imgUrl.length > 0) {
                if ([imgUrl rangeOfString:@"http"].location == NSNotFound) {
                    imgUrl = [NSString stringWithFormat:@"http://banksinarmas.com%@", imgUrl];
                }
                if ([imgUrl rangeOfString:@"\""].location == NSNotFound) {
                    NSString *tempString = imgUrl;
                    NSMutableArray *array = [[tempString componentsSeparatedByString:@"\""] mutableCopy];
                    imgUrl = [array objectAtIndex:0];
                }
                [arrayImageURL addObject:imgUrl];
            }
            i++;
        }
    }
    self.dataImageUrl = arrayImageURL;
    [self performSelectorOnMainThread:@selector(showSliderInMainThread) withObject:nil waitUntilDone:YES];
}

- (void)showSliderInMainThread {
    NSMutableArray *arrayImageURL = self.dataImageUrl;
    
    self.scrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.scrollView.layer.borderWidth = 1;
    self.scrollView.layer.cornerRadius = 8;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // check if the data is not empty
    if (arrayImageURL.count == 0) {
        // adjust UI without images
        self.pageControl.hidden = YES;
        return;
    }
    
    
    self.pageControl.numberOfPages = arrayImageURL.count;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.userInteractionEnabled = NO;
    [self.view addSubview:self.pageControl];
    
    // find UISwipeGestureRecognizer for left swipe to action previous image
    // find UISwipeGestureRecognizer for right swipe to action next image
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.scrollView addGestureRecognizer:recognizer];
    
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.scrollView addGestureRecognizer:recognizer];
    
    
    // dont forget to add gesture
    float x = 0;
    float widthImage = self.scrollView.frame.size.width;
    float heightImage = self.scrollView.frame.size.height;
    for (int i = 0; i < arrayImageURL.count  ; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, widthImage, heightImage )];
        imageView.backgroundColor = [UIColor grayColor];
        [self.scrollView addSubview:imageView];
        
        // add activity indicator
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicator startAnimating];
        indicator.center = imageView.center;
        [self.scrollView addSubview:indicator];
        
        x += widthImage ;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[arrayImageURL objectAtIndex:i]]];
            if (imageData && imageData.length > 0) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //Run UI Updates
                    UIImage *image = [UIImage imageWithData:imageData];
                    imageView.image = image;
                    [indicator setHidesWhenStopped:true];
                    [indicator stopAnimating];
                    indicator.hidden = true;
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // do nothing
                });
            }
        });
    }
    self.scrollView.contentSize = CGSizeMake(arrayImageURL.count * widthImage, self.scrollView.frame.size.height);
}

- (void)tapped

{
    // Tapped
}

- (void)viewDidUnload
{
    
    [self setLoginLBL:nil];
    [self setActivationLBL:nil];
    [self setBgView:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    
    NSDictionary*textDict = [[SimobiManager shareInstance] textDataForLanguage];
    
    self.loginLBL.text = @"Login";
    self.activationLBL.text = [textDict objectForKey:ACTIVATION];
    
    [self.contactUsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contactUsBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    [self.termConditionBtn setTitle:@"Terms & Condition" forState:UIControlStateNormal];
   
    if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
         [self.contactUsBtn setTitle:@"Contact Us" forState:UIControlStateNormal];
    } else {
         [self.contactUsBtn setTitle:@"Hubungi Kami" forState:UIControlStateNormal];
    }
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, self.contactUsBtn.frame.size.height - 1, self.contactUsBtn.frame.size.width, 1);
    line.backgroundColor = self.contactUsBtn.titleLabel.textColor.CGColor;
    [self.contactUsBtn.layer addSublayer:line];
 
    [self.termConditionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.termConditionBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
        [self.termConditionBtn setTitle:@"Terms & Condition" forState:UIControlStateNormal];
    } else {
        [self.termConditionBtn setTitle:@"Syarat & Ketentuan" forState:UIControlStateNormal];
    }
    
    line = [CALayer layer];
    line.frame = CGRectMake(0, self.termConditionBtn.frame.size.height - 1, self.termConditionBtn.frame.size.width, 1);
    line.backgroundColor = self.termConditionBtn.titleLabel.textColor.CGColor;
    [self.termConditionBtn.layer addSublayer:line];
    
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
    [self.viewSimobiPlusUpgrade addSubview:imgClose];
    [self.viewSimobiPlusUpgrade addSubview:btnCancel];
    [self.viewWindow addSubview:_viewSimobiPlusUpgrade];
}

- (void)actionCancelSimobiPlusUpgrade {
    [self.viewSimobiPlusUpgrade removeFromSuperview];
}


/*
 * Migration Button Action
 */
- (void)actionSimobiPlusUpgrade {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Here your non-main thread.
        [NSThread sleepForTimeInterval:0.3f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self actionCancelSimobiPlusUpgrade];
        });
    });
    SimobiLoginViewController *loginViewController = [[SimobiLoginViewController alloc] initWithNibName:@"SimobiLoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
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


- (void)didSwipe:(UISwipeGestureRecognizer *)recognizer {
    if ([recognizer direction] == UISwipeGestureRecognizerDirectionLeft) {
        //Swipe from right to left
        //Do your functions here
        if (currentIndexImage == self.dataImageUrl.count - 1) {
            // end of images, ATM do nothing
        } else {
            // next image
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width, self.scrollView.contentOffset.y) animated:YES];
            
            currentIndexImage++;
            
        }
    } else {
        //Swipe from left to right
        //Do your functions here
        if (currentIndexImage == 0) {
            // start image, ATM do nothing
        } else {
            // prev image
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - self.scrollView.frame.size.width, self.scrollView.contentOffset.y) animated:YES];
            currentIndexImage--;
        }
    }
    
    
    // indicator page updated with currentIndexImage
    self.pageControl.currentPage = currentIndexImage;
    
    
}

- (IBAction)loginButtonAction:(id)sender
{
//    ActivationViewController *activityViewController = [[ActivationViewController alloc] initWithparent:ParentControllerTypeAccountChange];
//    [self.navigationController pushViewController:activityViewController animated:YES];
    SimobiLoginViewController *loginViewController = [[SimobiLoginViewController alloc] initWithNibName:@"SimobiLoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}

- (IBAction)activationBUttonAction:(id)sender

{
    
    ActivationViewController *activityViewController = [[ActivationViewController alloc] initWithparent:ParentControllerTypeRoot];
    [self.navigationController pushViewController:activityViewController animated:YES];

}

- (IBAction)contactUSButtonAction:(id)sender
{
    ContactUSViewController *contactVC = [[ContactUSViewController alloc] initWithNibName:@"ContactUSViewController" bundle:nil];
    [self.navigationController pushViewController:contactVC animated:YES];
    
}

- (IBAction)termsButtonAction:(id)sender {
    TermsViewController *termsViewController = [[TermsViewController alloc]init];
    [self.navigationController pushViewController:termsViewController animated:YES];
}


@end
