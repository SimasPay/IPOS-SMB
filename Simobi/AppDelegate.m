//
//  AppDelegate.m
//  Simobi
//
//  Created by Ravi on 10/7/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "AppDelegate.h"
#import "SimobiConstants.h"
#import "SimobiManager.h"
#import "SimobiServiceModel.h"
#import "ProgressHUD.h"
#import "SimobiAlert.h"
#import "IQKeyboardManager.h"
#import "MainMenuViewController.h"

@implementation AppDelegate

@synthesize publikKeyReceived;
@synthesize isNetAvailable,navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
   // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[SimobiManager shareInstance] setLanguage:SIMOBI_LANGUAGE_BAHASA];
    
    [self getPublikKey];
    
   // self.window.backgroundColor = [UIColor colorWithRed:56.0/255.0f green:55.0/255.0f blue:57.0/255.0f alpha:1.0];
    
    self.viewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navController;
    self.navigationController = navController;
    //[self.window makeKeyAndVisible];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = [UIWindow new];
    self.window.backgroundColor = [UIColor colorWithRed:56.0/255.0f green:55.0/255.0f blue:57.0/255.0f alpha:1.0];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    // Here it is
    self.window.frame = [UIScreen mainScreen].bounds;
    
    [self resetKeychain];
    
    [self setUpRechability];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:SIMOBI_LANGUAGE_STATUS];
    [[SimobiManager shareInstance] setLanguage:language];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *urlString = [url absoluteString].lowercaseString;
    
    CONDITIONLOG(DEBUG_MODE, @"URL : %@", urlString);
    if ([urlString rangeOfString:@"payinapp"].location != NSNotFound) {
        //payinapp
        NSArray *path = [urlString componentsSeparatedByString:@"payinapp/"];
        NSString *lastString = path[path.count - 1];
        
        NSArray *query = [lastString componentsSeparatedByString:@"&backurl="];
        NSString *invoiceId = query[0];
        NSString *backUrl = @"";
        if (query.count > 1) {
            backUrl = query[1];
        }
        CONDITIONLOG(DEBUG_MODE, @"invoice Id : %@", invoiceId);
        CONDITIONLOG(DEBUG_MODE, @"back url : %@", backUrl);
        
        [[NSUserDefaults standardUserDefaults] setObject:invoiceId forKey:kUserDefaultPayInAPP];
        [[NSUserDefaults standardUserDefaults] setObject:backUrl forKey:kUserDefaultPayInAPPBackURL];
        
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[MainMenuViewController class]]) {
                [self.navigationController popToViewController:vc animated:NO];
                break;
            }
        }
        UIViewController *vc = self.navigationController.childViewControllers.lastObject;
        [vc viewDidAppear:YES];
    }
    return YES;
}
-(void)deleteAllKeysForSecClass:(CFTypeRef)secClass {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:(__bridge id)secClass forKey:(__bridge id)kSecClass];
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef) dict);
    NSAssert(result == noErr || result == errSecItemNotFound, @"Error deleting keychain data (%d)", (int)result);
}

-(void)resetKeychain {
    
    [self deleteAllKeysForSecClass:kSecClassGenericPassword];
    [self deleteAllKeysForSecClass:kSecClassInternetPassword];
    [self deleteAllKeysForSecClass:kSecClassCertificate];
    [self deleteAllKeysForSecClass:kSecClassKey];
    [self deleteAllKeysForSecClass:kSecClassIdentity];
}


- (void)getPublikKey 
{
    if (self.isNetAvailable) {
        [SimobiServiceModel connectURL:SIMOBI_PUBLICKEY_ACCESS_URL successBlock:^(NSDictionary *response) {
            //
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD hide];
                self.publikKeyReceived = YES;
                NSString *modulus = OBJECTFORKEY(response, @"PublicKeyModulus");
                NSString *exponent = OBJECTFORKEY(response, @"PublicKeyExponent");
                CONDITIONLOG(DEBUG_MODE,@"Response:%@",response);
                [[SimobiManager shareInstance] setPublicKeyDict:[NSDictionary dictionaryWithObjectsAndKeys:modulus,@"modulus",exponent,@"exponent",nil]];
                
            });
            
        }
                          failureBlock:^(NSError *error) {
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [ProgressHUD hide];
                                  self.publikKeyReceived = NO;
                                  //[SimobiAlert showAlertWithMessage:error.localizedDescription];
                                  NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                                  [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
                                  
                              });
                              
                          }];
    }else
    {
        
    }
    
    
    
   /* Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.unreachableBlock = ^(Reachability *reach) {
        
        //[SimobiAlert showAlertWithMessage:@"NO Network connection.\nPlease try again later."];
        
        NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
        [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
        return;
    };
    reach.reachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [ProgressHUD displayWithMessage:nil];
        });
      
        
    };
    
    [reach startNotifier]; */


}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
        if (!self.publikKeyReceived) {
            [self getPublikKey];
        }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
        if (!self.publikKeyReceived) {
            [self getPublikKey];
        }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setUpRechability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [self.reachability currentReachabilityStatus];
    
    if          (remoteHostStatus == NotReachable)      {/*NSLog(@"------- no ---------");*/      self.isNetAvailable-=NO;   }
    else if     (remoteHostStatus == ReachableViaWiFi)  {/*NSLog(@"------- wifi----------");*/    self.isNetAvailable-=YES;  }
    else if     (remoteHostStatus == ReachableViaWWAN)  {/*NSLog(@"------- cell  ---------");*/   self.isNetAvailable-=YES;  }
    
}

- (void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [self.reachability currentReachabilityStatus];
    
    if          (remoteHostStatus == NotReachable)      {
        
        //NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
        [SimobiAlert showAlertWithMessage:@"The Internet connection appears to be offline."];
        
        self.isNetAvailable-=NO;   }
    else if     (remoteHostStatus == ReachableViaWiFi)  {/*NSLog(@"----------- wifi ------");*/    self.isNetAvailable-=YES;  }
    else if     (remoteHostStatus == ReachableViaWWAN)  {/*NSLog(@"----------- cell ------");*/   self.isNetAvailable-=YES;  }
    
    
}


@end
