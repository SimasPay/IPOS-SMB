//
//  LanguageViewController.h
//  Simobi
//
//  Created by Ravi on 11/6/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LanguageViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UISwitch *englishBtn;
@property (weak, nonatomic) IBOutlet UISwitch *bahasaBtn;

- (IBAction)englishLanguageButtonAction:(id)sender;
- (IBAction)bahasaLanguageButtonAction:(id)sender;
@end
