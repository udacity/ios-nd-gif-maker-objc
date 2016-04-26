//
//  UIViewController+Record.m
//  GifMaker_ObjC
//
//  Created by Ayush Saraswat on 4/26/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "UIViewController+Record.h"
#import "GifEditorViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

#import "GifMaker_Objc-Swift.h"

@implementation UIViewController (Record) 

static int const kFrameCount = 16;
static const float kDelayTime = 0.2;
static const int kLoopCount = 0;

- (IBAction)presentVideoOptions:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self launchPhotoLibrary];
    } else {
        UIAlertController *newGifActionSheet = [UIAlertController alertControllerWithTitle:@"Create new GIF"
                                                                                    message:nil
                                                                             preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *recordVideo = [UIAlertAction actionWithTitle:@"Record a Video"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                [self launchCamera];
                                                            }];
        
        UIAlertAction *chooseFromExisting = [UIAlertAction actionWithTitle:@"Choose from Existing"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                [self launchPhotoLibrary];
                                                            }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        
        [newGifActionSheet addAction:recordVideo];
        [newGifActionSheet addAction:chooseFromExisting];
        [newGifActionSheet addAction:cancel];
        
        [self presentViewController:newGifActionSheet animated:YES completion:nil];
    }
}

- (void)launchCamera {
    UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
    cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraController.mediaTypes = @[(NSString *) kUTTypeMovie];
    cameraController.allowsEditing = true;
    cameraController.delegate = self;
    
    [self presentViewController:cameraController animated:TRUE completion:nil];
}

- (void)launchPhotoLibrary {
    UIImagePickerController *photoLibraryController = [[UIImagePickerController alloc] init];
    photoLibraryController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoLibraryController.mediaTypes = @[(NSString *) kUTTypeMovie];
    photoLibraryController.allowsEditing = true;
    photoLibraryController.delegate = self;
    
    [self presentViewController:photoLibraryController animated:TRUE completion:nil];
}

# pragma mark - ImagePickerControllerDelegate Methods

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

// Allows Editing
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    CFStringRef mediaType = (__bridge CFStringRef)([info objectForKey:UIImagePickerControllerMediaType]);
    //[self dismissViewControllerAnimated:TRUE completion:nil];
    
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
            
            // Use AVFoundation to trim the video
            AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:rawVideoURL options:nil];
            NSString *outputURL = [self createPath];
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
            AVAssetExportSession *trimmedSession = [self configureExportSession:exportSession outputURL:outputURL startMilliseconds:startMilliseconds endMilliseconds:endMilliseconds];
            __block NSURL *trimmedURL;
            
            // Export trimmed video
            [trimmedSession exportAsynchronouslyWithCompletionHandler:^{
                switch (trimmedSession.status) {
                    case AVAssetExportSessionStatusCompleted:
                        // Custom method to import the Exported Video
                        trimmedURL = trimmedSession.outputURL;
                        [self makeVideoSquare:trimmedURL];
                        break;
                    case AVAssetExportSessionStatusFailed:
                        //
                        NSLog(@"Failed:%@",trimmedSession.error);
                        break;
                    case AVAssetExportSessionStatusCancelled:
                        //
                        NSLog(@"Canceled:%@",trimmedSession.error);
                        break;
                    default:
                        break;
                }
            }];
            
            // If video was not trimmed, use the entire video.
        } else {
            [self makeVideoSquare:rawVideoURL];
        }
    }
}

-(void)makeVideoSquare: (NSURL*)rawVideoURL{
    //make it square
    AVAsset *videoAsset = [AVAsset assetWithURL:rawVideoURL];
    AVMutableComposition *composition = [AVMutableComposition composition];
    [composition  addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.height);
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );
    
    // rotate to portrait
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, -(videoTrack.naturalSize.width - videoTrack.naturalSize.height) /2 );
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
    
    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    // export
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality] ;
    exporter.videoComposition = videoComposition;
    NSString *path = [self createPath];
    exporter.outputURL = [NSURL fileURLWithPath:path];
    exporter.outputFileType=AVFileTypeQuickTimeMovie;
    
    __block NSURL *squareURL;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
        NSLog(@"Exporting done!");
        squareURL = exporter.outputURL;
        [self convertVideoToGif:squareURL];
    }];
}

- (NSString*)createPath {
    
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

- (AVAssetExportSession*)configureExportSession:(AVAssetExportSession*)session
                                     outputURL:(NSString*)outputURL
                             startMilliseconds:(int)start
                               endMilliseconds:(int)end {
    
    session.outputURL = [NSURL fileURLWithPath:outputURL];
    session.outputFileType = AVFileTypeQuickTimeMovie;
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(start, 1000), CMTimeMake(end - start, 1000));
    session.timeRange = timeRange;
    
    return session;
}

# pragma mark - Gif Conversion and Display methods

-(void)convertVideoToGif:(NSURL*)videoURL {
    Regift *regift = [[Regift alloc] initWithSourceFileURL:videoURL frameCount:kFrameCount delayTime:kDelayTime loopCount:kLoopCount];
    NSURL *gifURL = [regift createGif];
    [self saveGif:gifURL videoURL:videoURL];
}

-(void)saveGif:(NSURL*)gifURL videoURL: videoURL{
    Gif *newGif = [[Gif alloc] initWithGifUrl:gifURL videoURL:videoURL caption:nil];
    [self displayGif:newGif];
}

-(void)displayGif:(Gif*)gif {
    GifEditorViewController *gifEditorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GifEditorViewController"];
    gifEditorVC.gif = gif;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:TRUE completion:nil];
        [self.navigationController pushViewController:gifEditorVC animated:true];
    });
}

@end
