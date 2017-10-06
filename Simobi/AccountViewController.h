//
//  AccountViewController.h
//  Simobi
//
//  Created by Ravi on 10/21/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AccountViewController : BaseViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *balanceLBL;
@property (weak, nonatomic) IBOutlet UILabel *languageLBL;
@property (weak, nonatomic) IBOutlet UILabel *transactionLBL;
@property (weak, nonatomic) IBOutlet UILabel *changePINLBL;
@property (weak, nonatomic) IBOutlet UIView *bgView;

- (IBAction)balanceButtonAction:(id)sender;
- (IBAction)transactionButtonAction:(id)sender;
- (IBAction)changemPinButtonAction:(id)sender;
- (IBAction)languageButtonAction:(id)sender;

@end
