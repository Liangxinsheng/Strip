//
//  TTSingleStepViewControllerModelA.m
//  OneTalk
//
//  Created by that_is on 14-7-20.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import "TTSingleStepViewControllerModelA.h"
#import <UIImage+BlurredFrame.h>

@implementation TTSingleStepViewControllerModelA

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if (nil == self.imgUrl) {
        NSLog(@"self.imgUrl == Nil");
        return;
    }

    self.srcImage = [UIImage imageNamed:self.imgUrl];
    self.imgView = [[UIImageView alloc] initWithFrame:self.frmSize];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgView setClipsToBounds:YES];
    [self.imgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [self.imgView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouched:)];
    [self.imgView addGestureRecognizer:singleTap];
    


    self.stepTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frmSize.size.height - 40, self.frmSize.size.width, 40)];
    [self.stepTextLabel setBackgroundColor:[UIColor clearColor]];
    [self.stepTextLabel setTextColor:[UIColor whiteColor]];
    [self.stepTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [self.stepTextLabel setTextAlignment:NSTextAlignmentCenter];
    [self.stepTextLabel setAdjustsFontSizeToFitWidth:YES];
    [self.stepTextLabel setNumberOfLines:0];
    [self.stepTextLabel setText:[NSString stringWithFormat:@"STEP #%ld Hard Training Hard Training  Training  TrainingTraining Training Training Training Training", (long)self.seqNumber]];

//    self.imgWithBlurredFrame = [self.srcImage applyLightEffectAtFrame:CGRectMake(0, self.srcImage.size.height * (1 - 40/self.frmSize.size.height), self.srcImage.size.width, self.srcImage.size.height * (40/self.frmSize.size.height))];
    self.imgWithBlurredFrame = [self.srcImage applyBlurWithRadius:5
                                                        tintColor:[UIColor colorWithWhite:1 alpha:0.2]
                                            saturationDeltaFactor:1.8
                                                        maskImage:nil
                                                          atFrame:CGRectMake(self.srcImage.size.width * (self.stepTextLabel.frame.origin.x/self.frmSize.size.width),
                                                                             self.srcImage.size.height * (self.stepTextLabel.frame.origin.y/self.frmSize.size.height),
                                                                             self.srcImage.size.width * (self.stepTextLabel.frame.size.width/self.frmSize.size.width),
                                                                             self.srcImage.size.height * (self.stepTextLabel.frame.size.height/self.frmSize.size.height))];
    [self.imgView setImage:self.imgWithBlurredFrame];

    [self.imgView addSubview:self.stepTextLabel];
    [self.view addSubview:self.imgView];
    [self becomeFirstResponder];
}

- (void)imageTouched:(id)sender
{
    NSLog(@"Image Touched");
    if (self.stepTextLabel.isHidden == YES)
    {
        [self.stepTextLabel setHidden: NO];
        [self.imgView setImage:self.imgWithBlurredFrame];
    }
    else
    {
        [self.stepTextLabel setHidden: YES];
        [self.imgView setImage:self.srcImage];
    }

}
@end
