//
//  SendChallengeViewController.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 4..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendChallengeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *friendList;
    NSArray *friendUsingAppList;
    IBOutlet UITableView *tableView;
    NSString *noFriendErrorString;
}

- (IBAction)goBackButtonClicked;
- (IBAction)randomButtonClicked;
@end
