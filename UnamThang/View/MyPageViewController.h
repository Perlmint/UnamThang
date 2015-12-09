//
//  MyPageViewController.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 3..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageViewController : UIViewController
{
    IBOutlet UILabel *scoreLabel;
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *userNameLabel;
}

- (IBAction)sendChallengeClicked;
- (IBAction)showRecivedChallengeClicked;

@end
