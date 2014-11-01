//
//  TTImagePickerCollectionViewController.h
//  OneTalk
//
//  Created by that_is on 14-8-7.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol TTImagePickerDelegate <NSObject>

@required

- (void)didChooseImage:(UIImage *)img;
- (void)didCancelImage:(NSInteger) seq;

@optional

- (void)shouldResizeView:(UIView *)view toExpand:(BOOL)expand;


@end

@interface TTImagePickerCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@property (strong, nonatomic) UICollectionView *albumCollectionView;
@property (assign, nonatomic) BOOL expanded;

@property (nonatomic, strong) NSMutableArray* images;

@property (nonatomic, assign) id<TTImagePickerDelegate> delegate;

@end
