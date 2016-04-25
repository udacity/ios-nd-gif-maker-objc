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

-(instancetype)initWithGifUrl: (NSURL*)url videoURL:(NSURL*)videoURL caption:(NSString*)caption {
    
    self = [super init];
    
    if(self){
        self.url = url;
        self.caption = caption;
        self.rawVideoURL = videoURL;
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

-(instancetype)initWithCoder:(NSCoder *)decoder{
   
    self = [super init];
    
    // Unarchive the data, one property at a time
    self.url = [decoder decodeObjectForKey:@"gifURL"];
    self.caption = [decoder decodeObjectForKey:@"caption"];
    self.rawVideoURL = [decoder decodeObjectForKey:@"rawVideoURL"];
    self.gifImage = [decoder decodeObjectForKey:@"gifImage"];

    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.url forKey: @"gifURL"];
    [coder encodeObject:self.caption forKey: @"caption"];
    [coder encodeObject:self.rawVideoURL forKey: @"rawVideoURL"];
    [coder encodeObject:self.gifImage forKey: @"gifImage"];
}



@end
