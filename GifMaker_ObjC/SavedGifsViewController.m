//
//  SavedGifsViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/18/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "SavedGifsViewController.h"
#import "AppDelegate.h"
#import "GifCell.h"
#import "RecordVideoViewController.h"
#import "WelcomeViewController.h"
@import MobileCoreServices;
@import Regift;
@import AVFoundation;
#import "GifEditorViewController.h"
#import "SavedGifsViewController+AllowEditing.h"
#import "OverlayView.h"

@interface SavedGifsViewController()

@property (weak, nonatomic) IBOutlet UIImageView *collectionEmptyImageView;
@property (weak, nonatomic) IBOutlet UILabel *collectionEmptyLabel;
@property (weak, nonatomic) NSArray *savedGifs;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSURL *squareURL;

@end

static int const kFrameCount = 16;
static const float kDelayTime = 0.2;
static const int kLoopCount = 0; // 0 means loop forever

@implementation SavedGifsViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.savedGifs = appDelegate.gifs;
    [self.collectionView reloadData];
    
    if (self.savedGifs.count > 0) {
        self.collectionEmptyLabel.hidden = true;
        self.collectionEmptyImageView.hidden = true;
        
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"WelcomeViewSeen"] != YES) {
        WelcomeViewController *welcomeVC = [self.storyboard instantiateViewControllerWithIdentifier: @"WelcomeViewController"];
        [self.navigationController pushViewController:welcomeVC animated:TRUE];
    }
}

-(void) viewDidLoad {
    [super viewDidLoad];
    [self prepareLayout];
}

-(void)viewDidAppear:(BOOL)animated{

}

-(NSArray*)gifs {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.gifs;
    
//    Gif *firstGif = [[Gif alloc] initWithName:@"tinaFeyHiFive"];
//    Gif *secondGif = [[Gif alloc] initWithName:@"tinaFeyHiFive"];
//    Gif *thirdGif = [[Gif alloc] initWithName:@"tinaFeyHiFive"];
//    NSArray *gifs = @[firstGif,secondGif, thirdGif];
//    return gifs;
}

-(void)prepareLayout {
    CGFloat space = 4.0;
    CGFloat verticalLineSpacing = 8.0;
    CGFloat margin = 8.0;
    CGFloat smallSide = MIN(self.view.frame.size.width, self.view.frame.size.height);
    CGFloat dimension = ((smallSide - (2 * space) -(2 * margin)) / 2.0);
    self.flowLayout.minimumInteritemSpacing = space;
    self.flowLayout.itemSize = CGSizeMake(dimension,dimension);
    self.flowLayout.minimumLineSpacing = verticalLineSpacing;
    [self.collectionView reloadData];
}

# pragma mark UICollectionViewDelegate


# pragma mark UICollectionViewDatasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return 3;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.gifs.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GifCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GifCell" forIndexPath:indexPath];
    Gif *gif = [self gifs][indexPath.item];
    [cell populateCellWithGif:gif];

    return cell;
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
        
        // Constrain to square
        
        
//        OverlayView *myViewObject = [[[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil] objectAtIndex:0];
//        cameraController.cameraOverlayView=myViewObject;
    
        
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
            AVURLAsset *videoURLAsset = [AVURLAsset URLAssetWithURL:rawVideoURL options:nil];
            NSString *outputURL = [SavedGifsViewController createPath];
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoURLAsset presetName:AVAssetExportPresetHighestQuality];
            AVAssetExportSession *trimmedSession = [SavedGifsViewController configureExportSession:exportSession outputURL:outputURL startMilliseconds:startMilliseconds endMilliseconds:endMilliseconds];
            
            // Export trimmed video
            
            
            [trimmedSession exportAsynchronouslyWithCompletionHandler:^{
                switch (trimmedSession.status) {
                    case AVAssetExportSessionStatusCompleted:
                        // Custom method to import the Exported Video
                        [self convertVideoToGif: trimmedSession.outputURL];
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
            NSURL *videoURL = rawVideoURL;
            [self makeItSquare:videoURL];
            [self convertVideoToGif: self.squareURL];
        }
    }
}

-(void)makeItSquare: (NSURL*)rawVideoURL{
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
    NSString *path = [SavedGifsViewController createPath];
    exporter.outputURL = [NSURL fileURLWithPath:path];
    exporter.outputFileType=AVFileTypeQuickTimeMovie;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
        NSLog(@"Exporting done!");
        self.squareURL = exporter.outputURL;
    }];
}


# pragma mark - Gif Conversion and Display methods

-(void)convertVideoToGif:(NSURL*)videoURL {
    Regift *regift = [[Regift alloc] initWithSourceFileURL:videoURL frameCount:kFrameCount delayTime:kDelayTime loopCount:kLoopCount];
    NSURL *gifURL = [regift createGif];
    [self saveGif:gifURL];
}

-(void)saveGif:(NSURL*)gifURL {
    Gif *newGif = [[Gif alloc] initWithUrl:gifURL caption:@"default"];
    [self displayGif:newGif];
}

-(void)displayGif:(Gif*)gif {
    GifEditorViewController *gifEditorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GifEditorViewController"];
    gifEditorVC.gif = gif;
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
    [self.navigationController pushViewController:gifEditorVC animated:true];
    
}


@end
