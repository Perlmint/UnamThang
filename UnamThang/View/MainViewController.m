//
//  MainViewController.m
//  UnamThang
//
//  Created by omniavinco on 12. 7. 3..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import "MainViewController.h"
#import "MyPageViewController.h"
#import "../Utils.h"
#import "../UserObject.h"
#import "../Lib/UIPopupView/UIPopupView.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)init
{
    self = [self initWithNibName:@"MainView" bundle:nil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UserObject *user = [UserObject sharedObject];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectNotification:) name:@"fbAuthSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectNotification:) name:@"fbAuthFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectNotification:) name:@"logonSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectNotification:) name:@"logonFailed" object:nil];
    if (!user.isValid) {
        [user authFacebook];
    }
    
    SystemSoundID audioEffect = 0;
    AudioServicesDisposeSystemSoundID(audioEffect);
    playSound(&audioEffect, @"together", @"mp3");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)gameStartClicked
{
    MyPageViewController *destination = [[MyPageViewController alloc] init];
    NSMutableArray *navigationViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [navigationViewControllers removeLastObject];
    [navigationViewControllers addObject:destination];
    [self.navigationController setViewControllers:navigationViewControllers animated:YES];
}

- (void)detectNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"fbAuthSuccess"]) {
        [[UserObject sharedObject] logonServer];
    }
    else if ([notification.name isEqualToString:@"fbAuthFailed"]) {
        UIPopupView *popupView = [[UIPopupView alloc] init];
        popupView.popupType = UIPopupViewTypeCancel;
        popupView.title = NSLocalizedString(@"FB_AUTH_FAILED", @"Facebook Auth Failed");
        popupView.introductionAnimation = popupView.hideAnimation = UIPopupViewAnimationReverseEnlarge;
        popupView.mainViewTapListner = popupView.backgroundViewTapListner = ^(UIPopupView *popup) {
            [popup hide];
        };
        [self.view addSubview:popupView];
        [popupView show];
    }
    else if ([notification.name isEqualToString:@"logonSuccess"]) {
        [gameStartButton addTarget:self action:@selector(gameStartClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([notification.name isEqualToString:@"logonFailed"]) {
        UIPopupView *popupView = [[UIPopupView alloc] init];
        popupView.popupType = UIPopupViewTypeCancel;
        popupView.title = NSLocalizedString(@"LOGON_FAILED", @"Logon Failed");
        popupView.introductionAnimation = popupView.hideAnimation = UIPopupViewAnimationReverseEnlarge;
        popupView.mainViewTapListner = popupView.backgroundViewTapListner = ^(UIPopupView *popup) {
            [popup hide];
        };
        [self.view addSubview:popupView];
        [popupView show];
    }
}



@end
