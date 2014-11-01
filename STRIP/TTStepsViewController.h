//
//  TTStepsViewController.h
//  OneTalk
//
//  Created by that_is on 14-7-10.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTStepsViewController;
@protocol TTStepViewControllerDelegate <NSObject>

-(void) stepsViewControllerDidDismissView:(TTStepsViewController *)viewController;

@end

@interface TTStepsViewController : UIViewController
@property (nonatomic, weak) id<TTStepViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *imgUrls;
@property (nonatomic, strong) NSMutableArray *texts;
@property (nonatomic, strong) NSMutableArray *stepViews;

@end