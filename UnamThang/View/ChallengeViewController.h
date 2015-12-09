//
//  ChallengeViewController.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 4..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeViewController : UIViewController
{
    NSArray *challengeList;
    IBOutlet UITableView *tableView;
}
- (IBAction)backButtonClicked;

@end
