//
//  OtherBankViewController.h
//  Simobi
//
//  Created by Ravi on 10/15/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface OtherBankViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *bankTableView;
@end
