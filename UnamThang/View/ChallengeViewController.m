//
//  ChallengeViewController.m
//  UnamThang
//
//  Created by omniavinco on 12. 7. 4..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import "ChallengeViewController.h"
#import "AnswerViewController.h"
#import "../Lib/UIPopupView/UIPopupView.h"
#import "../Lib/JSON/SBJson.h"
#import "../Lib/NSData+Base64.h"
#import "../ImageCacher.h"
#import "../UserObject.h"
#import "../Constant.h"

@interface ChallengeViewController ()

@end

@implementation ChallengeViewController

- (id)init
{
    self = [self initWithNibName:@"ChallengeView" bundle:nil];
    
    if (self) {
        challengeList = [UserObject sharedObject].challengeSenderList;
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (challengeList == nil || challengeList.count == 0) {
        UIPopupView *popupView = [[UIPopupView alloc] init];
        popupView.popupType = UIPopupViewTypeConfirm;
        popupView.title = @"No Challenge";
        popupView.introductionAnimation = popupView.hideAnimation = UIPopupViewAnimationReverseEnlarge;
        popupView.mainViewTapListner = popupView.backgroundViewTapListner = ^(UIPopupView *popup) {
            [self.navigationController popViewControllerAnimated:YES];
            [popup hide];
        };
        [self.view addSubview:popupView];
        [popupView show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Datasource

- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
    return challengeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)path
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    NSDictionary *data = [challengeList objectAtIndex:path.row];
    
    cell.imageView.image = [[ImageCacher sharedObject] imageForURL:[data objectForKey:@"pic_square"]];
    cell.textLabel.text = [data objectForKey:@"name"];
    cell.detailTextLabel.text = [data objectForKey:@"time"];
    
    return cell;
}

#pragma mark - Tableview Delegate


- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)path
{
    NSDictionary *data = [challengeList objectAtIndex:path.row];
    
    NSMutableDictionary *game = [UserObject sharedObject].currentGame;
    [game setObject:[data objectForKey:@"uid"] forKey:@"openentID"];
    
    NSError *error = nil;
    NSString *recivedData = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/getChallengeData.php?gid=%@", SERVER_HOST, [data objectForKey:@"gid"]]] encoding:NSUTF8StringEncoding error:&error];
    NSDictionary *recivedDictionay = recivedData.JSONValue;
    [game setObject:[[recivedDictionay objectForKey:@"drawing"] JSONValue] forKey:@"drawing"];
    [game setObject:[recivedDictionay objectForKey:@"word"] forKey:@"word"];
    
    AnswerViewController *destinationView = [[AnswerViewController alloc] init];
    NSMutableArray *navigationViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [navigationViewControllers removeLastObject];
    [navigationViewControllers addObject:destinationView];
    [self.navigationController setViewControllers:navigationViewControllers animated:YES];
}

#pragma mark - Button Actions

- (IBAction)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
