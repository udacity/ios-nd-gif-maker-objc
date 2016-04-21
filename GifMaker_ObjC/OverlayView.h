//
//  OverlayView.h
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/20/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayView : UIView

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
