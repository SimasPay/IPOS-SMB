//
//  UangkuUtility.h
//  Uangku
//
//  Created by Rajesh Pothuraju on 02/03/15.
//  Copyright (c) 2015 RAND Software Services (india) Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SimobiUtility : NSObject



+(NSString *) getAppDataPlistPath;

+(id) getDataFromPlistForKey:(NSString *) toGetKey;

+(void) saveDataToPlist :(id) toSaveData key:(NSString *) toSaveKey;
+ (BOOL)canOpenAppsWithUrlScheme:(NSString *)urlScheme;

@end
