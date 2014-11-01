//
//  MJCollectionViewCell.h
//  RCCPeakableImageSample
//
//  Created by Mayur on 4/1/14.
//  Copyright (c) 2014 RCCBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTakePicturesViewController.h"

#define IMAGE_HEIGHT 300
#define IMAGE_OFFSET_SPEED 0

@interface MJCollectionViewCell : UICollectionViewCell

/*
 
 image used in the cell which will be having the parallax effect
 
 */
@property (nonatomic, strong, readwrite) UIImage *image;

@property (nonatomic, copy) NSString *caption;

/*
 Image will always animate according to the imageOffset provided. Higher the value means higher offset for the image
 */
@property (nonatomic, assign, readwrite) CGPoint imageOffset;

@property (nonatomic, assign, readwrite) NSInteger seqNumber;

@property (assign, nonatomic) TTOneFrameData *dataSource;
@property (strong, nonatomic) UITextField *captionField;
@property (nonatomic, strong, readwrite) UILabel *captionLabel;


- (void)setupTextField;

@end
