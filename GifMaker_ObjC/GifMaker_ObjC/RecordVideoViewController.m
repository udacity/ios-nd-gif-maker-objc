//
//  RecordVideoViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/1/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "RecordVideoViewController.h"

#import "RecordVideoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "GifMaker_ObjC-Swift.h"

@interface RecordVideoViewController()

@property (nonatomic) NSURL *videoURL;

@end

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
        cameraController.allowsEditing = false;
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    CFStringRef mediaType = (__bridge CFStringRef)([info objectForKey:UIImagePickerControllerMediaType]);
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
    // Handle a movie capture
    if (mediaType == kUTTypeMovie) {
        
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videoURL = url;
        NSString *path = url.path;
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video: didFinishSavingWithError: contextInfo:), nil);
        }
        
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

# pragma mark - Gif Conversion and Display methods

// Gif conversion and display
func convertVideoToGif() {
    let regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
    self.gifURL = regift.createGif()!
    print("Gif saved to \(regift.createGif())")
}

@IBAction func displayGif(sender: AnyObject) {
    let gifDisplayVC = self.storyboard!.instantiateViewControllerWithIdentifier("DisplayGifViewController") as! DisplayGifViewController
    gifDisplayVC.urlForGifToDisplay = self.gifURL
    
    presentViewController(gifDisplayVC, animated: true, completion: nil)
}
}




-(void)convertVideoToGif {
    
}

@end

