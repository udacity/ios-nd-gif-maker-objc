//
//  WelcomeViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/19/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Gif.h"
#import "AppDelegate.h"
@import MobileCoreServices;
@import Regift;
@import AVFoundation;
#import "GifEditorViewController.h"
#import "WelcomeViewController+AllowEditing.h"

static int const kFrameCount = 16;
static const float kDelayTime = 0.2;
static const int kLoopCount = 0; // 0 means loop forever

@implementation WelcomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    Gif *firstLaunchGif = [[Gif alloc] initWithName:@"tinaFeyHiFive"];
    self.defaultGifImageView.image = firstLaunchGif.gifImage;

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WelcomeViewSeen"];

}

- (IBAction)presentVideoOptions:(id)sender {
    UIAlertController * createNewGifAlert =   [UIAlertController
                                 alertControllerWithTitle:@"Create new GIF"
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* recordVideo = [UIAlertAction
                         actionWithTitle:@"Record a Video"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [self startCameraFromViewController:self];
                             [createNewGifAlert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    UIAlertAction* chooseFromExisting = [UIAlertAction
                                  actionWithTitle:@"Choose from existing"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      //Do some thing here
                                      [createNewGifAlert dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [createNewGifAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [createNewGifAlert addAction:chooseFromExisting];
    [createNewGifAlert addAction:recordVideo];
    [createNewGifAlert addAction:cancel];
    [self presentViewController:createNewGifAlert animated:YES completion:nil];

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
            NSString *outputURL = [WelcomeViewController createPath];
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
            AVAssetExportSession *trimmedSession = [WelcomeViewController configureExportSession:exportSession outputURL:outputURL startMilliseconds:startMilliseconds endMilliseconds:endMilliseconds];
            
            // Export trimmed video
            [trimmedSession exportAsynchronouslyWithCompletionHandler:^{
                switch (trimmedSession.status) {
                    case AVAssetExportSessionStatusCompleted:
                        // Custom method to import the Exported Video
                        self.videoURL = trimmedSession.outputURL;
                        [self convertVideoToGif];
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
            self.videoURL = rawVideoURL;
            [self convertVideoToGif];
        }
    }
}

# pragma mark - Gif Conversion and Display methods

-(void)convertVideoToGif {
    Regift *regift = [[Regift alloc] initWithSourceFileURL:self.videoURL frameCount:kFrameCount delayTime:kDelayTime loopCount:kLoopCount];
    self.gifURL = [regift createGif];
    [self saveGif];
}

-(void)saveGif{
    Gif *newGif = [[Gif alloc] initWithGifUrl:self.gifURL videoURL: self.videoURL caption:nil];
    [self displayGif:newGif];
}

-(void)displayGif:(Gif*)gif {
    GifEditorViewController *gifEditorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GifEditorViewController"];
    gifEditorVC.gif = gif;
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
    [self.navigationController pushViewController:gifEditorVC animated:true];
    
}


@end
