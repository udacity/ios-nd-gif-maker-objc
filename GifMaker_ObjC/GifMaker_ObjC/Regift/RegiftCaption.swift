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
        
        print(font.pointSize)
        let biggerFont: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size:(font.pointSize))!
        let attributes = [NSForegroundColorAttributeName:color, NSFontAttributeName:biggerFont, NSStrokeColorAttributeName : UIColor.blackColor(), NSStrokeWidthAttributeName : -4]
        
        // Text size
        let size:CGSize =  text.sizeWithAttributes(attributes)
        let adjustedWidth = ceil(size.width)
        let adjustedHeight = ceil(size.height)
        
        // Draw image
        UIGraphicsBeginImageContext(image.size)
        let firstRect = CGRectMake(0,0,image.size.width,image.size.height)
        image.drawInRect(firstRect)
        
        // Draw text
        let sideMargin = (image.size.width - adjustedWidth)/2.0
        let textOrigin  = CGPointMake(sideMargin, image.size.height - 70)
        let secondRect = CGRectMake(textOrigin.x,textOrigin.y, adjustedWidth, adjustedHeight)
        text.drawInRect(CGRectIntegral(secondRect), withAttributes: attributes)
        
        // Capture combined image and text
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage.CGImage!
    }
}