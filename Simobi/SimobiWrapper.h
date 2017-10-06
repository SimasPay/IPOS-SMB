//
//  SimobiWrapper.h
//  Simobi
//
//  Created by Ravi on 10/14/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <Foundation/Foundation.h>

// Block that defines a successful HTTPS download
typedef void (^NetworkConnectionSuccessful)(NSURLResponse *response,NSData *data);

// Block that defines an unsucessful HTTPS download
typedef void (^NetworkConnectionFailure)(NSURLResponse *response,NSError *error);


@interface SimobiWrapper : NSObject

+(void)connectWithURLString:(NSString *)urlStr successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock;

@property (nonatomic,retain)NSURLConnection *serviceUrlConnection;

@end
