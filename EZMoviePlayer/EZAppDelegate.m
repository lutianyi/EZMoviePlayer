//
//  AppDelegate.m
//  EZMoviePlayer
//
//  Created by 卢天翊 on 15/1/13.
//  Copyright (c) 2015年 Ezer. All rights reserved.
//

#import "EZAppDelegate.h"
#import "HTTPServer.h"
#import "NSString+Directory.h"

@interface EZAppDelegate ()

@property (nonatomic, strong) HTTPServer * httpServer;
@property (nonatomic) BOOL connecting;

@end

@implementation EZAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.connecting = true;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /**
     *  当App进入到后台时, HTTPServer的链接会被断开, 所以在每次进入后台时将HTTPServer断开.
     */
    self.connecting = false;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /**
     *  再次返回前台时将其链接打开.
     *  也可以使用后台模式保持链接.
     */
    self.connecting = true;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (HTTPServer *)httpServer
{
    if (!_httpServer) {
        
        _httpServer      = [HTTPServer new];
        _httpServer.type = @"_http._tcp";
        _httpServer.port = 10001;

        _httpServer.documentRoot = [NSString stringWithDirectory:(EZDirectoryTemp)];
    }
    return _httpServer;
}

- (void)setConnecting:(BOOL)connecting
{
    /**
     *  可以声明一个NSError *error, 查看错误信息;
     */
    connecting ? [self.httpServer start:nil] : [self.httpServer stop];
    
    _connecting = connecting;
}


@end
