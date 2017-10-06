//
//  SimobiGrayView.m
//  Simobi
//
//  Created by Ravi on 10/14/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "SimobiGrayView.h"

@implementation SimobiGrayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.opaque = NO;
        self.alpha = 0.1;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"TOP BAR CLEAN.png"]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
