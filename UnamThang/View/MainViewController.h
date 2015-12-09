//
//  MainViewController.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 3..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Lib/UIImage+Overlay.h"

@interface MainViewController : UIViewController<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    IBOutlet UIButton *gameStartButton;
}

@end
