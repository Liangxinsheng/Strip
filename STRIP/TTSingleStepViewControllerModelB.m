//
//  TTSingleStepViewControllerModelB.m
//  OneTalk
//
//  Created by that_is on 14-7-23.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import "TTSingleStepViewControllerModelB.h"
#import <UIImage+BlurredFrame.h>

@implementation TTSingleStepViewControllerModelB

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if (nil == self.imgUrl) {
        NSLog(@"self.imgUrl == Nil");
        return;
    }
    UIView *baseView = [[UIView alloc]initWithFrame:self.frmSize];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [baseView.layer setCornerRadius:20];
    [baseView.layer setMasksToBounds:YES];

    self.srcImage = [UIImage imageNamed:self.imgUrl];
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, self.frmSize.size.width, self.frmSize.size.width)];
    [self.imgView setImage:self.srcImage];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFill];

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frmSize.size.width, 40)];
    [title setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]];
    [title setTextColor:[UIColor blackColor]];
    [title setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setText:[NSString stringWithFormat:@"STEP #%ld", (long)self.seqNumber]];
    

    self.stepTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40 + self.frmSize.size.width, self.frmSize.size.width, self.frmSize.size.height - (40 + self.frmSize.size.width))];
    [self.stepTextLabel setBackgroundColor:[UIColor clearColor]];
    [self.stepTextLabel setTextColor:[UIColor blackColor]];
    [self.stepTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [self.stepTextLabel setTextAlignment:NSTextAlignmentCenter];
    [self.stepTextLabel setAdjustsFontSizeToFitWidth:YES];
    [self.stepTextLabel setText:[NSString stringWithFormat:@"Hard Training Hard Training"]];

    
    [self.imgView addSubview:self.stepTextLabel];
    [baseView addSubview:title];
    [baseView addSubview:self.imgView];
    [baseView addSubview:self.stepTextLabel];
    [self.view addSubview:baseView];
}

@end
