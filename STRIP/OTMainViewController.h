//
//  OTMainViewController.h
//  OneTalk
//
//  Created by that_is on 14-4-2.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTStepsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface OTMainViewController : UIViewController <TTStepViewControllerDelegate>

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@end
