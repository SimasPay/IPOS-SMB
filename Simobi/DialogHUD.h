//
//  DialogView.h
//  Simobi
//
//  Created by Ravi on 11/8/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *To catch Service for Manipulating confirm service call
 */
typedef enum {
    Service_TRANSFER = 0,
    Service_PAYMENT,
    Service_PURCHASE,
    Service_BALANCE,
    Service_TRANSACTION,
    Service_ACTIVATION,
    Service_CHANGEPIN,
    Service_SELFBANK,
    Service_OTHERBANK,
    Service_REACTIVATION,
    Service_RESETPIN,
    Service_LOGIN,
    SERVICE_FLASHIZ,
    Service_UANGKU
}Service;

@interface DialogHUD : NSObject<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (assign)Service service;


+(void)displayWithMessage:(NSString *)message withservice:(Service)type;
+(void)displayWithMessage:(NSString *)message withservice:(Service)service withData:(NSDictionary *)data;
+(void)displayWithParameters:(NSDictionary *)params withservice:(Service)service;

+(void)hide;
@end
