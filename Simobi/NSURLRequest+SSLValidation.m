//
//  NSURLRequest+SSLValidation.m
//  Simobi
//
//  Created by Ravi on 10/21/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "NSURLRequest+SSLValidation.h"

@implementation NSURLRequest (SSLValidation)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end
