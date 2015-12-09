//
//  SendChallengeViewController.m
//  UnamThang
//
//  Created by omniavinco on 12. 7. 4..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import "SendChallengeViewController.h"
#import "WordSelectionViewController.h"
#import "../Lib/UIPopupView/UIPopupView.h"
#import "../UserObject.h"
#import "../ImageCacher.h"

@implementation SendChallengeViewController

- (id)init
{
    self = [self initWithNibName:@"SendChallengeView" bundle:nil];
    
    if (self) {
        noFriendErrorString = NSLocalizedString(@"SEND_NO_FRIEND_ERROR", @"No Friend! Invite Your Friend");
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    friendList = [UserObject sharedObject].friendList;
    friendUsingAppList = [UserObject sharedObject].friendUsingAppList;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (friendUsingAppList == nil || friendUsingAppList.count == 0) {
        UIPopupView *popupView = [[UIPopupView alloc] init];
        popupView.popupType = UIPopupViewTypeConfirm;
        popupView.title = noFriendErrorString;
        popupView.introductionAnimation = popupView.hideAnimation = UIPopupViewAnimationReverseEnlarge;
        popupView.mainViewTapListner = popupView.backgroundViewTapListner = ^(UIPopupView *popup) {
            [popup hide];
        };
        [self.view addSubview:popupView];
        [popupView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[ImageCacher sharedObject] cleanupCache];
}

#pragma mark - Tableview Datasource

- (NSString *)tableView:(UITableView *)tableView_ titleForHeaderInSection:(NSInteger)section
{
    return section == 0?@"":@"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView_ {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
    return section == 0?friendUsingAppList.count:friendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)path
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:identifier];
    NSArray *dataSet = path.section == 0?friendUsingAppList:friendList;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    NSDictionary *data = [dataSet objectAtIndex:path.row];
    
    cell.imageView.image = [[ImageCacher sharedObject] imageForURL:[data objectForKey:@"pic_square"]];
    cell.textLabel.text = [data objectForKey:@"name"];
    cell.detailTextLabel.text = path.section == 0?@"Start New Game":@"Invite Your Friend";
    
    return cell;
}

#pragma mark - Tableview Delegate

// TODO: #1 Send Invitation
- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)path
{
    NSDictionary *data = [path.section == 0?friendUsingAppList:friendList objectAtIndex:path.row];
    
    if (path.section == 0) {

        NSMutableDictionary *game = [UserObject sharedObject].currentGame;
        [game setObject:[data objectForKey:@"uid"] forKey:@"openentID"];
        
        [self showWordSelectionView];
    }
    else
    {
        // TODO: #1
    }
}

#pragma mark -

- (void)showWordSelectionView
{
    WordSelectionViewController *destinationView = [[WordSelectionViewController alloc] init];
    NSMutableArray *navigationViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [navigationViewControllers removeLastObject];
    [navigationViewControllers addObject:destinationView];
    [self.navigationController setViewControllers:navigationViewControllers animated:YES];
}

#pragma mark - Button Actions

- (IBAction)goBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

// TODO: #3 Get Random Openent
- (IBAction)randomButtonClicked
{
    // TODO: #3
    // ------------------------------------ //
    [self showWordSelectionView];
    // ------------------------------------ //
}

@end
