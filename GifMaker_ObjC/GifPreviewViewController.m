//
//  GifPreviewViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/18/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "GifPreviewViewController.h"
#import "UIViewController+Theme.h"

#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>

@interface GifPreviewViewController()

@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
//@property (weak, nonatomic) IBOutlet UILabel *gifCaptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end


@implementation GifPreviewViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Customize View
    self.title = @"Preview";
    [self applyTheme:Dark];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.title = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gifImageView.image = self.gif.gifImage;
    
    // Customize Buttons
    [self.shareButton.layer setCornerRadius:4.0];
    [self.shareButton.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:65.0/255.0 blue:112.0/255.0 alpha:1.0] CGColor]];
    [self.shareButton.layer setBorderWidth:1.0];
    
    [self.saveButton.layer setCornerRadius:4.0];
    
    // Customize Label
    NSDictionary *defaultAttributes = @{NSStrokeColorAttributeName : [UIColor blackColor],
                                        NSStrokeWidthAttributeName : @(-4),
                                        NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:40.0]};
    NSAttributedString *attributedCaption = [[NSAttributedString alloc] initWithString:self.gif.caption attributes:defaultAttributes];
    //[self.gifCaptionLabel setAttributedText:attributedCaption];
}

- (IBAction)shareGif:(id)sender {
    NSData *animatedGif = [NSData dataWithContentsOfURL:self.gif.url];
    NSArray *sharingItems = [NSArray arrayWithObjects: animatedGif, nil];
    
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [shareController setCompletionWithItemsHandler: ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (completed) {
            [self.navigationController popToRootViewControllerAnimated:TRUE];
        }
    }];
    
    [self presentViewController:shareController animated:TRUE completion: nil];
}

- (IBAction)saveGif:(id)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.gifs addObject:self.gif];
    
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

@end
