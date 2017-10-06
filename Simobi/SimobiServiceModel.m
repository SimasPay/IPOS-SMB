//
//  SimobiServiceModel.m
//  Simobi
//
//  Created by Ravi on 10/14/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "SimobiServiceModel.h"
#import "SimobiWrapper.h"
#import "XMLReader.h"
//#import "SimobiModel.h"
#import "SimobiConstants.h"


@implementation SimobiServiceModel

+(void)connectURL:(NSString *)urlString successBlock:(void (^)(NSDictionary *response))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock

{

    CONDITIONLOG(DEBUG_MODE,@"URLSTRING:%@",urlString);
    NetworkConnectionSuccessful userSuccessBlock = ^(NSURLResponse *response, NSData *data)
    {
        dispatch_queue_t processing_queue = dispatch_queue_create("com.mfino.Simobi.processing", NULL);
        
        dispatch_async(processing_queue, ^{
            NSError *error = nil;

            NSDictionary *response = (NSDictionary *)[XMLReader dictionaryForXMLData:data error:&error];
            
            wrapperSuccessBlock (response);
        });
    };
    
    NetworkConnectionFailure userFailureBlock = ^(NSURLResponse *response, NSError *error)
    {
        wrapperFailedBlock (error);
    };
    
    
    
    [SimobiWrapper connectWithURLString:urlString successBlock:userSuccessBlock failureBlock:userFailureBlock];
}


+(void)connectJSONURL:(NSString *)urlString successBlock:(void (^)(NSData *responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock
{
    {
        
        
        NetworkConnectionSuccessful userSuccessBlock = ^(NSURLResponse *response, NSData *data)
        {
            dispatch_queue_t processing_queue = dispatch_queue_create("com.mfino.Simobi.processing", NULL);
            
            dispatch_async(processing_queue, ^{
                wrapperSuccessBlock (data);
            });
        };
        
        NetworkConnectionFailure userFailureBlock = ^(NSURLResponse *response, NSError *error)
        {
            wrapperFailedBlock (error);
        };
        
        
        
        [SimobiWrapper connectWithURLString:urlString successBlock:userSuccessBlock failureBlock:userFailureBlock];
    }

}

@end
