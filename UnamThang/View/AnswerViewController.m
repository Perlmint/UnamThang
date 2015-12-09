//
//  AnswerViewController.m
//  UnamThang
//
//  Created by omniavinco on 12. 7. 3..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import "AnswerViewController.h"
#import "../UserObject.h"
#import "../Utils.h"
#import "../Lib/UIPopupView/UIPopupView.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDictionary *currentGame = [UserObject sharedObject].currentGame;
    word = [currentGame objectForKey:@"word"];
    session = [[RMPaintSession alloc] initWith:[currentGame objectForKey:@"drawing"]];
    canvasHolderView.contentSize = CGSizeMake(320.f, 320.f);
    canvasView = [[RMCanvasView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 320.f)];
    [canvasHolderView addSubview:canvasView];
    canvasView.brush = [UIImage imageNamed:@"basic"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //answerLabel.text = getInitials(word);
    answerField.placeholder = getInitials(word);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Show Keyaboard
    [answerField becomeFirstResponder];
    
    UIPopupView *popupView = [[UIPopupView alloc] init];
    popupView.popupType = UIPopupViewTypeConfirm;
    popupView.title = NSLocalizedString(@"ANSWER_TAP_PLZ", @"Tap to Start Playing");
    popupView.introductionAnimation = popupView.hideAnimation = UIPopupViewAnimationReverseEnlarge;
    popupView.mainViewTapListner = popupView.backgroundViewTapListner = ^(UIPopupView *popup) {
        [popup hide];
        [session paintInCanvas:canvasView withDelay:0.05f];
    };
    [self.view addSubview:popupView];
    [popupView show];
}

#pragma mark - UITextField Delegate

- (IBAction)answerChanged:(UITextField *)textField
{	
    NSString *previewString = textField.text;
    answerLabel.text = [NSString stringWithFormat:@"%@%@", previewString, getInitials([word substringFromIndex:previewString.length])];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *previewString = [NSMutableString stringWithString:textField.text];
    if (previewString.length == 0) {
        [previewString setString:string];
    }
    else
    {
        [previewString replaceCharactersInRange:range withString:string];
    }
    NSString *initial = getInitials(previewString);
    if ([initial isEqualToString:getInitials([word substringToIndex:initial.length])]) {
        answerLabel.text = [NSString stringWithFormat:@"%@%@", previewString, getInitials([word substringFromIndex:previewString.length])];
        return YES;
    }
    return NO;
}


#pragma mark - Button Actions

// TODO: #1 show result
- (IBAction)confirmButtonClicked
{
    if ([answerField.text isEqualToString:word]) {
        [answerField resignFirstResponder];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"good"]];
        [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClicked)]];
        [self.view addSubview:imageView];
        imageView.center = self.view.center;
    }
    else
    {
        [answerField resignFirstResponder];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bad"]];
        [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClicked)]];
        [self.view addSubview:imageView];
        imageView.center = self.view.center;
    }
}

- (IBAction)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
