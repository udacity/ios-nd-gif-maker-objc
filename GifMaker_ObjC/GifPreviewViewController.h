//
//  GifPreviewViewController.h
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/18/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gif.h"
@import QuartzCore;

@interface GifPreviewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (nonatomic) Gif *gif;
@property (weak, nonatomic) IBOutlet UILabel *gifCaptionLabel;

@end
