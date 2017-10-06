//
//  BaseViewController.m
//  Simobi
//
//  Created by Ravi on 10/7/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MainMenuViewController.h"
#import "SimobiLoginViewController.h"

@interface BaseViewController ()
@property (nonatomic,weak)UIButton *backButton;
@property (nonatomic,weak)UIButton *homeButton;
@end

@implementation BaseViewController

@synthesize isNetworkReachable;
@synthesize backButton,homeButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Tap Gesture
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:tapGesture];
    
    //Background Image Setup
    UIImageView *backGroundImg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backGroundImg setImage:[UIImage imageNamed:@"Background.png"]];
    [self.view insertSubview:backGroundImg atIndex:0];
    
    //Setup image to NavigationBar
    UIImage *image = [UIImage imageNamed: @"TOPBAR.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //Set Up Logo to NavigationBar
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sina_logo.png"]];
    logo.frame = CGRectMake(0, 0, 125, 40);
    UIBarButtonItem * item                = [[UIBarButtonItem alloc] initWithCustomView:logo];
    item.enabled                          = NO;
    self.navigationItem.leftBarButtonItem = item;
    
    CGRect _backBtnFrame     = CGRectMake((CGRectGetWidth(self.view.frame) - 100.0f)/2, CGRectGetHeight(self.view.frame) - 30.0f - 20.0f, 80.0f , 45.0);

    
    //Set Up for Back Button
    
    
    
    
    float _YPOS = 25.0f;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _YPOS = 75.0f;
    }

    if (!self.backButton) {
        
        UIButton *backButon        = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtnFrame          = CGRectMake(5, _YPOS - 10, 50.0, 50.0);
        backButon.frame  = _backBtnFrame;
        [backButon setImage:[UIImage imageNamed:@"BUTTON BACK WHITE.png"] forState:UIControlStateNormal];
        [backButon addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        backButon.tag = 100;
        [self.view addSubview:backButon];
        [backButon setHidden:YES];
        
    }
    
    //Set Up for Home Button

    if (!self.homeButton) {
        
         UIButton *homeButon       = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect _homeBtnFrame  = CGRectMake(265.0, _YPOS - 15, 50.0, 50.0);
        homeButon.frame = _homeBtnFrame;
        [homeButon setImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
        [homeButon addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        homeButon.tag = 200;
        [self.view addSubview:homeButon];
        [homeButon setHidden:YES];
    }

    //Set Up title Label
    CGPoint _center           = CGPointMake(self.view.center.x, _YPOS + 15.0f);
    if (!_titleLable) {
        
        _titleLable                    = [[UILabel alloc] initWithFrame:CGRectMake(120.0, _YPOS, 200, 30.0)];//(120.0, 25.0, 200, 30.0)
        _titleLable.font               = [UIFont boldSystemFontOfSize:17.0];
        _titleLable.textColor          = [UIColor whiteColor];
        _titleLable.textAlignment      = NSTextAlignmentCenter;
        _titleLable.center             = _center;
        _titleLable.backgroundColor    = [UIColor clearColor];
        [self.view addSubview:_titleLable];

    }
    
    //Set Up Sub-Title Label
    if (!self.subTitleLabel) {
        self.subTitleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(100.0, _YPOS + 30.0f, 200.0, 30.0)];//(100.0, 50.0, 200.0, 30.0)
        _center                             = CGPointMake(self.view.center.x, self.titleLable.center.y + 15.0f);
        self.subTitleLabel.center      = _center;
        self.subTitleLabel.textColor  = [UIColor whiteColor];
        self.subTitleLabel.font         = [UIFont boldSystemFontOfSize:14.0];
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subTitleLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.subTitleLabel];

    }

}

- (void)noNetworkAlert

{
    dispatch_async(dispatch_get_main_queue(), ^{
       // NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
       // [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Simobi" message:@"Lost Network connectivity.\nPlease try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //alert.tag          = 999;
        [alert show];

    });

}

- (void)reLoginAlertWithMessage:(NSString *)alertMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Simobi" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag          = 666;
    [alert show];
    });

}

- (void)tapped
{
  //Tapped
}

#pragma mark - UIAlertiew Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (alertView.tag == 666) {
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[SimobiLoginViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}
#pragma mark - CustomMethods

- (void)title:(NSString *)titleStr
{
    self.titleLable.hidden = NO;
    self.titleLable.text = titleStr;
}
- (void)subtitle:(NSString *)titleStr
{
    self.subTitleLabel.hidden = NO;
    self.subTitleLabel.text = titleStr;
}
- (void)showBackButton
{
    self.backButton.hidden = NO;

    UIButton *backBtn = (UIButton *)[self.view viewWithTag:100];
    backBtn.hidden = NO;
}

- (void)hideBackButton
{
    self.backButton.hidden = YES;
    
    UIButton *backBtn = (UIButton *)[self.view viewWithTag:100];
    backBtn.hidden = YES;
}

- (void)hideHomeButton
{
    self.homeButton.hidden = YES;
    
    UIButton *homeBtn = (UIButton *)[self.view viewWithTag:200];
    homeBtn.hidden = YES;
}
- (void)showHomeButton

{
    self.homeButton.hidden = NO;
    
    UIButton *homeBtn = (UIButton *)[self.view viewWithTag:200];
    homeBtn.hidden = NO;
}
- (void)homeButtonAction:(id)sender
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


- (void)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)displayProgressHudWithMessage:(NSString *)message

{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD displayWithMessage:message];
    });
}

- (void)hideProgressHud
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD hide];
    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    self.backButton   = nil;
    self.homeButton  = nil;
    self.titleLable       = nil;
    self.subTitleLabel = nil;
    
    [super viewDidUnload];
}

@end
