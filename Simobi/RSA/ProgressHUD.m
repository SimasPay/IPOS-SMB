//
//  ProgressHUD.m
//  Simobi
//
//  Created by Ravi on 10/7/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "ProgressHUD.h"

#import <QuartzCore/QuartzCore.h>

@interface ProgressView : UIView

@property (copy) NSString *message;

@end

@implementation ProgressView

-(id)initWithMessage:(NSString *)description frame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    
    if ( self )
    {
        self.message = description;
        self.backgroundColor = [ UIColor colorWithWhite:0.0f alpha:0.7f ];
    }
    
    return self;
}

-(void)layoutSubviews
{
    // remove all subviews
    [ self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) ];
    
    // create a square
    CGFloat width = 100.0f;
    CGFloat height = width;
    
    // create the actual HUD
    UIView *hudView = [ [ UIView alloc ] initWithFrame:CGRectMake( (self.frame.size.width - width) / 2,
                                                                  (self.frame.size.height - height) / 2,
                                                                  width,
                                                                  height)];
    // make sure to round off the corners
    hudView.layer.cornerRadius = 10.0f;
    
    hudView.backgroundColor = [ UIColor darkGrayColor ];
    
    // create a spinner
    UIActivityIndicatorView *spinner = [ [ UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    
    [ spinner startAnimating ];
    
    CGFloat spinnerWidth = 37.0f;
    CGFloat spinnerHeight = spinnerWidth;
    
    // resize the spinner
    spinner.frame = CGRectMake((hudView.frame.size.width - spinnerWidth) / 2,
                               (hudView.frame.size.height - spinnerHeight) / 2,
                               spinnerWidth,
                               spinnerHeight);
    
    // add the spinner to the hud
    [ hudView addSubview:spinner ];
    
    // add the hud to us
    [ self addSubview:hudView ];
    
    if ( self.message != nil)
    {
        CGFloat xPadding = 5.0f;
        
        CGFloat yPadding =  5.0f;
        
        CGFloat y = hudView.frame.origin.y + hudView.frame.size.height + yPadding;
        
        CGFloat x = xPadding;
        
        // the width of the label should allow for 5 px of space from the edge
        CGFloat labelWidth = self.frame.size.width - ( xPadding * 2);
        
        CGFloat labelHeight = 40.0f;
        
        // create the label
        UILabel *label = [ [ UILabel alloc ] initWithFrame:CGRectMake(x, y, labelWidth, labelHeight) ];
        
        // get rid of the white background
        label.backgroundColor = [ UIColor clearColor];
        
        // set the text and change the text color to white
        label.text = self.message;
        label.textColor = [ UIColor whiteColor];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [ UIFont systemFontOfSize:32.0f];
        
        [ self addSubview:label];
    }
    
    
}


@end

static ProgressView *_progressView = nil;

@implementation ProgressHUD

+(void)displayWithMessage:(NSString *)message
{
    UIWindow *window = [ UIApplication sharedApplication ].keyWindow;
    
    // display the HUD over the entire window
    [ ProgressHUD displayWithMessage:message view:window ];
}


+(void)displayWithMessage:(NSString *)message view:(UIView *)view
{
    // make sure that we run on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ( _progressView != nil )
        {
            /* we have a situation that that we have a current _progressView that hasn't been destroyed..
             so we need to destroy the current _progressView and create a new one. */
           // //CONDITIONLOG(DEBUG_MODE,@"**** Handling unbalanced display/hide calls ****");
            
            // remove ourselves from our superview
            [ _progressView removeFromSuperview ];
            
            // set our static instance of ProgressView to nil
            _progressView = nil;
        }
        
        // create a new _ProgressView
        _progressView = [ [ ProgressView alloc ] initWithMessage:message frame:view.bounds ];
        ////CONDITIONLOG(DEBUG_MODE,@"Bounds::%@",NSStringFromCGRect(view.bounds));
        
        // make the view transparent
        _progressView.alpha = 0.0f;
        
        // add _progressView to the specified view and make sure that it is on top of all other views
        [ view addSubview:_progressView ];
        [ view bringSubviewToFront:_progressView ];
        
        [ UIView animateWithDuration:0.25f animations:^{
            // fade in the view
            _progressView.alpha = 1.0;
        }];
        
        // turn off touch events for the view
        view.userInteractionEnabled = NO;
    });
}


+(void)hide

{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ( _progressView != nil )
        {
            // allow gestures on the superview
            [ _progressView superview ].userInteractionEnabled = YES;
            
            [ UIView animateWithDuration:0.25f animations:^{
                // fade out the _progressView
                _progressView.alpha = 0.0f;
                
            }completion:^(BOOL completed) {
                // after fading out the view, remove it fro the superview
                [ _progressView removeFromSuperview ];
                // set to nil
                _progressView = nil;
            }];
        }
    });
}


@end
