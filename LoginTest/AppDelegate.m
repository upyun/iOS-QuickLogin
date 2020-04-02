//
//  AppDelegate.m
//  LoginTest
//
//  Created by lingang on 2020/2/17.
//  Copyright © 2020 upyun. All rights reserved.
//

#import "AppDelegate.h"
#import <QuickLogin/QLHelper.h>
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UPAuthConfig *config = [[UPAuthConfig alloc] init];
    config.appKey = @"379ee76164528cbc7af1c152";
    config.timeout = 5000;
    config.authBlock = ^(NSDictionary *result) {
        NSLog(@"初始化结果 result:%@", result);
    };
    [QLHelper setupWithConfig:config];



    






    return YES;
}


@end
