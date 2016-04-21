//
//  SavedGifsViewController+AllowEditing.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/19/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "SavedGifsViewController+AllowEditing.h"

@implementation SavedGifsViewController(AllowEditing)

+(NSString*)createPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *outputURL = [documentsDirectory stringByAppendingPathComponent:@"output"] ;
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    outputURL = [outputURL stringByAppendingPathComponent:@"output.mov"];
    
    // Remove Existing File
    [manager removeItemAtPath:outputURL error:nil];
    
    return outputURL;
}

+(AVAssetExportSession*)configureExportSession:(AVAssetExportSession*)session
                                     outputURL:(NSString*)outputURL
                             startMilliseconds:(int)start
                               endMilliseconds:(int)end {
    
    session.outputURL = [NSURL fileURLWithPath:outputURL];
    session.outputFileType = AVFileTypeQuickTimeMovie;
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(start, 1000), CMTimeMake(end - start, 1000));
    session.timeRange = timeRange;
    
    return session;
}


@end
