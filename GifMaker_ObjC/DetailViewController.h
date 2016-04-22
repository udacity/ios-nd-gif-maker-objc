//
//  DetailViewController.h
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/22/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gif.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic) Gif *gif;

@end
