//
//  DrawingViewController.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 3..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Lib/RMPaint/RMGestureCanvasView.h"
#import "../Lib/RMPaint/RMPaintSession.h"

@interface DrawingViewController : UIViewController<RMCanvasViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    IBOutlet UIView *canvasHolderView;
    RMGestureCanvasView *canvasView;
    RMPaintSession *session;
    
    IBOutlet UISlider *slider;
    
    IBOutlet UILabel *wordLabel;
    NSString *word;
    NSArray *colorArray;
    IBOutlet UIScrollView *colorSelectionView;
    
    NSMutableData *recivedData;
}

- (IBAction)sendClicked;
- (IBAction)backButtonClicked;

@end
