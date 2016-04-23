//
//  DetailViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/22/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:TRUE];
    self.gifImageView.image = self.gif.gifImage;
    //UIColor *detailViewColor = UIColor color
    self.navigationController.navigationBar.barTintColor = self.view.backgroundColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
