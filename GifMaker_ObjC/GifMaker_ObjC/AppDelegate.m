//
//  AppDelegate.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/1/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "AppDelegate.h"

#define GIFURL [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"savedGifs"]

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.gifs = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:GIFURL]];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [NSKeyedArchiver archiveRootObject:self.gifs toFile:GIFURL];
}

@end
