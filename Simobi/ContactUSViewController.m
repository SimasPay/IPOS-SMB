//
//  ContactUSViewController.m
//  Simobi
//
//  Created by Ravi on 11/29/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "ContactUSViewController.h"

@interface ContactUSViewController ()

@end

@implementation ContactUSViewController

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
    NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
    [self title:[textDict objectForKey:CONTACTUS]];
    self.bgView.layer.cornerRadius = 10.0f;
    self.bgView.layer.borderWidth = 3.0f;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    if (IS_IPHONE_5) {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y += 100;
        self.bgView.frame = bgviewFrame;
    }else{
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y += 80;
        self.bgView.frame = bgviewFrame;
        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
