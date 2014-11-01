//
//  TTImagePickerCollectionViewController.m
//  OneTalk
//
//  Created by that_is on 14-8-7.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import "TTImagePickerCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

//static BOOL expanded = NO;
static int *choosenFlags = NULL;

@interface TTImagePickerCollectionViewController ()

@property (assign, nonatomic) NSInteger seqNumber;

@end



@implementation TTImagePickerCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    free(choosenFlags);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    choosenFlags = (int *)malloc(sizeof(int) * [self.assets count]);
    memset(choosenFlags, 0, [self.assets count] * sizeof(BOOL));
    
//    self.view.frame = CGRectMake(0, 448, 320, 128);

    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.albumCollectionView = [[UICollectionView alloc]initWithFrame:self.view.frame
                                                    collectionViewLayout:flowLayout];
    
    
    //注册
    [self.albumCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"photocell"];
    //设置代理
    self.albumCollectionView.delegate = self;
    self.albumCollectionView.dataSource = self;
    [self.albumCollectionView reloadData];
    [self.albumCollectionView setBackgroundColor:[UIColor whiteColor]];

    
    [self.view addSubview:self.albumCollectionView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.albumCollectionView setScrollEnabled:NO];
    [self setExpanded:NO];

    [self.albumCollectionView addGestureRecognizer:pan];
    
    [self setSeqNumber:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDatasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.assets count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photocell" forIndexPath:indexPath];


    // load the asset for this cell
    ALAsset *asset = self.assets[indexPath.row];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    
    // apply the image to the cell
    UIImageView *imageView = [[UIImageView alloc]initWithImage:thumbnail];//[cell viewWithTag:1];
    [imageView setFrame:cell.contentView.frame];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [cell setClipsToBounds:YES];
//    [cell setContentMode:UIViewContentModeScaleAspectFill];
    [cell.contentView setContentMode:UIViewContentModeScaleAspectFit];
    [cell.contentView addSubview:imageView];
    
//    int i = indexPath.row;
//    for (UIView *view in [cell subviews]) {
//        if ([view isKindOfClass:[UILabel class]] && 0 == *(choosenFlags+i)) {
//            [view removeFromSuperview];
//            
//            NSInteger seq = [((UILabel *)view).text intValue];
//            [self.delegate didCancelImage:seq];
//
//            break;
//        }
//    }
//    
//    if (0 != *(choosenFlags+i)) {
//        UILabel *checkLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width/4, cell.frame.size.height/4)];
//        
//        [checkLabel.layer setCornerRadius:checkLabel.frame.size.width/2];
//        [checkLabel.layer setMasksToBounds:YES];
//        
//        [checkLabel setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.8]];
//        [checkLabel setTextColor:[UIColor blackColor]];
//        [checkLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
//        [checkLabel setTextAlignment:NSTextAlignmentCenter];
//        [checkLabel setAdjustsFontSizeToFitWidth:YES];
//        
//        if (self.seqNumber > 9) {
//            [checkLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
//        }
//        
//        [checkLabel setText:[NSString stringWithFormat:@"%ld",(long)self.seqNumber]];
//        [cell addSubview:checkLabel];
//    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(72, 72);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    for (UIView *view in [cell subviews]) {
        if ([view isKindOfClass:[UILabel class]]) {
            return;
        }
    }
    
    ALAsset *asset = self.assets[indexPath.row];
    CGImageRef fullScreenImageRef = [[asset defaultRepresentation]fullScreenImage];
    UIImage *fullScreenImage = [UIImage imageWithCGImage:fullScreenImageRef];
    
    [self.delegate didChooseImage:fullScreenImage];
    
    
    
//    UILabel *checkLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width/4, cell.frame.size.height/4)];
//
//    [checkLabel.layer setCornerRadius:checkLabel.frame.size.width/2];
//    [checkLabel.layer setMasksToBounds:YES];
//
//    [checkLabel setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.8]];
//    [checkLabel setTextColor:[UIColor blackColor]];
//    [checkLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
//    [checkLabel setTextAlignment:NSTextAlignmentCenter];
//    [checkLabel setAdjustsFontSizeToFitWidth:YES];
//    
//    if (self.seqNumber > 9) {
//        [checkLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
//    }
//
//    [checkLabel setText:[NSString stringWithFormat:@"%ld",(long)self.seqNumber]];
//    
//    *(choosenFlags+indexPath.row) = self.seqNumber;

    self.seqNumber++;
    
//    [cell addSubview:checkLabel];
}

#pragma mark - UIScrollViewdelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (nil == self.delegate)
    {
        return;
    }

    
    if (![self.delegate respondsToSelector:@selector(shouldResizeView:toExpand:)]) {
        NSLog(@"self. delegte not responding");
        return;
    }


    if (scrollView.contentOffset.y > 0 && NO == self.expanded) {
        [self.delegate shouldResizeView:self.view toExpand:YES];
        [self setExpanded:YES];
        [self.albumCollectionView setScrollEnabled:YES];
        return;
    }
    if (-scrollView.contentOffset.y / self.view.frame.size.height > 0.03
        && YES == self.expanded) {

        [self.delegate shouldResizeView:self.view toExpand:NO];
        [self setExpanded:NO];
        [self.albumCollectionView setScrollEnabled:NO];
        return;
    }
    
}

static CGPoint initPoint;
static CGFloat originY = 538;
static CGFloat threshold = 100;

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint curPoint = [gestureRecognizer locationInView:self.view];
    int y = curPoint.y - initPoint.y;

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            initPoint = curPoint;
            break;
            
        case UIGestureRecognizerStateChanged:{
            if (y < 0) {
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + y, self.view.frame.size.width, self.view.frame.size.height)];
            }
            if (self.view.frame.origin.y < originY - threshold) {

                [self.delegate shouldResizeView:self.view toExpand:YES];
                [self setExpanded:YES];
                [self.albumCollectionView setScrollEnabled:YES];

                [gestureRecognizer requireGestureRecognizerToFail:self.albumCollectionView.panGestureRecognizer];

            }

            break;
        }
        case UIGestureRecognizerStateEnded:{
            if (y > -threshold && y <= 0/*self.view.frame.origin.y >= 448-100*/) {
                [self.delegate shouldResizeView:self.view toExpand:NO];
                [self setExpanded:NO];
                [self.albumCollectionView setScrollEnabled:NO];

            }
        }
        default:
            break;
    }
}


@end
