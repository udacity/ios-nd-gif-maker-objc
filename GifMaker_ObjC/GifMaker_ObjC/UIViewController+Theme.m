//
//  UIViewController+Theme.m
//  GifMaker_ObjC
//
//  Created by Ayush Saraswat on 4/26/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "UIViewController+Theme.h"

@implementation UIViewController (Theme)

- (void)applyTheme:(Theme)theme {
    switch (theme) {
        case Light:
            [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
            [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:51.0/255.0 blue:102.0/255.0 alpha:1.0]];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:46.0/255.0 green:61.0/255.0 blue:73.0/255.0 alpha:1.0]}];

            [self.view setBackgroundColor:[UIColor whiteColor]];
            
            break;
        case Dark:
            
            
            
            break;
        case DarkTransparent:
            [self.view setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:61.0/255.0 blue:73.0/255.0 alpha:0.9]];
            
            break;
        
        default:
            break;
    }
}

@end
