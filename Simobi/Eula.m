//
//  Eula.m
//  Simobi
//
//  Created by Ravi on 12/24/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "Eula.h"
#import "SimobiConstants.h"
#import <QuartzCore/QuartzCore.h>
#import "SimobiConstants.h"
#import "SimobiManager.h"
@implementation Eula

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView*backGroundView = [[UIImageView alloc] initWithFrame:frame];
        [backGroundView setImage:[UIImage imageNamed:@"Background.png"]];
        
        [self insertSubview:backGroundView atIndex:0];
        
        
        UILabel *_titleLable                    = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 84, 320, 30.0)];//(120.0, 25.0, 200, 30.0)
        _titleLable.text = @"Terms and Conditions";
        _titleLable.font               = [UIFont boldSystemFontOfSize:17.0];
        _titleLable.textColor          = [UIColor whiteColor];
        _titleLable.textAlignment      = NSTextAlignmentCenter;
        _titleLable.backgroundColor    = [UIColor clearColor];
        [self addSubview:_titleLable];
        
        UIWebView *webView = [[UIWebView alloc] init];
        
        CGRect _webViewFrame = CGRectMake(20.0f, 140.0f,280.0f, 300.0f);
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            _webViewFrame.origin.y = 120.0f;
        } else {
        
            _webViewFrame.origin.y = 50.0f;

        }
       webView.frame = _webViewFrame;
        webView.backgroundColor = [UIColor clearColor];
        webView.layer.borderColor = [UIColor grayColor].CGColor;
        webView.layer.borderWidth = 3.0f;
        webView.layer.cornerRadius = 12.0f;
        webView.opaque = NO;
        [webView.layer setMasksToBounds:YES];
        NSString *embedHTML = [NSString stringWithFormat:@"<html><head></head><body style=\"margin:0 auto;text-align:left;padding:10px;background-color: transparent; color:white\">%@</body></html>",EULAMESSAGE] ;
        [webView loadHTMLString:embedHTML baseURL:nil];
                       [self addSubview:webView];

        
        //create confirm button
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ButtonImage(confirmBtn, @"button_empty.png");
        [confirmBtn setTitle:@"Agree" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:19.0f]];
        [confirmBtn addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - DIALOG_BUTTON_SIZE.width - 55.0f, CGRectGetHeight(webView.frame) +webView.frame.origin.y+ 20.0f, DIALOG_BUTTON_SIZE.width, DIALOG_BUTTON_SIZE.height);
    
        
        
        //CONDITIONLOG(DEBUG_MODE,@"ConfirmFrame:%@",NSStringFromCGRect(confirmBtn.frame));
        
        
        //create cancel button
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ButtonImage(cancelBtn, @"button_empty.png");
        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:19.0f]];
        [cancelBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.frame = CGRectMake(CGRectGetMinX(self.frame) + 52.0f, CGRectGetHeight(webView.frame) +webView.frame.origin.y+20.0f, DIALOG_BUTTON_SIZE.width, DIALOG_BUTTON_SIZE.height);
        if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
            [confirmBtn setTitle:@"Agree" forState:UIControlStateNormal];
            [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        } else {
            [confirmBtn setTitle:@"Setuju" forState:UIControlStateNormal];
            [cancelBtn setTitle:@"Batal" forState:UIControlStateNormal];
        }
        [self addSubview:confirmBtn];
        [self addSubview:cancelBtn];
    }
    return self;
}



- (void)confirmButtonAction:(id)sender
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(confirmAction)]) {
        [self.delegate confirmAction];
    }
}

- (void)cancelButtonAction:(id)sender
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(cancelAction)]) {
        [self.delegate cancelAction];
    }

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
