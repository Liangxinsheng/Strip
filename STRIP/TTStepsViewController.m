//
//  TTStepsViewController.m
//  OneTalk
//
//  Created by that_is on 14-7-10.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import "TTStepsViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "TTSingleStepViewControllerModelA.h"
#import "TTSingleStepViewControllerModelB.h"

@implementation TTStepsViewController

- (id)init
{
    self = [super init];
    self.imgUrls  = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i++) {
        NSString *imgUrl = [NSString stringWithFormat:@"Brasil_%d.jpg", i + 1];
        [self.imgUrls addObject:imgUrl];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(200, 20, 40, 20)];
    [button setTitle:@"Close" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];

    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)buttonClicked:(id)sender
{
    NSLog(@"Close button clicked");
    if (self.delegate && [self.delegate respondsToSelector:@selector(stepsViewControllerDidDismissView:)])
    {
        [self.delegate stepsViewControllerDidDismissView:self];
    }
}

@end
