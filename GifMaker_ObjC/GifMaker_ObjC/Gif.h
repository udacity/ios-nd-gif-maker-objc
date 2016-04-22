//
//  Gif.h
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/4/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface Gif : NSObject

@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *caption;
@property (nonatomic) UIImage *gifImage;
@property (nonatomic) NSURL *rawVideoURL;

-(instancetype)initWithGifUrl: (NSURL*)url videoURL:(NSURL*)videoURL caption:(NSString*)caption;
-(instancetype)initWithName:(NSString*)name;
@end
