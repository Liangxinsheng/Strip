//
//  TTSingleStepViewController.m
//  OneTalk
//
//  Created by that_is on 14-7-23.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import "TTSingleStepViewController.h"

@implementation TTSingleStepViewController

- (id) initWithImageUrl:(NSString *)imgUrl withFrame:(CGRect)frame withSequence:(int)i
{
    self = [super init];
    if (nil != imgUrl) {
        [self setImgUrl:imgUrl];
    }
    if (nil != &frame) {
        self.frmSize = frame;
    }
    if (0 != i) {
        self.seqNumber = i;
    }
    return self;
}

@end
