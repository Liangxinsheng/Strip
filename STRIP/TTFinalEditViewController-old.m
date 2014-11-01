//
//  TTFinalEditViewController.m
//  STRIP
//
//  Created by that_is on 14-8-20.
//  Copyright (c) 2014年 Tuto. All rights reserved.
//

#import "TTFinalEditViewController.h"
#import "MJCollectionViewCell.h"

@interface TTSingleFrameView : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation TTSingleFrameView

@end



@interface TTFinalEditViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) UICollectionView *finalPicturesView;

@end

@implementation TTFinalEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    __weak id weakSelf = self;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.finalPicturesView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 40) collectionViewLayout:flowLayout];
    //注册
    [self.finalPicturesView registerClass:[MJCollectionViewCell class] forCellWithReuseIdentifier:@"singleFrame"];
    //设置代理
    self.finalPicturesView.delegate = weakSelf;
    self.finalPicturesView.dataSource = weakSelf;
    
    [self.finalPicturesView reloadData];
    
    [self.view addSubview:self.finalPicturesView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [longPress setMinimumPressDuration:0.5f];
    [self.finalPicturesView addGestureRecognizer:longPress];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognized:)];
//    [self.finalPicturesView addGestureRecognizer:tap];
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

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.stripData.frameData count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TTOneFrameData *oneFrameData = [self.stripData.frameData objectAtIndex:indexPath.row];
    UIImage *img = oneFrameData.picture;
    
    MJCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"singleFrame" forIndexPath:indexPath];
    
    
    cell.image = img;
    //get image name and assign
    //    NSString* imageName = [self.images objectAtIndex:indexPath.item];
    //    cell.image = [UIImage imageNamed:imageName];
    
    //set offset accordingly
    CGFloat yOffset = ((self.finalPicturesView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    
    return cell;
    
//    if (nil == singleFrameView.imgView) {
//        singleFrameView.imgView = [[UIImageView alloc]init];
//    }
//    
//    [singleFrameView.imgView setImage:img];
//    [singleFrameView.imgView setFrame:singleFrameView.frame];
//    [singleFrameView.imgView setContentMode:UIViewContentModeScaleAspectFill];
//    [singleFrameView setClipsToBounds:YES];
    
    
//    singleFrameView.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, singleFrameView.frame.size.height - 40, singleFrameView.frame.size.width, 40)];
//    [singleFrameView.textField setDelegate:self];
//    [singleFrameView.textField setTextAlignment:NSTextAlignmentCenter];
//    [singleFrameView.textField setBackgroundColor:[UIColor clearColor]];
//    [singleFrameView.textField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
//    [singleFrameView.textField.layer setMasksToBounds:NO];
//    [singleFrameView.textField setTextColor:[UIColor blackColor]];
//    
//    [singleFrameView.textField setReturnKeyType:UIReturnKeyDone];
//    [singleFrameView.textField setKeyboardType:UIKeyboardTypeDefault];
//    [singleFrameView.textField setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
//    singleFrameView.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, singleFrameView.frame.size.height - 40, singleFrameView.frame.size.width, 40)];
//    [singleFrameView.textLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];
//    //    [self.captionLabel setTextColor:[UIColor whiteColor]];
//    [singleFrameView.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
//    //    [self.captionLabel setTextAlignment:NSTextAlignmentCenter];
//    [singleFrameView.textLabel setAdjustsFontSizeToFitWidth:YES];
//    [singleFrameView.textLabel setNumberOfLines:0];
    
    
    
//    [singleFrameView.textLabel setAlpha:0];
//    
//    [singleFrameView.imgView setTag:1];
//    [singleFrameView.textField setTag:2];
//    [singleFrameView.textLabel setTag:3];
//    
//    [singleFrameView addSubview:singleFrameView.imgView];
////    [singleFrameView addSubview:singleFrameView.textField];
//    [singleFrameView addSubview:singleFrameView.textLabel];
//    
//    
//    
//    [singleFrameView.textField becomeFirstResponder];
    
}

#pragma mark - UICollectionViewDelegate methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(280, 280);
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(MJCollectionViewCell *view in self.finalPicturesView.visibleCells) {
        CGFloat yOffset = ((self.finalPicturesView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}

#pragma mark - TTFinalEditViewController selectors

- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress
{
    
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.finalPicturesView];
    NSIndexPath *indexPath = [self.finalPicturesView indexPathForItemAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UICollectionViewCell *cell = [self.finalPicturesView cellForItemAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.finalPicturesView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Black out.
                    cell.backgroundColor = [UIColor blackColor];
                } completion:nil];
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
                [self.finalPicturesView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
//                UICollectionViewCell *cell = [self collectionView:self.finalPicturesView cellForItemAtIndexPath:indexPath];
//                [self.finalPicturesView scrollRectToVisible:cell.frame animated:YES];
                [self.finalPicturesView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];


                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            // Clean up.
            UICollectionViewCell *cell = [self.finalPicturesView cellForItemAtIndexPath:sourceIndexPath];
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


- (void)tapGestureRecognized:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.finalPicturesView];
    
    NSIndexPath *indexPath = [self.finalPicturesView indexPathForItemAtPoint:location];
    
    [self.finalPicturesView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.finalPicturesView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
    MJCollectionViewCell *cell = (MJCollectionViewCell *)[self collectionView:self.finalPicturesView cellForItemAtIndexPath:indexPath];

    UILabel *checkLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width/4, cell.frame.size.height/4)];
    
    [checkLabel.layer setCornerRadius:checkLabel.frame.size.width/2];
    [checkLabel.layer setMasksToBounds:YES];
    
    [checkLabel setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.8]];
    [checkLabel setTextColor:[UIColor blackColor]];
    [checkLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [checkLabel setTextAlignment:NSTextAlignmentCenter];
    [checkLabel setAdjustsFontSizeToFitWidth:YES];
    

    
    [checkLabel setText:[NSString stringWithFormat:@"%d",1]];
    
    [cell addSubview:checkLabel];

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //    NSLog(@"%@", textView.text);
    //    [self setCaption:textView.text];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
}

@end
