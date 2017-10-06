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
