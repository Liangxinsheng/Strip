//
//  TTStepsViewControllerModeB.m
//  OneTalk
//
//  Created by that_is on 14-7-24.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import "TTStepsViewControllerModelB.h"
#import "TTSingleStepViewControllerModelA.h"
#import "TTSingleStepViewControllerModelB.h"
#import <UIImageView+LBBlurredImage.h>

@implementation TTStepsViewControllerModelB

- (void) viewDidLoad
{
    [super viewDidLoad];
    CGFloat widthShift = 20;
    CGFloat hightShift = 40;

    // Do any additional setup after loading the view.
    CGRect rootFrame = [UIScreen mainScreen].bounds;
    CGRect viewFrame = CGRectMake(widthShift, hightShift, rootFrame.size.width - 2 * widthShift, rootFrame.size.height - 2 * hightShift);
    self.view.backgroundColor = [UIColor lightGrayColor];

    UIImage *bgImage = [UIImage imageNamed:@"Brasil_5.jpg"];

    UIImageView *bgView = [[UIImageView alloc]initWithFrame:rootFrame];
    [bgView setImageToBlur:bgImage blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:NULL];
    [self.view addSubview:bgView];
    
    UIScrollView *scrlView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, hightShift, rootFrame.size.width, viewFrame.size.height)];
    [scrlView setPagingEnabled:NO];
    [scrlView setContentSize:CGSizeMake(rootFrame.size.width * 5, viewFrame.size.height)];
    [scrlView setScrollsToTop:NO];
    [scrlView setUserInteractionEnabled:YES];
    [scrlView setPagingEnabled:YES];
    
    for (int i = 0; i < 5; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i * rootFrame.size.width, 0, rootFrame.size.width, viewFrame.size.height)];
        NSString *imgUrl = [self.imgUrls objectAtIndex:i];
        TTSingleStepViewControllerModelB *sglViewCtrl =
        [[TTSingleStepViewControllerModelB alloc]initWithImageUrl:imgUrl
                                                        withFrame:CGRectMake(widthShift, 0, viewFrame.size.width, viewFrame.size.height)
                                                     withSequence:i + 1];
        [self addChildViewController:sglViewCtrl];
        [sglViewCtrl didMoveToParentViewController:self];
        [view addSubview:sglViewCtrl.view];
        [sglViewCtrl addObserver:self forKeyPath:@"current" options:NSKeyValueObservingOptionNew context:NULL];
        [scrlView addSubview:view];
    }
    
    
    [self.view addSubview:scrlView];
}

@end
