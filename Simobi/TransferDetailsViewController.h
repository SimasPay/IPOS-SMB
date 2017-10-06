//
//  TransferDetailsViewController.h
//  Simobi
//
//  Created by Ravi on 10/15/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MainMenuViewController.h"

typedef enum {
    
    TRANSFER_TYPE_PURCHASE = 0,
    TRANSFER_TYPE_PAYMENT,
    TRANSFER_TYPE_SELFBANK,
    TRANSFER_TYPE_OTHERBANK,
    TRANSFER_TYPE_UANGKU

}TRANSFER_TYPE;

@interface TransferDetailsViewController : BaseViewController <UITextFieldDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>

@property (copy)   NSString *bankName;
@property (retain) UITextField *accountNumberField;
@property (retain) UITextField *amountField;
@property (retain) UITextField *mpinField;
@property (assign) TRANSFER_TYPE transferType;
@property (retain) UILabel *firstLabel;
@property (retain) UILabel *secondLabel;
@property (retain) UILabel *thirdLabel;
@property (retain) NSDictionary *categoryDict;

- (IBAction)submitButtonAction:(id)sender;
- (instancetype)initWithTranferType:(TRANSFER_TYPE) transfer;

@end
