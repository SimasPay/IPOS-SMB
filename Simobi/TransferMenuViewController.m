//
//  TransferMenuViewController.m
//  Simobi
//
//  Created by Ravi on 10/15/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "TransferMenuViewController.h"
#import "TransferDetailsViewController.h"
#import "OtherBankViewController.h"

@interface TransferMenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sinarmasBankTransferBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBankBtn;
@property (weak, nonatomic) IBOutlet UIButton *uangkuBtn;

@end

@implementation TransferMenuViewController

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
    [self title:@"Transfer"];
    
    if (IS_IPHONE_5) {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 150;
        self.bgView.frame = bgviewFrame;
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 100;
        self.bgView.frame = bgviewFrame;
    }
    else{
        CGRect bgviewFrame = self.bgView.frame;
        bgviewFrame.origin.y = 120;
        self.bgView.frame = bgviewFrame;

    }
}


- (void)viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:animated];
    
    [self showHomeButton];
    [self showBackButton];
    
    NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
    self.selfbankLBL.text = @"Bank Sinarmas";
    self.otherBankLBL.text = [textDict objectForKey:OTHER_BANK];
    self.uangkuLBL.text = [textDict objectForKey:TRANSFER_UANGKU];
    
    [self title:[textDict objectForKey:TRANSFER]];
    
    self.uangkuBtn.layer.cornerRadius = 10;
    self.uangkuBtn.clipsToBounds = YES;
    self.sinarmasBankTransferBtn.layer.cornerRadius = 10;
    self.sinarmasBankTransferBtn.clipsToBounds = YES;
    self.otherBankBtn.layer.cornerRadius = 10;
    self.otherBankBtn.clipsToBounds = YES;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bankSinarmasButtonAction:(UIButton *)sender
{
    TransferDetailsViewController *detailsVC = [[TransferDetailsViewController alloc] initWithTranferType:TRANSFER_TYPE_SELFBANK];
    detailsVC.bankName = @"Bank Sinarmas";
    [[[SimobiManager shareInstance] responseData] removeAllObjects];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (IBAction)uangkuButtonAction:(UIButton *)sender
{
    TransferDetailsViewController *detailsVC = [[TransferDetailsViewController alloc] initWithTranferType:TRANSFER_TYPE_UANGKU];
    detailsVC.bankName = @"Uangku";
    [[[SimobiManager shareInstance] responseData] removeAllObjects];
    [self.navigationController pushViewController:detailsVC animated:YES];
}


- (IBAction)otherBankBUttonAction:(id)sender
{
    OtherBankViewController *bankVC = [[OtherBankViewController alloc] initWithNibName:@"OtherBankViewController" bundle:nil];
    [self.navigationController pushViewController:bankVC animated:YES];
}
@end
