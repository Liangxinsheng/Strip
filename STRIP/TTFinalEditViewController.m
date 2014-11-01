//
//  TTFinalEditViewController.m
//  STRIP
//
//  Created by that_is on 14-8-21.
//  Copyright (c) 2014年 Tuto. All rights reserved.
//

#import "TTFinalEditViewController.h"

#import "TTTakePicturesViewController.h"

#import "MJCollectionViewCell.h"
#import "WeiboSDK.h"

@interface MJCollectionViewCell ()

//@property (strong, nonatomic) UILabel *captionLabel;
//@property (strong, nonatomic) UITextField *captionField;
//@property (assign, nonatomic) TTOneFrameData *dataSource;

@end

@interface TTFinalEditViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UICollectionView *parallaxCollectionView;
@property (nonatomic, strong) NSMutableArray* images;

@end

@implementation TTFinalEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Fill image array with images
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePictureToAlbum:)];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 40, 40)];
    [title setText:@"Share"];
    
    UITapGestureRecognizer *tapOnTitle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sharePictureOnWeibo:)];
    
    [title addGestureRecognizer:tapOnTitle];
    [title setUserInteractionEnabled:YES];
    [title setTextColor:[UIColor blueColor]];

    self.navigationItem.titleView = title;
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.parallaxCollectionView = [[UICollectionView alloc]initWithFrame:self.view.frame
                                                 collectionViewLayout:flowLayout];
    
    
    //注册
    [self.parallaxCollectionView registerClass:[MJCollectionViewCell class] forCellWithReuseIdentifier:@"MJCell"];
    [self.parallaxCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [self.parallaxCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
    //设置代理
    self.parallaxCollectionView.delegate = self;
    self.parallaxCollectionView.dataSource = self;
    [self.parallaxCollectionView reloadData];
    
    [self.parallaxCollectionView reloadData];
    [self.parallaxCollectionView setBackgroundColor:[UIColor whiteColor]];
//    [self.parallaxCollectionView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg.jpg"]]];
    [self.view addSubview:self.parallaxCollectionView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.parallaxCollectionView addGestureRecognizer:longPress];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeftGestureRecognized:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.parallaxCollectionView addGestureRecognizer:swipeLeft];
}

- (void)dealloc
{
    [self.parallaxCollectionView setDelegate:nil];
    [self.parallaxCollectionView setDataSource:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDatasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stripData.frameData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MJCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MJCell" forIndexPath:indexPath];
    
    cell.dataSource = (TTOneFrameData *)[self.stripData.frameData objectAtIndex:indexPath.item];
    
    cell.image = cell.dataSource.picture;
    
    //set offset accordingly
    CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    
    [cell.captionField setDelegate:self];
    [cell.captionField setUserInteractionEnabled:NO];
    
    if (nil != cell.dataSource.caption && cell.dataSource.caption.length > 0) {
        [cell.captionLabel setAlpha:1];
        [cell.captionField setText:cell.dataSource.caption];
    }
    else{
        [cell.captionLabel setAlpha:0];
        [cell.captionField setText:nil];
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header_bg_white.png"]];
        [background setFrame:header.frame];
        [header addSubview:background];
        
        UITextField *field = [[UITextField alloc]initWithFrame:header.frame];
        
        [field setTextAlignment:NSTextAlignmentCenter];
        [field setBackgroundColor:[UIColor clearColor]];
        [field setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [field.layer setMasksToBounds:NO];
        [field setTextColor:[UIColor blackColor]];
        
        [field setReturnKeyType:UIReturnKeyDone];
        [field setKeyboardType:UIKeyboardTypeDefault];
        [field setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        if (0 == self.stripData.title.length) {
            [field setPlaceholder:@"Input Title"];
        }
        else{
            [field setText:self.stripData.title];
        }
        
        [field setDelegate:self];
        
        [header addSubview:field];
        
        return header;
    }
    else{
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        
        UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.jpg"]];
        [background setFrame:footer.frame];
        
        return footer;
    }
}

#pragma mark  - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize headerViewSize = CGSizeMake(320, 67);
    
    return headerViewSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize footerViewSize = CGSizeMake(320, 10);
    return footerViewSize;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MJCollectionViewCell *cell = (MJCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ((indexPath.item + 1) == [self collectionView:collectionView numberOfItemsInSection:1]) {
        [UIView animateWithDuration:0.5f animations:^{
            [self.parallaxCollectionView setFrame:CGRectMake(self.parallaxCollectionView.frame.origin.x, self.parallaxCollectionView.frame.origin.y, self.parallaxCollectionView.frame.size.width, cell.frame.size.height)];
        }];
    }
    
    if (nil == cell.captionLabel) {
        NSLog(@"nil == cel.captionLabel");
    }
    [cell.captionLabel setAlpha:1];
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];

    [cell.captionField setUserInteractionEnabled:YES];
    [cell.captionField becomeFirstResponder];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 300);
}

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (nil == self.parallaxCollectionView) {
        NSLog(@"nil == self.parallaxCollectionView");
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [textField setPlaceholder:nil];
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];
        [textField setUserInteractionEnabled:NO];
        
        if ([[textField superview]isKindOfClass:[MJCollectionViewCell class]]) {
            MJCollectionViewCell *cell = (MJCollectionViewCell *)[textField superview];
            
            if (0 == [textField.text length]) {
                [cell.captionLabel setAlpha:0];
            }
            else{
                [cell.captionLabel setAlpha:1];
            }
            [cell.dataSource setCaption:textField.text];
        }
        
        if ([[textField superview]isKindOfClass:[UICollectionReusableView class]]) {
            [self.stripData setTitle:textField.text];
        }

        [UIView animateWithDuration:0.5f animations:^{
            [self.parallaxCollectionView setFrame:self.view.frame];
        }];
    }

    if (textField.text.length == 0) {
        [textField setUserInteractionEnabled:YES];
    }
    return YES;
}

#pragma mark - selectors
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)gesture
{
    UIGestureRecognizerState state = gesture.state;
    
    CGPoint location = [gesture locationInView:self.parallaxCollectionView];
    NSIndexPath *indexPath = [self.parallaxCollectionView indexPathForItemAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UICollectionViewCell *cell = [self.parallaxCollectionView cellForItemAtIndexPath:indexPath];
                

                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.parallaxCollectionView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Black out.
                    cell.backgroundColor = [UIColor blackColor];
                } completion:nil];
                [cell setBackgroundColor:[UIColor whiteColor]];
                [cell setAlpha:0];

            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.stripData.frameData exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.

                [self.parallaxCollectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                [self.parallaxCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
                
                UICollectionViewCell *cell = [self.parallaxCollectionView cellForItemAtIndexPath:indexPath];
                [cell setAlpha:0];

                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            // Clean up.
            UICollectionViewCell *cell = [self.parallaxCollectionView cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo the black-out effect we did.
                cell.backgroundColor = [UIColor whiteColor];
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
            [cell setAlpha:1];
            break;
        }
    }
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (void)swipeLeftGestureRecognized:(UISwipeGestureRecognizer *)gesture
{
    UIGestureRecognizerState state = gesture.state;
    
    CGPoint location = [gesture locationInView:self.parallaxCollectionView];
    NSIndexPath *indexPath = [self.parallaxCollectionView indexPathForItemAtPoint:location];
    
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:{
            break;
        }
        case UIGestureRecognizerStateEnded:{
            UICollectionViewCell *cell = [self.parallaxCollectionView cellForItemAtIndexPath:indexPath];
            [UIView animateWithDuration:0.5f
                             animations:^{
                                 [cell setFrame:CGRectMake(- cell.frame.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
                             }
                             completion:^(BOOL finished){
                                 if (nil == indexPath) {
                                     NSLog(@"indexPath == nil");
                                     return;
                                 }
                                 [cell setAlpha:0];
                                 [self.stripData.frameData removeObjectAtIndex:indexPath.row];
                                 NSArray *array = [NSArray arrayWithObject:indexPath];
                                 [self.parallaxCollectionView deleteItemsAtIndexPaths:array];

                                 for (UIViewController *ctrl in [self.navigationController viewControllers]) {
                                     if ([ctrl isKindOfClass:[TTTakePicturesViewController class]]) {
                                         TTTakePicturesViewController *takeCtrl = (TTTakePicturesViewController *)ctrl;
                                         NSLog(@"indexPath.item in FinalView to be deleted:%ld",(long)indexPath.item);
                                         NSArray *array = [NSArray arrayWithObject:indexPath];
                                         [takeCtrl.parallaxCollectionView deleteItemsAtIndexPaths:array];
                                         [takeCtrl.parallaxCollectionView reloadData];
                                     }
                                 }
                             }];

        }
        default:
            break;
    }
}

- (void)savePictureToAlbum:(id)sender
{
    UIImage *image = [self captureScrollView:self.parallaxCollectionView];
    UIImageWriteToSavedPhotosAlbum(image,self, nil, nil);
    
    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"Saved" message:@"Strip is saved to album" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alerView show];
}

- (void)sharePictureOnWeibo:(id)sender
{
    UIImage *image = [self captureScrollView:self.parallaxCollectionView];
    UIImageWriteToSavedPhotosAlbum(image,self, nil, nil);
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    WBMessageObject *msgObject = [WBMessageObject message];
    msgObject.text = @"Strip - The New Way to Tell Your Stories @TutoLab";
    
    msgObject.imageObject = [WBImageObject object];
    msgObject.imageObject.imageData = UIImageJPEGRepresentation(image, 0.5f);

    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:msgObject];
    
    [WeiboSDK sendRequest:request];
}

- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}
@end
