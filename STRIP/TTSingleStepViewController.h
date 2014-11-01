//
//  TTSingleStepViewController.h
//  OneTalk
//
//  Created by that_is on 14-7-23.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTSingleStepViewController : UIViewController

@property (nonatomic, strong) UILabel *stepTextLabel;
@property (nonatomic, strong) NSString *stepText;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) UIImage *srcImage;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, assign) CGRect frmSize;
@property (nonatomic, assign) NSInteger seqNumber;

- (id) initWithImageUrl:(NSString *)imgUrl withFrame:(CGRect)frame withSequence:(int)i;
@end