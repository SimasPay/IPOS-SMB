//
//  UangkuUtility.m
//  Uangku
//
//  Created by Rajesh Pothuraju on 02/03/15.
//  Copyright (c) 2015 RAND Software Services (india) Pvt Ltd. All rights reserved.
//


#import "SimobiUtility.h"

@implementation SimobiUtility


+(NSString *) getAppDataPlistPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"SimobiApplicationData.plist"];
    
    return path;
}

+(id) getDataFromPlistForKey:(NSString *) toGetKey {
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: [self getAppDataPlistPath]];
    id dataForKey = [savedStock objectForKey:toGetKey];
    return dataForKey;
    
}

+(void) saveDataToPlist :(id) toSaveData key:(NSString *) toSaveKey {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"SimobiApplicationData.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"SimobiApplicationData.plist"] ];
    }
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path])
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        if (toSaveData) {
            [data setObject:toSaveData forKey:toSaveKey];
        }
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
        if (toSaveData) {
            [data setObject:toSaveData forKey:toSaveKey];
        }
        
    }
    [data writeToFile: path atomically:YES];
}

+ (BOOL)canOpenAppsWithUrlScheme:(NSString *)urlScheme {
    NSURL *myURL = [NSURL URLWithString:urlScheme];
    if ([[UIApplication sharedApplication] canOpenURL:myURL]) {
        return YES;
    } else {
        return NO;
    }
}


@end
