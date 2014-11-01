//
//  TTAppDelegate.h
//  STRIP
//
//  Created by that_is on 14-8-9.
//  Copyright (c) 2014年 Tuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTMainViewController.h"
#import "WeiboSDK.h"

@interface TTAppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *mainViewCtrl;

@end
