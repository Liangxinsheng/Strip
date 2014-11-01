//
//  TTFinalEditViewController.h
//  STRIP
//
//  Created by that_is on 14-8-20.
//  Copyright (c) 2014年 Tuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTakePicturesViewController.h"

@interface TTFinalEditViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) TTStripData *stripData;

@end

@interface UICollectionViewCell ()

@property (strong, nonatomic) UILabel *captionLabel;
@property (strong, nonatomic) UITextView *captionField;

@end