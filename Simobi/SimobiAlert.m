//
//  SimobiAlert.m
//  Simobi
//
//  Created by Ravi on 10/7/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "SimobiAlert.h"

@implementation SimobiAlert

+(void)showAlertWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Simobi" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    });
    
    
}
@end
