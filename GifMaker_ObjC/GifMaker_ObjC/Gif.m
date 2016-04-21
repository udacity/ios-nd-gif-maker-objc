//
//  Gif.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/4/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "Gif.h"
#import "UIImage+animatedGIF.h"

@implementation Gif

-(instancetype)initWithUrl: (NSURL*)url caption:(NSString*)caption {
    
    self = [super init];
    
    if(self){
        self.url = url;
        self.caption = caption;
        self.gifImage = [UIImage animatedImageWithAnimatedGIFURL:url];
    }
    
    return self;
}

-(instancetype)initWithName:(NSString*)name {
    
    self = [super init];
    
    if(self) {
        self.gifImage = [UIImage animatedImageWithAnimatedGIFName:name];
    }
    
    return self;
}



@end
