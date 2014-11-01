//
//  TTFinalEditViewController.h
//  STRIP
//
//  Created by that_is on 14-8-21.
//  Copyright (c) 2014年 Tuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTakePicturesViewController.h"

#define kAppKey @"1491358987"
#define kRedirectURL @"https://api.weibo.com/oauth2/default.html"

@interface TTFinalEditViewController : UIViewController

@property (strong, nonatomic) TTStripData *stripData;

@end
