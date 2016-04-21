//
//  GifPreviewViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/18/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "GifPreviewViewController.h"
#import "Gif.h"
#import "AppDelegate.h"

@implementation GifPreviewViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.gifImageView.image = self.gif.gifImage;
    self.gifCaptionLabel.text = self.gif.caption;
}


- (IBAction)shareGif:(id)sender {
    
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:@[self.gif.gifImage] applicationActivities:nil];
    
    [shareController setCompletionWithItemsHandler: ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (completed) {
            [self.navigationController popToRootViewControllerAnimated:TRUE];
        }
    }];
    
    
    [self presentViewController:shareController animated:TRUE completion: nil];
}


- (IBAction)saveGif:(id)sender {

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.gifs addObject: self.gif];
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

@end
