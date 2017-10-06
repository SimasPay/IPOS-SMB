//
//  NSString+Encryption.h
//  Simobi
//
//  Created by Ravi on 10/14/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString*)MD5;
- (NSString *)constructUrlStringWithParams:(NSDictionary *)parameters;

@end
