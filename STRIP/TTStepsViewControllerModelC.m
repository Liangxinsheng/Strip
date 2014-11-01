//
//  TTStepsViewControllerModelC.m
//  OneTalk
//
//  Created by that_is on 14-8-3.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import "TTStepsViewControllerModelC.h"
#import "MJCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface TTStepsViewControllerModelC () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UICollectionView *parallaxCollectionView;

@end

@implementation TTStepsViewControllerModelC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Fill image array with images
//    NSUInteger index;
//    for (index = 1; index < 6; ++index) {
//        // Setup image name
//        NSString *name = [NSString stringWithFormat:@"Brasil_%ld.jpg", (unsigned long)index];
//        if(!self.images)
//            self.images = [NSMutableArray arrayWithCapacity:0];
//        [self.images addObject:name];
//    }
    
    if(!self.images)
        self.images = [NSMutableArray arrayWithCapacity:0];
    
    for (ALAsset *asset in self.assets) {
        CGImageRef thumbnailImageRef = [asset thumbnail];
        UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
        [self.images addObject:thumbnail];
    }
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.parallaxCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)//self.view.frame
                                                    collectionViewLayout:flowLayout];
    //注册
    [self.parallaxCollectionView registerClass:[MJCollectionViewCell class] forCellWithReuseIdentifier:@"MJCell"];
    //设置代理
    self.parallaxCollectionView.delegate = self;
    self.parallaxCollectionView.dataSource = self;
    [self.view addSubview:self.parallaxCollectionView];
    [self.parallaxCollectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDatasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MJCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MJCell" forIndexPath:indexPath];
    
    //get image name and assign
//    NSString* imageName = [self.images objectAtIndex:indexPath.item];
//    cell.image = [UIImage imageNamed:imageName];
    cell.image = (UIImage *)[self.images objectAtIndex:indexPath.item];
    
    //set offset accordingly
    CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.parallaxCollectionView.frame.size.width, IMAGE_HEIGHT);
}

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(MJCollectionViewCell *view in self.parallaxCollectionView.visibleCells) {
        CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}
@end
