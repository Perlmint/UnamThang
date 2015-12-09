//
//  AnswerViewController.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 3..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Lib/RMPaint/RMCanvasView.h"
#import "../Lib/RMPaint/RMPaintSession.h"

@interface AnswerViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIScrollView *canvasHolderView;
    RMCanvasView *canvasView;
    IBOutlet UITextField *answerField;
    IBOutlet UILabel *answerLabel;
    
    RMPaintSession *session;
    NSString *word;
}

- (IBAction)confirmButtonClicked;
- (IBAction)backButtonClicked;

@end
