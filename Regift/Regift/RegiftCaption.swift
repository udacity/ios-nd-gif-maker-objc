//
//  RegiftCaption.swift
//  Regift
//
//  Created by Gabrielle Miller-Messner on 4/22/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation


extension Regift {
    
    
    func addCaption(image: CGImageRef, text: NSString, font: UIFont) -> CGImage {
        var image = UIImage(CGImage:image)
        // Text attributes
        var color = UIColor.whiteColor()
        
        var biggerFont: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size:(font.pointSize * 1.5))!
        var attributes = [NSForegroundColorAttributeName:color, NSFontAttributeName:biggerFont, NSStrokeColorAttributeName : UIColor.blackColor(), NSStrokeWidthAttributeName : -4]
        
        let textAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(),
                              NSForegroundColorAttributeName : UIColor.whiteColor(),
                              NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!,
                              NSStrokeWidthAttributeName : -4]
        
        
        
        // Text size
        var size =  text.sizeWithAttributes(attributes)
        var captionWidth = size.width
        
        // Draw image
        UIGraphicsBeginImageContext(image.size)
        var firstRect = CGRectMake(0,0,image.size.width,image.size.height)
        image.drawInRect(firstRect)
        
        // Draw text
        var sideMargin = (image.size.width - captionWidth)/2.0
        var textOrigin  = CGPointMake(sideMargin, image.size.height - 60)
        var secondRect = CGRectMake(textOrigin.x,textOrigin.y,image.size.width,image.size.height)
        text.drawInRect(CGRectIntegral(secondRect), withAttributes: attributes)
        
        // Capture combined image and text
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage.CGImage!
    }
}