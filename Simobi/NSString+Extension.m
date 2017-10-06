//
//  NSString+Encryption.m
//  Simobi
//
//  Created by Ravi on 10/14/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Extension)

- (NSString*)MD5
{
	// Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
 	// Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
	// Create 16 bytes MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
	// Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}


- (NSString *)constructUrlStringWithParams:(NSDictionary *)parameters
{
    
    NSMutableString *sampleURL = [NSMutableString stringWithString:self];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [sampleURL appendFormat:@"%@=%@",key,obj];
        [sampleURL appendString:@"&"];
        
    }];
    
    [sampleURL deleteCharactersInRange:NSMakeRange(sampleURL.length - 1, 1)];
    
    NSString *normalisedStr = [NSString stringWithString:sampleURL];
    return normalisedStr;
    
}

@end
