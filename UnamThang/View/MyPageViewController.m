//
//  MyPageViewController.m
//  UnamThang
//
//  Created by omniavinco on 12. 7. 3..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import "MyPageViewController.h"
#import "SendChallengeViewController.h"
#import "ChallengeViewController.h"
#import "../UserObject.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (id)init
{
    self = [self initWithNibName:@"MyPageView" bundle:nil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateScoreLabel];
    [self updateUserInfo];
}

#pragma mark - update data

- (void)updateScoreLabel
{
    scoreLabel.text = [NSString stringWithFormat:@"%u", [UserObject sharedObject].score];
}

- (void)updateUserInfo
{
    UserObject *user = [UserObject sharedObject];
    userNameLabel.text = [user objectForKey:@"name"];
    profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[user objectForKey:@"pic_square"]]]];
}

// TODO: #1 Disappear Activity Indicator
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - button actions

// TODO: #2 Show Activity Indicator

- (IBAction)sendChallengeClicked
{
    SendChallengeViewController *destinationViewController = [[SendChallengeViewController alloc] init];
    
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

- (IBAction)showRecivedChallengeClicked
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectNotification:) name:@"challengeSenderReciveSuccess" object:nil];
    [[UserObject sharedObject] updateChallengeSenderList];
}

- (void)detectNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"challengeSenderReciveSuccess"]) {
        ChallengeViewController *destinationViewController = [[ChallengeViewController alloc] init];
        
        [self.navigationController pushViewController:destinationViewController animated:YES];
    }
}

@end
