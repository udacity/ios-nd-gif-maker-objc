//
//  RecordVideoViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/1/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "RecordVideoViewController.h"

#import "RecordVideoViewController.h"

#import "DisplayGifViewController.h"
#import "GifMaker_ObjC-Swift.h"
@import AVFoundation;
@import MobileCoreServices;

@interface RecordVideoViewController()

@property (nonatomic) NSURL *videoURL;
@property (nonatomic) NSURL *gifURL;

@end

static int const kFrameCount = 16;
static const float kDelayTime = 0.2;
static const int kLoopCount = 0; // 0 means loop forever

@implementation RecordVideoViewController

# pragma mark - Video Recording Methods
- (IBAction)launchCamera:(id)sender {
    [self startCameraFromViewController:self];
}

- (BOOL)startCameraFromViewController:(UIViewController*)viewController {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        return false;
    } else {
        
        UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraController.mediaTypes = @[(NSString *) kUTTypeMovie];
        cameraController.allowsEditing = true;
        cameraController.delegate = self;
        
        [self presentViewController:cameraController animated:TRUE completion:nil];
        return true;
    }
}

-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(id)info {
    NSString *title = @"Success";
    NSString *message = @"Video was saved";
    
    if (error != nil) {
        title = @"Error";
        message = @"Video failed to save";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:TRUE completion:nil];
}

# pragma mark - UIImagePickerController Delegate methods

//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    
//    CFStringRef mediaType = (__bridge CFStringRef)([info objectForKey:UIImagePickerControllerMediaType]);
//    [self dismissViewControllerAnimated:TRUE completion:nil];
//    
//    // Handle a movie capture
//    if (mediaType == kUTTypeMovie) {
//        
//        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
//        self.videoURL = url;
//        NSString *path = url.path;
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
//            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video: didFinishSavingWithError: contextInfo:), nil);
//        }
//     
//        [self convertVideoToGif];
//    }
//}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

# pragma mark - Gif Conversion and Display methods

-(void)convertVideoToGif {
    Regift *regift = [[Regift alloc] initWithSourceFileURL:self.videoURL frameCount:kFrameCount delayTime:kDelayTime loopCount:kLoopCount];
    self.gifURL = [regift createGif];
    [self displayGif];
}

-(void)displayGif {
    
    DisplayGifViewController *displayGifVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DisplayGifViewController"];
    displayGifVC.gifURL = self.gifURL;
    [self presentViewController:displayGifVC animated:true completion:nil];

}

// Allows Editing
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    CFStringRef mediaType = (__bridge CFStringRef)([info objectForKey:UIImagePickerControllerMediaType]);
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
    // Handle a movie capture
    if (mediaType == kUTTypeMovie) {
        
        NSURL *rawVideoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        // Get start and end points from trimmed video
        NSNumber *start = [info objectForKey:@"_UIImagePickerControllerVideoEditingStart"];
        NSNumber *end = [info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"];

        // If start and end are nil then clipping was not used.
        if (start != nil) {
            int startMilliseconds = ([start doubleValue] * 1000);
            int endMilliseconds = ([end doubleValue] * 1000);
        

            AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:rawVideoURL options:nil];
            
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
        
            NSString *outputURL = [self createPath];
            exportSession.outputURL = [NSURL fileURLWithPath:outputURL];
            
            exportSession.outputFileType = AVFileTypeQuickTimeMovie;
            CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(startMilliseconds, 1000), CMTimeMake(endMilliseconds - startMilliseconds, 1000));
            exportSession.timeRange = timeRange;
            //self.videoURL = exportSession.outputURL;
        
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                switch (exportSession.status) {
                    case AVAssetExportSessionStatusCompleted:
                        // Custom method to import the Exported Video
                        self.videoURL = exportSession.outputURL;
                        [self convertVideoToGif];
                        break;
                    case AVAssetExportSessionStatusFailed:
                        //
                        NSLog(@"Failed:%@",exportSession.error);
                        break;
                    case AVAssetExportSessionStatusCancelled:
                        //
                        NSLog(@"Canceled:%@",exportSession.error);
                        break;
                    default:
                        break;
                }
            }];

            // If video was not trimmer, use the entire video.
        } else {
            self.videoURL = rawVideoURL;
            [self convertVideoToGif];
        }
    }
}

-(NSString*)createPath {

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

@end












