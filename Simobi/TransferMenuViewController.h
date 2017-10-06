//
//  TransferMenuViewController.h
//  Simobi
//
//  Created by Ravi on 10/15/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TransferMenuViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *selfbankLBL;
@property (weak, nonatomic) IBOutlet UILabel *otherBankLBL;
@property (weak, nonatomic) IBOutlet UILabel *uangkuLBL;
- (IBAction)bankSinarmasButtonAction:(id)sender;
- (IBAction)otherBankBUttonAction:(id)sender;

@end
