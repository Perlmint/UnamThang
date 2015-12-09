//
//  UIImageView_Overlay.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 4..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (overlay)

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;
- (UIImage *)imageWithColor:(UIColor *)color;
@end
