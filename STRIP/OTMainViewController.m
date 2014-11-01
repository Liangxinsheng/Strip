//
//  OTMainViewController.m
//  OneTalk
//
//  Created by that_is on 14-4-2.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import "OTMainViewController.h"
#import "TTStepsViewController.h"
#import "TTStepsViewControllerModelB.h"
#import "TTStepsViewControllerModelA.h"
#import "TTStepsViewControllerModelC.h"
#import "TTTakePicturesViewController.h"
#import <UIImage+BlurredFrame.h>
#import <UIImageView+LBBlurredImage.h>

@interface OTMainViewController()

@property (strong, nonatomic) NSMutableArray *groups;

@end

@implementation OTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *img = [UIImage imageNamed:@"startscreen.jpg"];
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:img];
    [bg setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.view addSubview:bg];
    
    self.title = @"Strip";
    
    self.navigationController.navigationBarHidden = YES;
    
//    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button0 setFrame:CGRectMake(40, 200, 60, 40)];
//    [button0 setBackgroundColor:[UIColor redColor]];
//    [button0 setTitle:@"Style1" forState:UIControlStateNormal];
//    [button0 setTintColor:[UIColor whiteColor]];
//    [button0 addTarget:self action:@selector(button0Clicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview: button0];
//    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button1 setFrame:CGRectMake(120, 200, 60, 40)];
//    [button1 setBackgroundColor:[UIColor redColor]];
//    [button1 setTitle:@"Style2" forState:UIControlStateNormal];
//    [button1 setTintColor:[UIColor whiteColor]];
//    [button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:button1];
//    
//    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button2 setFrame:CGRectMake(200, 200, 60, 40)];
//    [button2 setBackgroundColor:[UIColor redColor]];
//    [button2 setTitle:@"Style3" forState:UIControlStateNormal];
//    [button2 setTintColor:[UIColor whiteColor]];
//    [button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:button2];
//
//    UIButton *albumButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [albumButton setFrame:CGRectMake(40, 120, 60, 40)];
//    [albumButton setBackgroundColor:[UIColor redColor]];
//    [albumButton setTitle:@"Gallery" forState:UIControlStateNormal];
//    [albumButton setTintColor:[UIColor whiteColor]];
//    [albumButton addTarget:self action:@selector(galleryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:albumButton];

    
    UIButton *camButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [camButton setFrame:CGRectMake(20, self.view.frame.size.height - 125, self.view.frame.size.width - 40, 120)];

    
    UIImage *buttonUp = [UIImage imageNamed:@"go_button_up.png"];
    [camButton setBackgroundImage:buttonUp forState:UIControlStateNormal];
    
    UIImage *buttonDown = [UIImage imageNamed:@"go_button_down.png"];
    [camButton setBackgroundImage:buttonDown forState:UIControlStateSelected];
    
    [camButton.layer setFrame:camButton.frame];
    [camButton.layer setCornerRadius:40];
    
    [camButton addTarget:self action:@selector(camButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:camButton];
    
    [self prepareAlbum];
}

- (void)prepareAlbum
{
    self.assetsLibrary = [[ALAssetsLibrary alloc]init];
    self.groups = [[NSMutableArray alloc]init];
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [self.groups addObject:group];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Group not found!\n");
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)button0Clicked:(id)sender
{
    TTStepsViewControllerModelA *imgvc = [[TTStepsViewControllerModelA alloc]init];
    imgvc.delegate = self;
    
    [self presentViewController:imgvc animated:YES completion:nil];
}

- (void)button1Clicked:(id)sender
{

    TTStepsViewControllerModelB *imgvc = [[TTStepsViewControllerModelB alloc]init];
    imgvc.delegate = self;
    
    [self presentViewController:imgvc animated:YES completion:nil];
}

- (void)button2Clicked:(id)sender
{
    
    TTStepsViewControllerModelC *imgvc = [[TTStepsViewControllerModelC alloc]init];
//    imgvc.delegate = self;
    
    [self presentViewController:imgvc animated:YES completion:nil];
}


- (void)galleryButtonClicked:(id)sender
{

    TTStepsViewControllerModelC *svcc = [[TTStepsViewControllerModelC alloc]init];
    
    if (!svcc.assets) {
        svcc.assets = [[NSMutableArray alloc] init];
    } else {
        [svcc.assets removeAllObjects];
    }
    
 
    
    for (ALAssetsGroup *group in self.groups) {
        
        svcc.assetsGroup = (ALAssetsGroup *)group;
        NSLog(@"numberofAssets:%ld", (long)svcc.assetsGroup.numberOfAssets);
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [svcc.assetsGroup setAssetsFilter:onlyPhotosFilter];
        NSLog(@"numberofAssets%ld", (long)svcc.assetsGroup.numberOfAssets);
        [svcc.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result) {
                [svcc.assets addObject:result];
            }
        }];

    }

    [(UINavigationController *)[self parentViewController]pushViewController:svcc animated:YES];
//    [self presentViewController:svcc animated:YES completion:nil];
}

- (void)camButtonClicked:(id)sender
{
    TTTakePicturesViewController *tkPictureVc = [[TTTakePicturesViewController alloc]init];
    
//    TTImagePickerCollectionViewController *imgPkerVc = [[TTImagePickerCollectionViewController alloc]init];
    
    if (!tkPictureVc.imgPkerVC) {
        tkPictureVc.imgPkerVC = [[TTImagePickerCollectionViewController alloc]init];
    }
    
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
    
    
    
    for (ALAssetsGroup *group in self.groups) {
        
        tkPictureVc.imgPkerVC.assetsGroup = (ALAssetsGroup *)group;

        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [tkPictureVc.imgPkerVC.assetsGroup setAssetsFilter:onlyPhotosFilter];

        [tkPictureVc.imgPkerVC.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result) {
                [tmpArray addObject:result];
            }
        }];
        
    }
    
    tkPictureVc.imgPkerVC.assets = [[tmpArray reverseObjectEnumerator]allObjects];
    
    tkPictureVc.title = @"Take Picture";
//    tkPictureVc.navigationController.toolbarHidden = YES;

    [[self navigationController] pushViewController:tkPictureVc animated:YES];
//    [self presentViewController:tkPictureVc animated:YES completion:nil];

//    [self presentViewController:tkPictureVc.imgPkerVC animated:YES completion:nil];
}

-(void) stepsViewControllerDidDismissView:(TTStepsViewController *)viewController;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
