//
//  TTTakePicturesViewController.h
//  OneTalk
//
//  Created by that_is on 14-7-29.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTImagePickerCollectionViewController.h"
@interface TTOneFrameData : NSObject

@property (nonatomic, copy)   NSString *caption;
@property (nonatomic, assign) NSInteger sequence;
@property (nonatomic, strong) UIImage *picture;

@end

@interface TTStripData : NSObject

@property (nonatomic, copy)     NSString *title;
@property (nonatomic, assign)   NSInteger frameNumber;
@property (nonatomic, strong)   UIImage *finalPicture;
@property (nonatomic, strong)   NSMutableArray *frameData;

@end

@interface TTTakePicturesViewController : UIViewController <TTImagePickerDelegate>

@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) UIView *middleContainerView;
@property (nonatomic, strong) UIView *bottomContainerView;

@property (nonatomic, strong) TTImagePickerCollectionViewController *imgPkerVC;
@property (nonatomic, strong) TTStripData *dataSource;

@property (strong, nonatomic) UICollectionView *parallaxCollectionView;

@end


