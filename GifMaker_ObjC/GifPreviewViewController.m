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
    [self formatButton];
}

-(void)formatButton {
    
    [self.shareButton.layer setBorderWidth:10.0];
    [self.shareButton.layer setBorderColor:(__bridge CGColorRef _Nullable)([self radicalPinkColor])];
    
}


- (IBAction)shareGif:(id)sender {
    
    NSData *animatedGif = [NSData dataWithContentsOfURL:self.gif.url];
    NSArray *sharingItems = [NSArray arrayWithObjects: animatedGif, nil];
    
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    
    //UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:@[self.gif.gifImage] applicationActivities:nil];
    
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
                                            

-(UIColor*)radicalPinkColor {
    UIColor *color = [UIColor colorWithRed:252.0/255.0 green:55.0/255.0 blue:104.0/255.0 alpha:1];
    return color;
}

@end
