//
//  DrawingViewController.m
//  UnamThang
//
//  Created by omniavinco on 12. 7. 3..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import "DrawingViewController.h"
#import "../UserObject.h"
#import "../Constant.h"
#import "../UserObject.h"
#import "../Lib/NSData+Base64.h"
#import "../Lib/UIPopupView/UIPopupView.h"
#import "../Lib/UIImage+Overlay.h"

@interface DrawingViewController ()

@end

@implementation DrawingViewController

- (id)init
{
    self = [self initWithNibName:@"DrawingView" bundle:nil];
    
    if (self) {
        NSArray *colors = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"color" ofType:@"plist" inDirectory:@""]];
        colorArray = [[NSMutableArray alloc] initWithCapacity:colors.count];
        for (NSDictionary *data in colors) {
            [(NSMutableArray *)colorArray addObject:[UIColor colorWithRed:[[data objectForKey:@"r"] floatValue] green:[[data objectForKey:@"g"] floatValue] blue:[[data objectForKey:@"b"] floatValue] alpha:[[data objectForKey:@"a"] floatValue]]];
        }
        session = [[RMPaintSession alloc] init];
        
        word = [[UserObject sharedObject].currentGame objectForKey:@"word"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize size = canvasHolderView.frame.size;
    canvasView = [[RMGestureCanvasView alloc] initWithFrame:CGRectMake(0.f, 0.f, size.width, size.height)];
    [canvasHolderView addSubview:canvasView];
    canvasView.delegate = self;
    canvasView.brush = [UIImage imageNamed:@"basic"];
    canvasView.brushColor = [colorArray objectAtIndex:0];
    
    [self updateColorSelectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateWordLabel];
}

- (void)updateColorSelectionView
{
    UIImage *image = [UIImage imageNamed:@"sample"];
    CGFloat height = image.size.height;
    CGFloat scale = colorSelectionView.frame.size.height / height;
    CGFloat width = image.size.width * scale;
    height = height * scale;
    
    colorSelectionView.contentSize = CGSizeMake(colorArray.count * width, height);
    for (NSUInteger index = 0, size = colorArray.count; index < size; ++index) {
        UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        colorButton.tag = index;
        [colorButton setImage:[image imageWithColor:[colorArray objectAtIndex:index]] forState:UIControlStateNormal];
        colorButton.frame = CGRectMake(width * index, 0.f, width, height);
        colorButton.tintColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        [colorButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBrushColor:)]];
        [colorSelectionView addSubview:colorButton];
    }
}

- (void)updateWordLabel
{
    wordLabel.text = word;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Canvas Delegate

- (void)canvasView:(RMCanvasView *)canvasView painted:(RMPaintStep *)step
{
    [session addStep:step];
}

#pragma mark - Data Transfer

- (void)sendData
{
    UserObject *user = [UserObject sharedObject];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/newGame.php", SERVER_HOST]]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"uid=%@&uid2=%@&word=%@&drawing=%@", [user objectForKey:@"uid"], [user.currentGame objectForKey:@"openentID"], word, [session save]] dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([NSURLConnection connectionWithRequest:request delegate:self]) {
        recivedData = [[NSMutableData alloc] init];
    }
    else
    {
        [self sendFailed];
    }
}

- (void)sendSuccess
{
    UIPopupView *popupView = [[UIPopupView alloc] init];
    popupView.popupType = UIPopupViewTypeConfirm;
    popupView.title = NSLocalizedString(@"DRAWING_SEND_SUCCESS", @"Successfully Sended");
    popupView.introductionAnimation = popupView.hideAnimation = UIPopupViewAnimationReverseEnlarge;
    popupView.mainViewTapListner = popupView.backgroundViewTapListner = ^(UIPopupView *popup) {
        [popup hide];
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:popupView];
    [popupView show];
}

- (void)sendFailed
{
    UIPopupView *popupView = [[UIPopupView alloc] init];
    popupView.popupType = UIPopupViewTypeCancel;
    popupView.title = NSLocalizedString(@"DRAWING_SEND_FAILED", @"Sending Failed");
    popupView.introductionAnimation = popupView.hideAnimation = UIPopupViewAnimationReverseEnlarge;
    popupView.mainViewTapListner = popupView.backgroundViewTapListner = ^(UIPopupView *popup) {
        [popup hide];
    };
    [self.view addSubview:popupView];
    [popupView show];
}

#pragma mark - button actions

- (void)changeBrushType:(UIButton *)sender
{
    
}

- (IBAction)eraserButtonClicked
{
    canvasView.brushColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
}

- (IBAction)changeBrushSize:(UISlider *)sender
{
    canvasView.brushScale = (sender.maximumValue - sender.minimumValue) / 2 / sender.value;
}

- (void)changeBrushColor:(UIGestureRecognizer *)sender
{
    NSInteger index = [sender.view tag];
    canvasView.brushColor = [colorArray objectAtIndex:index];
}

- (IBAction)sendClicked
{
    [self sendData];
}

- (IBAction)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - URLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [recivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *recivedString = [[NSString alloc] initWithData:recivedData encoding:NSUTF8StringEncoding];
    
    if (recivedString == nil || recivedString.length == 0) {
        [self sendSuccess];
        return;
    }
    
    [self sendFailed];
}

@end
