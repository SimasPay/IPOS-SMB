//
//  SimobiWrapper.m
//  Simobi
//
//  Created by Ravi on 10/14/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "SimobiWrapper.h"
#import "NSURLRequest+SSLValidation.h"

NSString *const kNetworkUtilitiesErrorDomain = @"kSimobiErrorDomain";
NSInteger const kNetworkUtilitiesHttpErrorCode = 5;


@implementation SimobiWrapper

@synthesize serviceUrlConnection;

+(void)connectWithURLString:(NSString *)urlStr successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock

{
        dispatch_queue_t default_queuet = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(default_queuet, ^{

    NSURL *serviceUrl = [NSURL URLWithString:urlStr];
        [NSURLRequest allowsAnyHTTPSCertificateForHost:[serviceUrl host]];
    NSURLRequest *serviceRequest = [NSURLRequest requestWithURL:serviceUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:90.0];

        [NSURLConnection sendAsynchronousRequest:serviceRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            
            failureBlock (response,connectionError);
        
        } else {
        
            successBlock (response,data);
        }
    }];
        
    });
    
    
    /*
    
    return;
    
        NSURL *serviceUrl = [ NSURL URLWithString:urlStr ];

        NSURLRequest *request = [ NSURLRequest requestWithURL:serviceUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0 ];
   
    dispatch_queue_t default_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_block_t download_block = ^{
            
            // set up the error object
            NSError *error = nil;
            NSURLResponse *response = nil;
            
            // connect using a synchronous request
            NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
            
            if ( error == nil )
            {
                // check the response code..
                if ( [ response isKindOfClass:[ NSHTTPURLResponse class] ] )
                {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    if ( [ httpResponse statusCode ] != 200 )
                    {
                        long statusCode = [ httpResponse statusCode ];
                        
                        NSString *errorString = [ NSString stringWithFormat:@"Error status code is: %li", statusCode ];
                        
                        NSDictionary *userInfoDict = [ NSDictionary dictionaryWithObject:errorString
                                                                                 forKey:NSLocalizedDescriptionKey ];
                        
                        // create an error..
                        NSError *httpError = [ [ NSError alloc ] initWithDomain:kNetworkUtilitiesErrorDomain
                                                                           code:kNetworkUtilitiesHttpErrorCode userInfo:userInfoDict];
                        
                        // if we get here, then we have an error so run the error block
                        failureBlock(response, httpError);
                    }
                    else
                    {
                        // we are good.. so continue and run the completion block
                        successBlock(response,data);
                    }
                }
                else
                {
                    if ( response == nil)
                    {
                        
                    }
                    // we are good.. so continue and run the completion block
                    successBlock(response,data);
                }
                
            }
            else
            {
                
                // if we get here, then we have an error so run the error block
                failureBlock(response, error);
                
            }
        };
        
        // perform the download on the download queue
        dispatch_async(default_queue, download_block);
     
     */
    
}


@end
