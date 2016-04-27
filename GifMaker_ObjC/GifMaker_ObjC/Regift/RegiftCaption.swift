//
//  RegiftCaption.swift
//  Regift
//
//  Created by Gabrielle Miller-Messner on 4/22/16.
//  Modified from http://stackoverflow.com/questions/6992830/how-to-write-text-on-image-in-objective-c-iphone
//

import UIKit

extension Regift {
    
    
    func addCaption(image: CGImageRef, text: NSString, font: UIFont) -> CGImage {
        let image = UIImage(CGImage:image)
        // Text attributes
        let color = UIColor.whiteColor()
        
        let biggerFont: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size:(font.pointSize * 1.3))!
        let attributes = [NSForegroundColorAttributeName:color, NSFontAttributeName:biggerFont, NSStrokeColorAttributeName : UIColor.blackColor(), NSStrokeWidthAttributeName : -4]
        
        // Text size
        let size =  text.sizeWithAttributes(attributes)
        let captionWidth = size.width
        
        // Draw image
        UIGraphicsBeginImageContext(image.size)
        let firstRect = CGRectMake(0,0,image.size.width,image.size.height)
        image.drawInRect(firstRect)
        
        // Draw text
        let sideMargin = (image.size.width - captionWidth)/2.0
        let textOrigin  = CGPointMake(sideMargin, image.size.height - 60)
        let secondRect = CGRectMake(textOrigin.x,textOrigin.y,image.size.width,image.size.height)
        text.drawInRect(CGRectIntegral(secondRect), withAttributes: attributes)
        
        // Capture combined image and text
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage.CGImage!
    }
}