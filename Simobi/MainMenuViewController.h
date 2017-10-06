//
//  MainMenuViewController.h
//  Simobi
//
//  Created by Ravi on 10/8/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DialogHUD.h"
#define kUserDefaultPayInAPP                @"kUserDefaultPayInAPP"
#define kUserDefaultPayInAPPBackURL         @"kUserDefaultPayInAPPBackURL"

@interface MainMenuViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *purchaseLBL;
@property (weak, nonatomic) IBOutlet UILabel *paymentLBL;
@property (weak, nonatomic) IBOutlet UILabel *accountLBL;
@property (weak, nonatomic) IBOutlet UILabel *transferLBL;
@property (weak, nonatomic) IBOutlet UILabel *payByQRLBL;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

- (IBAction)purchaseButtonAction:(id)sender;
- (IBAction)transferButtonAction:(id)sender;
- (IBAction)paymentButtonAction:(id)sender;
- (IBAction)accountButtonAction:(id)sender;

- (IBAction)logOutButtonAction:(id)sender;
- (IBAction)buttonActionMigration:(id)sender;
@end
