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
        var attributes = [NSForegroundColorAttributeName:color, NSFontAttributeName:font, NSStrokeColorAttributeName : UIColor.blackColor(), NSStrokeWidthAttributeName : -4]
        
        // Get scale factor
        let testSize:CGSize =  text.sizeWithAttributes(attributes)
        let scaleFactor = testSize.height/360
        
        // Apply scale factor to attributes
        let scaledFont: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size:image.size.height * scaleFactor)!
        attributes[NSFontAttributeName] = scaledFont
        
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
        let bottomMargin = image.size.height/6.0
        let textOrigin  = CGPointMake(sideMargin, image.size.height - bottomMargin)
        let secondRect = CGRectMake(textOrigin.x,textOrigin.y, adjustedWidth, adjustedHeight)
        text.drawWithRect(secondRect, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        
        // Capture combined image and text
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage.CGImage!
    }
}