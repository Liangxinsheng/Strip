//
//  TTCamera.h
//  OneTalk
//
//  Created by that_is on 14-8-2.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TTCamera : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (strong, nonatomic) AVCaptureSession *session;                    // 捕获会话
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;     // 捕获输出
@property (strong, nonatomic) UIImage *image;                               // 图片
@property (assign, nonatomic) UIImageOrientation imageOrientation;          // 图片方向
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;          // 预览视图

/*
 开始运行
 **/
+ (void) startRunning;

/*
 停止运行
 **/
+ (void) stopRunning;

/*
 获取图片
 **/
+ (UIImage *) image;

/*
 获取静止的图片
 **/
+ (void)captureStillImage;

/*
 插入预览视图到主视图中
 **/
+ (void)embedPreviewInView: (UIView *)aView;
+ (void)removePreviewInView: (UIView *) aView;

/*
 改变预览视图的方向
 **/
+ (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end
