//
//  SimobiServiceModel.h
//  Simobi
//
//  Created by Ravi on 10/14/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ReturnResponseType_JSON = 0,
    ReturnResponseType_XML
}ReturnResponseType;

@interface SimobiServiceModel : NSObject

+(void)connectURL:(NSString *)urlString successBlock:(void (^)(NSDictionary *response))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock;

+(void)connectJSONURL:(NSString *)urlString successBlock:(void (^)(NSData *responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock;

@end
