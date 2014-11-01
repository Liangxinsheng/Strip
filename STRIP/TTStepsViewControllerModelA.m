//
//  TTStepsViewControllerModelA.m
//  OneTalk
//
//  Created by that_is on 14-7-24.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import "TTStepsViewControllerModelA.h"
#import "TTSingleStepViewControllerModelA.h"
#import "TTSingleStepViewControllerModelB.h"
#import <UIImageView+LBBlurredImage.h>

@interface TTStepsViewControllerModelA()

@property (strong, nonatomic) UIScrollView *scrlView;

@end

@implementation TTStepsViewControllerModelA

- (void) viewDidLoad
{
    [super viewDidLoad];
    CGFloat widthShift = 20;
    CGFloat hightShift = 40;

    // Do any additional setup after loading the view.
    CGRect rootFrame = [UIScreen mainScreen].bounds;
    CGRect viewFrame = CGRectMake(widthShift, hightShift, rootFrame.size.width - 2 * widthShift, rootFrame.size.height - 2 * hightShift);

    UIImage *bgImage = [UIImage imageNamed:@"Brasil_4.jpg"];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:rootFrame];
    [bgView setImage:bgImage];
//    [bgView setImageToBlur:bgImage blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:NULL];
    
    UIView *darkLayer = [[UIView alloc]initWithFrame:rootFrame];
    [darkLayer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    
    [bgView addSubview:darkLayer];

    [self.view addSubview:bgView];

    self.scrlView = [[UIScrollView alloc]initWithFrame:viewFrame];
    [self.scrlView setPagingEnabled:NO];
    [self.scrlView setContentSize:CGSizeMake(viewFrame.size.width, viewFrame.size.height * 5)];
    [self.scrlView setScrollsToTop:NO];
    [self.scrlView setUserInteractionEnabled:YES];
    [self.scrlView setPagingEnabled:NO];
    
    for (int i = 0; i < 5; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i * viewFrame.size.height, viewFrame.size.width, viewFrame.size.height)];
        NSString *imgUrl = [self.imgUrls objectAtIndex:i];
        TTSingleStepViewControllerModelA *sglViewCtrl =
        [[TTSingleStepViewControllerModelA alloc]initWithImageUrl:imgUrl
                                                        withFrame:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height)
                                                     withSequence:i + 1];
        [self addChildViewController:sglViewCtrl];
        [sglViewCtrl didMoveToParentViewController:self];
        [view addSubview:sglViewCtrl.view];
        [sglViewCtrl addObserver:self forKeyPath:@"current" options:NSKeyValueObservingOptionNew context:NULL];
        [self.scrlView addSubview:view];
    }
    
    
    [self.view addSubview:self.scrlView];
    
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton setFrame:CGRectMake(100, 20, 40, 20)];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setBackgroundColor:[UIColor whiteColor]];
    [saveButton addTarget:self action:@selector(savePictureToAlbum:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveButton];

}

- (void)savePictureToAlbum:(id)sender
{
    UIImage *image = [self captureScrollView:self.scrlView];
    UIImageWriteToSavedPhotosAlbum(image,self, nil, nil);
}

- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}
@end
