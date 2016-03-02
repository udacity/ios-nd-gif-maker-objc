//
//  DisplayGifViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/1/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "DisplayGifViewController.h"

#import "DisplayGifViewController.h"
#import "UIImage+animatedGIF.h"

@interface DisplayGifViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@end

@implementation DisplayGifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:TRUE];
    
    //Returns an animated image
    UIImage *gifFromRecording = [UIImage animatedImageWithAnimatedGIFURL:self.gifURL];

    // Use the UIImage in your UIImageView
    self.gifImageView.image = gifFromRecording;
    
}

- (IBAction)startOver:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end

