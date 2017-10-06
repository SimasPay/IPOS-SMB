//
//  UITextField+Extension.m
//  Simobi
//
//  Created by Ravi on 10/8/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

- (BOOL)isValid
{

    return (self.text.length > 0) ? YES : NO;
}


@end
