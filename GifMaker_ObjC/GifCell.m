//
//  GifCell.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/18/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "GifCell.h"

@implementation GifCell

-(instancetype)populateCellWithGif:(Gif*)gif {
    self.gifImageView.image = gif.gifImage;
    
    return self;
}

@end
