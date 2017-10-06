//
//  LanguageViewController.m
//  Simobi
//
//  Created by Ravi on 11/6/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "LanguageViewController.h"

@interface LanguageViewController ()

@end

@implementation LanguageViewController

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
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];

    [self showBackButton];
    
    [self title:[textDict objectForKey:LANGUAGE]];
}


- (void)tapped

{
    // Tapped
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *lang = [[SimobiManager shareInstance] language];
    if ([lang isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
        
        [self.englishBtn setOn:YES];
    
    } else {
    
        [self.bahasaBtn setOn:YES];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)englishLanguageButtonAction:(id)sender
{
    
    
    [self.bahasaBtn setOn:!self.englishBtn.on animated:YES];
    [[SimobiManager shareInstance] setLanguage:SIMOBI_LANGUAGE_BAHASA];
    NSUserDefaults *defaultLanguage = [NSUserDefaults standardUserDefaults];
    [defaultLanguage setObject: SIMOBI_LANGUAGE_ENGLISH forKey:SIMOBI_LANGUAGE_STATUS];
    [defaultLanguage synchronize];
}

- (IBAction)bahasaLanguageButtonAction:(id)sender
{
    

    [self.englishBtn setOn:!self.bahasaBtn.on animated:YES];
    [[SimobiManager shareInstance] setLanguage:SIMOBI_LANGUAGE_ENGLISH];
    NSUserDefaults *defaultLanguage = [NSUserDefaults standardUserDefaults];
    [defaultLanguage setObject:SIMOBI_LANGUAGE_BAHASA forKey:SIMOBI_LANGUAGE_STATUS];
    [defaultLanguage synchronize];

}

- (void)backButtonAction:(id)sender
{
   // NSString *lang = [[SimobiManager shareInstance] language];
    if ([self.englishBtn isOn]) {
        [[SimobiManager shareInstance] setLanguage:SIMOBI_LANGUAGE_ENGLISH];
        [self.bahasaBtn setOn:FALSE];
    }
    else{
        [[SimobiManager shareInstance] setLanguage:SIMOBI_LANGUAGE_BAHASA];
        [self.englishBtn setOn:FALSE];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
@end
