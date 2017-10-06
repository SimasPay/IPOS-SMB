//
//  SimobiSharedManager.h
//  Simobi
//
//  Created by Ravi on 10/9/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimobiManager : NSObject
@property (nonatomic,strong) NSString *public_KEY;
@property (nonatomic,strong) NSString *sourceMDN;
@property (nonatomic,strong) NSString *sourcePIN;
@property (nonatomic,strong) NSDictionary *publicKeyDict;
@property (nonatomic,strong) NSString *language;
@property (nonatomic,strong) NSMutableDictionary *responseData;
@property (nonatomic,strong) NSString *pIN;
@property (nonatomic,assign) BOOL isCCPayment;

+ (id)shareInstance;

- (NSDictionary *)textDataForLanguage;

@end
