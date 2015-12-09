//
//  WordSelectionViewController.m
//  UnamThang
//
//  Created by omniavinco on 12. 7. 4..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import "WordSelectionViewController.h"
#import "DrawingViewController.h"
#import "../UserObject.h"
#import "../Constant.h"
#import "../Lib/JSON/SBJson.h"

@interface WordSelectionViewController ()

@end

@implementation WordSelectionViewController

- (id)init
{
    self = [self initWithNibName:@"WordSelectionView" bundle:nil];
    
    if (self) {
        NSError *error = nil;
        words = [[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/getWordsList.php", SERVER_HOST]] encoding:NSUTF8StringEncoding error:&error] JSONValue];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (NSInteger i = 0; i < 3; ++i) {
        UIButton *button = [wordButtons objectAtIndex:i];
        [button setTitle:[words objectAtIndex:i] forState:UIControlStateNormal];
    }
}

- (IBAction)wordButtonClicked:(UIButton *)sender
{
    [[UserObject sharedObject].currentGame setObject:sender.titleLabel.text forKey:@"word"];
    [self showDrawingView];
}

- (void)showDrawingView
{
    DrawingViewController *destinationView = [[DrawingViewController alloc] init];
    NSMutableArray *navigationViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [navigationViewControllers removeLastObject];
    [navigationViewControllers addObject:destinationView];
    [self.navigationController setViewControllers:navigationViewControllers animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
