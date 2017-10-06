//
//  TermsViewController.m
//  Simobi
//
//  Created by Dimo on 7/19/16.
//  Copyright © 2016 Mfino. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButton];
    //[self showHomeButton];
    [self title:@"Terms & Condition"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //    self.backButton.frame.origin.y +
    float padding = 18;
    UIButton *btnBack = (UIButton *)[self.view viewWithTag:100];
    float y = btnBack.frame.origin.y + btnBack.frame.size.height;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float width = screenSize.width - padding * 2;
    float height = screenSize.height - padding * 2 - y;
    UIWebView *viewWebView = [[UIWebView alloc]initWithFrame:CGRectMake(padding, y + padding, width, height)];
    viewWebView.layer.borderWidth = 1;
    viewWebView.layer.borderColor = [UIColor whiteColor].CGColor;
    viewWebView.layer.cornerRadius = 10;
    viewWebView.clipsToBounds = true;
    viewWebView.backgroundColor = [UIColor blackColor];
    NSString *urlString = @"http://banksinarmas.com/tabunganonline/simobi";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [viewWebView loadRequest:urlRequest];
    [self.view addSubview:viewWebView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
