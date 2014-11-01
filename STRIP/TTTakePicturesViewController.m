//
//  TTTakePicturesViewController.m
//  OneTalk
//
//  Created by that_is on 14-7-29.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import "TTTakePicturesViewController.h"
#import "TTCamera.h"
#import "MJCollectionViewCell.h"

#import "TTStepsViewControllerModelA.h"
#import "TTFinalEditViewController.h"

#import "UIImage+Resize.h"
#import <UIImage+BlurredFrame.h>

@interface TTTakePicturesViewController() <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *images;
@property (assign, nonatomic) BOOL paraViewExpanded;

@property (strong, nonatomic) UICollectionView *photoLibCollectionView;
@property (assign, nonatomic) BOOL photoLibViewExpanded;

@property (assign, nonatomic) NSInteger curSeq;

@end

@implementation TTTakePicturesViewController 


- (id)init
{
    self  = [super init];
    self.imgPkerVC = [[TTImagePickerCollectionViewController alloc]init];
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (TTStripData *)prepareDataSource
{
    TTStripData *dataSource = [[TTStripData alloc]init];
    dataSource.frameData = [NSMutableArray arrayWithCapacity:0];
    return dataSource;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (nil == self.dataSource) {
        self.dataSource = [self prepareDataSource];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self setCurSeq:1];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next >" style:UIBarButtonItemStylePlain target:self action:@selector(gotoEditView)];
    [self navigationController].toolbarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    CGFloat bottomViewHeight = 70.f;
    CGRect rootFrame = self.view.frame;
    CGFloat topContainerHight = rootFrame.size.height - rootFrame.size.width - bottomViewHeight;
    _topContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rootFrame.size.width, topContainerHight)];
    _topContainerView.backgroundColor = [UIColor clearColor];
    
    _middleContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, topContainerHight, rootFrame.size.width, rootFrame.size.width)];
    
    _bottomContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, topContainerHight + _middleContainerView.frame.size.height, rootFrame.size.width, bottomViewHeight)];
    
//    [self.view addSubview:_topContainerView];
    [self.view addSubview:_bottomContainerView];
    [self.view addSubview:_middleContainerView];

    
    [TTCamera startRunning];
    [TTCamera embedPreviewInView:_middleContainerView];
    
    UIButton *takePictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [takePictureButton setFrame:CGRectMake(0, 0, 60, 60)];
    [takePictureButton setBackgroundColor:[UIColor whiteColor]];
    [takePictureButton.layer setCornerRadius:30];
    [takePictureButton.layer setBorderColor:[UIColor blackColor].CGColor];
    [takePictureButton.layer setBorderWidth:1.f];
    [takePictureButton setCenter:CGPointMake(_middleContainerView.frame.size.width/2, _middleContainerView.frame.size.height-takePictureButton.frame.size.height/2)];
    [takePictureButton addTarget:self action:@selector(takePictureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [takePictureButton setTag:100];
    [_middleContainerView addSubview:takePictureButton];

    
    
    
//    if(!self.images)
//        self.images = [NSMutableArray arrayWithCapacity:0];

    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.parallaxCollectionView = [[UICollectionView alloc]initWithFrame:_topContainerView.frame collectionViewLayout:flowLayout];
    //注册
    [self.parallaxCollectionView registerClass:[MJCollectionViewCell class] forCellWithReuseIdentifier:@"MJCell"];
    //设置代理
    self.parallaxCollectionView.delegate = self;
    self.parallaxCollectionView.dataSource = self;
    
    _paraViewExpanded = NO;
    [self.parallaxCollectionView setBackgroundColor:[UIColor clearColor]];

//    [self.topContainerView addSubview:self.parallaxCollectionView];
    [self.view addSubview:self.parallaxCollectionView];
    


    __weak id weakSelf = self;
    [self.imgPkerVC setDelegate:weakSelf];
    [self.imgPkerVC.view setFrame:_bottomContainerView.frame];
    [self.view addSubview:self.imgPkerVC.view];
    [self addChildViewController:self.imgPkerVC];


    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanOnParaView:)];
    [self.parallaxCollectionView setScrollEnabled:NO];
    [self setParaViewExpanded:NO];
    
    [self.parallaxCollectionView addGestureRecognizer:pan];
    
    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectionTouched:)];
//    [self.parallaxCollectionView addGestureRecognizer:singleTap];
//    
    UITapGestureRecognizer *singleTapOnCamera = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cameraTouched:)];
    [_middleContainerView addGestureRecognizer:singleTapOnCamera];
//
//    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
//    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
//    [self.view addGestureRecognizer:swipeDown];
//    
//    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
//    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
//    [self.view addGestureRecognizer:swipeUp];
    
    


//    UITapGestureRecognizer *swipeRight = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRightOnParaView:)];
//    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
//    [swipeRight requireGestureRecognizerToFail:self.parallaxCollectionView.panGestureRecognizer];
//    [self.parallaxCollectionView addGestureRecognizer:swipeRight];
}


- (void)handleSwipeRightOnParaView:(UISwipeGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.parallaxCollectionView];
    NSIndexPath *indexPath = [self.parallaxCollectionView indexPathForItemAtPoint:location];
    
    MJCollectionViewCell *cell = (MJCollectionViewCell *)[self.parallaxCollectionView cellForItemAtIndexPath:indexPath];
    
    [cell setupTextField];
}

static CGPoint initPoint;
static int threshold = 100;
- (void)handlePanOnParaView:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint curPoint = [gestureRecognizer locationInView:self.parallaxCollectionView];
    int y = curPoint.y - initPoint.y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            initPoint = curPoint;
            break;
            
        case UIGestureRecognizerStateChanged:{
            if (y > 0  && y < threshold && NO == self.paraViewExpanded) {
                [self.parallaxCollectionView setFrame:CGRectMake(self.parallaxCollectionView.frame.origin.x, self.parallaxCollectionView.frame.origin.y, self.parallaxCollectionView.frame.size.width, self.parallaxCollectionView.frame.size.height  + y)];
            }
            if (y < 0 && YES == self.paraViewExpanded) {
//                [self shouldResizeView:self.parallaxCollectionView toExpand:NO];
            }

            if (self.parallaxCollectionView.frame.size.height > _topContainerView.frame.size.height + threshold) {

                [self shouldResizeView:self.parallaxCollectionView toExpand:YES];
                [self setParaViewExpanded:YES];
                [self.parallaxCollectionView setScrollEnabled:YES];
                
                [gestureRecognizer requireGestureRecognizerToFail:self.parallaxCollectionView.panGestureRecognizer];
                
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if (y >= 0 && y < threshold && self.parallaxCollectionView.frame.size.height < _topContainerView.frame.size.height + threshold/*self.view.frame.origin.y >= 448-100*/) {

                [self shouldResizeView:self.parallaxCollectionView toExpand:NO];
                [self setParaViewExpanded:NO];
                [self.parallaxCollectionView setScrollEnabled:NO];
                
            }
        }
        default:
            break;
    }
}

- (void)takePictureButtonClicked:(id)sender
{
    [TTCamera captureStillImage];
    
    if (nil == [TTCamera image]) {
        sleep(1);
    }
    [TTCamera stopRunning];
    
    UIImage *image = [[TTCamera image]copy];
    UIImageWriteToSavedPhotosAlbum(image,self, nil, nil);

//    UIImageView *imgView = [[UIImageView alloc]initWithFrame:_middleContainerView.frame];
//
//    [imgView setImage:image];
//    [imgView setClipsToBounds:YES];
//    [imgView setContentMode:UIViewContentModeScaleAspectFill];
//    [self.view addSubview:imgView];
//    
//    [UIView animateWithDuration:0.5f animations:^{
//        CGRect upFrame = imgView.frame;
//        upFrame.origin.y = _middleContainerView.frame.origin.y - _middleContainerView.frame.size.height;
//        imgView.frame = upFrame;
//        
//    }];
    [TTCamera startRunning];
    
    TTOneFrameData *oneFrame = [[TTOneFrameData alloc]init];
    [oneFrame setPicture:image];
    [oneFrame setSequence:self.curSeq];
    [oneFrame setCaption:nil];
    
    [self.dataSource.frameData addObject:oneFrame];
//    self.dataSource.frameNumber = [self.dataSource.frameData count];
    
//    assert([self.dataSource.frameData count] == self.curSeq);
    self.curSeq++;
//    [self.images addObject:image];
    [self.parallaxCollectionView reloadData];
    
    NSInteger section = [self numberOfSectionsInCollectionView:self.parallaxCollectionView] - 1;
    NSInteger item = [self collectionView:self.parallaxCollectionView numberOfItemsInSection:section] - 1;
    NSIndexPath*  lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    
    
    [self.parallaxCollectionView scrollToItemAtIndexPath:lastIndexPath
                                        atScrollPosition:UICollectionViewScrollPositionBottom
                                                animated:YES];
}

- (void)collectionTouched:(id)sender
{

}

- (void)cameraTouched:(id)sender
{
//    if (YES == _paraViewExpanded){
//        [self collectionTouched:sender];
//    }
    if (YES == self.paraViewExpanded) {
        [self shouldResizeView:self.parallaxCollectionView toExpand:NO];
        [self setParaViewExpanded:NO];
        [self.parallaxCollectionView setScrollEnabled:NO];
    }

//    [self shouldResizeView:self.imgPkerVC.view toExpand:NO];
//    [self.imgPkerVC setExpanded:NO];
//    [self.imgPkerVC.albumCollectionView setScrollEnabled:NO];
}

- (void)swipeDown:(id)sender
{
    if (0 == [self.dataSource.frameData count]) {
        return;
    }
//    [self collectionTouched:sender];
}

- (void)swipeUp:(id)sender
{
}

#pragma mark - UICollectionViewDatasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource.frameData count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MJCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MJCell" forIndexPath:indexPath];

    NSLog(@"indexPath.item = %ld", (long)indexPath.item);
    if (indexPath.item >= [self.dataSource.frameData count]) {
        NSArray *array = [NSArray arrayWithObject:indexPath];
        [self.parallaxCollectionView deleteItemsAtIndexPaths:array];
        [self.parallaxCollectionView reloadData];
        return cell;
    }
    TTOneFrameData *oneFrameData = (TTOneFrameData *)[self.dataSource.frameData objectAtIndex:indexPath.item];
    
    if (nil == oneFrameData) {
        return nil;
    }

    UIImage *image = oneFrameData.picture;

    cell.image = image;
    //get image name and assign
    //    NSString* imageName = [self.images objectAtIndex:indexPath.item];
    //    cell.image = [UIImage imageNamed:imageName];
    
    //set offset accordingly
    CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    
    if (nil != cell.captionField) {
        [cell.captionField removeFromSuperview];
    }
    if (nil != cell.captionLabel) {
        [cell.captionLabel removeFromSuperview];
    }
    
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.parallaxCollectionView.frame.size.width, IMAGE_HEIGHT);
}

//static int lastPosition = 0;

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(MJCollectionViewCell *view in self.parallaxCollectionView.visibleCells) {
        CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }

    float height = scrollView.contentSize.height > self.parallaxCollectionView.frame.size.height ? self.parallaxCollectionView.frame.size.height : scrollView.contentSize.height;
    if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.15
        && YES == self.paraViewExpanded) {
        [self shouldResizeView:self.parallaxCollectionView toExpand:NO];
        [self setParaViewExpanded:NO];
        [self.parallaxCollectionView setScrollEnabled:NO];
        return;
    }
    


//    int currentPostion = scrollView.contentOffset.y;
//
//    if (lastPosition - currentPostion > 25)
//    {
//        lastPosition = currentPostion;
//        if (NO == self.paraViewExpanded) {
//            [self shouldResizeView:self.parallaxCollectionView toExpand:YES];
//            [self setParaViewExpanded:YES];
//            [self.parallaxCollectionView setScrollEnabled:YES];
//        }
//        NSLog(@"ScrollDown now");
//        return;
//    }

    
}

#pragma mark - TTImagePickerDelegate methods

- (void)didChooseImage:(UIImage *)img
{
    TTOneFrameData *oneFrame = [[TTOneFrameData alloc]init];
    [oneFrame setPicture:img];
    [oneFrame setSequence:self.curSeq];
    [oneFrame setCaption:nil];
    
    [self.dataSource.frameData addObject:oneFrame];
//    self.dataSource.frameNumber = [self.dataSource.frameData count];
    
//    assert([self.dataSource.frameData count] == self.curSeq);
    self.curSeq++;
//    [self.images addObject:img];
    [self.parallaxCollectionView reloadData];
    
    NSInteger section = [self numberOfSectionsInCollectionView:self.parallaxCollectionView] - 1;
    NSInteger item = [self collectionView:self.parallaxCollectionView numberOfItemsInSection:section] - 1;
    NSIndexPath*  lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    
    
    [self.parallaxCollectionView scrollToItemAtIndexPath:lastIndexPath
                                        atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                                animated:YES];
}

- (void)didCancelImage:(NSInteger)seq
{

}


- (void)shouldResizeView:(UIView *)view toExpand:(BOOL)expand
{
    if (view == self.imgPkerVC.view) {
        if (YES == expand) {
            CGRect finalFrameForParentView = CGRectMake(_middleContainerView.frame.origin.x, _middleContainerView.frame.origin.y, _middleContainerView.frame.size.width, _bottomContainerView.frame.size.height +  _middleContainerView.frame.size.height);
            
            if (!CGRectEqualToRect(self.imgPkerVC.view.frame, finalFrameForParentView)) {
                [UIView animateWithDuration:0.5f animations:^{
                    [self.imgPkerVC.view setFrame:finalFrameForParentView];
                }];
            }
            
            _photoLibViewExpanded = YES;
        }
        else
        {
            if (!CGRectEqualToRect(self.imgPkerVC.view.frame, _bottomContainerView.frame)) {
                [UIView animateWithDuration:0.5f animations:^{
                    [self.imgPkerVC.view setFrame:_bottomContainerView.frame];
                }];
            }
            
            _photoLibViewExpanded = NO;
        }
    }
    else if (view == self.parallaxCollectionView)
    {
        if (YES == expand){
            if ([self.dataSource.frameData count] > 1){
                [UIView animateWithDuration:0.5f animations:^{
                    CGRect finalFrame = CGRectMake(0, 0, _topContainerView.frame.size.width, _topContainerView.frame.size.height +  _middleContainerView.frame.size.height);
                    self.parallaxCollectionView.frame = finalFrame;
                }];
            }
            else{
                [UIView animateWithDuration:0.5f animations:^{
                    CGRect finalFrame = CGRectMake(0, 0, _topContainerView.frame.size.width, _middleContainerView.frame.size.height);
                    self.parallaxCollectionView.frame = finalFrame;
                }];
            }
            
            NSInteger section = [self numberOfSectionsInCollectionView:self.parallaxCollectionView] - 1;
            NSInteger item = [self collectionView:self.parallaxCollectionView numberOfItemsInSection:section] - 1;
            
            if (item < 0) {
                return;
            }
            
            NSIndexPath*  lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            
            
            [self.parallaxCollectionView scrollToItemAtIndexPath:lastIndexPath
                                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                                        animated:YES];
            
            _paraViewExpanded = YES;
        }
        else{

            [UIView animateWithDuration:0.5f animations:^{
                CGRect finalFrame = _topContainerView.frame;
                self.parallaxCollectionView.frame = finalFrame;
            }];
            
            NSInteger section = [self numberOfSectionsInCollectionView:self.parallaxCollectionView] - 1;
            NSInteger item = [self collectionView:self.parallaxCollectionView numberOfItemsInSection:section] - 1;
            NSIndexPath*  lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            [self.parallaxCollectionView scrollToItemAtIndexPath:lastIndexPath
                                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                                        animated:YES];
            
            _paraViewExpanded = NO;
        }
    }
    else
    {
        NSLog(@"Iput wrong view, the view should be imgPkerVC.view");
        return;
    }


}

- (void)gotoEditView
{
    TTFinalEditViewController *finalVC = [[TTFinalEditViewController alloc]init];
    
    finalVC.stripData = self.dataSource;
    
    [[self navigationController] pushViewController:finalVC animated:YES];
}


@end

@implementation TTOneFrameData


@end

@implementation TTStripData


@end