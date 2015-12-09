//
//  UIImageView_Overlay.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 4..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import "UIImage+Overlay.h"

@implementation UIImage (overlay)

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color
{
    // load the image
    UIImage *img = [UIImage imageNamed:name];
    
    //return the color-burned image
    return [img imageWithColor:color];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(self.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextDrawImage(context, rect, self.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

@end
