//
//  DetailViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/22/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "DetailViewController.h"
#import "UIViewController+Theme.h"

#import <QuartzCore/QuartzCore.h>

#define GifFileURL [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"savedGifsAsGifs"]

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.shareButton.layer setCornerRadius:4.0];
    
    self.gifImageView.image = self.gif.gifImage;
    [self applyTheme:DarkTranslucent];
}

- (IBAction)shareGif:(id)sender {
    //NSString *savedPath = [GifFileURL stringByAppendingString:self.gif.uniqueID];
    //NSURL *savedURL = [NSURL URLWithString:savedPath];
    
    //NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *sharingItems;

    //NSData *animatedGif = [NSData dataWithContentsOfURL:savedURL];
    sharingItems = [NSArray arrayWithObjects: self.gif.gifData, nil];
    //sharingItems = [NSArray arrayWithObjects: animatedGif, nil];
    
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    
    [shareController setCompletionWithItemsHandler: ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (completed) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    
    [self presentViewController:shareController animated:YES completion: nil];
}

//- (NSString*)createPath {
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *outputURL = [documentsDirectory stringByAppendingPathComponent:@"savedGifsToShare"] ;
//   
//    return outputURL;
//}

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
