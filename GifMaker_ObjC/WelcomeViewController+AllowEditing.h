//
//  WelcomeViewController+AllowEditing.h
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/19/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "WelcomeViewController.h"
#import <Foundation/Foundation.h>
@import AVFoundation;

@interface WelcomeViewController(AllowEditing)

+(NSString*)createPath;
+(AVAssetExportSession*)configureExportSession:(AVAssetExportSession*)session
                                     outputURL:(NSString*)outputURL
                             startMilliseconds:(int)start
                               endMilliseconds:(int)end;


@end
