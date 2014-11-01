//
//  TTCamera.m
//  OneTalk
//
//  Created by that_is on 14-8-2.
//  Copyright (c) 2014年 FourDioses. All rights reserved.
//

#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import "TTCamera.h"
#import "UIImage+Resize.h"

@implementation TTCamera


static TTCamera *sharedInstance = nil;

/*
 初始化
 **/
- (void) initialize
{
    NSError *error = nil;
    // 1.创建会话层
    self.session = [[AVCaptureSession alloc] init];
    //  设置采集大小
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    
    // 2.找到一个合适的采集设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 3.创建一个输入设备,并将它添加到会话
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!captureInput){
        NSLog(@"Error: %@", error);
        return;
    }
    [self.session addInput:captureInput];
    
    // 4.创建一个输出设备,并将它添加到会话
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    self.captureOutput.outputSettings = outputSettings;
    
    [self.session addOutput:self.captureOutput];
}

/*
 初始化
 **/
- (id)init
{
    if (self = [super init]){
        [self initialize];
    }
    return self;
}

/*
 插入预览视图到视图中
 **/
- (void)embedPreviewInView: (UIView *) aView {
    if (!self.session){
        return;
    }
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    self.preview.frame = aView.bounds;
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [aView.layer addSublayer: self.preview];
}

- (void)removePreviewInView: (UIView *) aView {
    if (!self.session){
        return;
    }
    
    [self.preview removeFromSuperlayer];
}

/*
 捕获图片
 **/
-(void)captureimage{
    // 5.获取连接
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    // 6.获取图片
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        if (nil != error)
        {
            NSLog(@"error:%@",error.localizedDescription);
            return;
        }
        CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, nil);
        if (exifAttachments) {
            // Do something with the attachments.
        }
        // 获取图片数据
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *t_image = [[UIImage alloc] initWithData:imageData];
        
        if (nil == self.image) {
            self.image = [[UIImage alloc]init];
        }
        
        CGFloat squareLength = self.preview.frame.size.width;
        CGFloat headHeight = self.preview.frame.origin.y;// _previewLayer.bounds.size.height - squareLength;//_previewLayer的frame是(0, 44, 320, 320 + 44)
        CGSize size = CGSizeMake(squareLength * 2, squareLength * 2);
        
        UIImage *scaledImage = [t_image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationHigh];
        
        CGRect cropFrame = CGRectMake((scaledImage.size.width - size.width) / 2, (scaledImage.size.height - size.height) / 2 + headHeight, size.width, size.height);
        UIImage *croppedImage = [scaledImage croppedImage:cropFrame];
        
        
//        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//        if (orientation != UIDeviceOrientationPortrait) {
//            
//            CGFloat degree = 0;
//            if (orientation == UIDeviceOrientationPortraitUpsideDown) {
//                degree = 180;// M_PI;
//            } else if (orientation == UIDeviceOrientationLandscapeLeft) {
//                degree = -90;// -M_PI_2;
//            } else if (orientation == UIDeviceOrientationLandscapeRight) {
//                degree = 90;// M_PI_2;
//            }
//            croppedImage = [croppedImage rotatedByDegrees:degree];
//        }
        self.image = croppedImage;
    }];
}

/*
 改变预览方向
 **/
- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [CATransaction begin];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.imageOrientation = UIImageOrientationRight;
        self.preview.orientation = AVCaptureVideoOrientationLandscapeRight;
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.imageOrientation = UIImageOrientationLeft;
        self.preview.orientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    
    [CATransaction commit];
}

#pragma mark Class Interface
/*
 private
 实例化 CameraImageHelper
 **/
+ (TTCamera *) sharedInstance{
    if(!sharedInstance){
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

/*
 开始运行
 **/
+ (void) startRunning{
    [[[self sharedInstance] session] startRunning];
}

/*
 停止运行
 **/
+ (void) stopRunning{
    [[[self sharedInstance] session] stopRunning];
}

/*
 获取图片
 **/
+ (UIImage *) image{
    return [[self sharedInstance] image];
}

/*
 获取静止的图片
 **/
+(void)captureStillImage{
    [[self sharedInstance] captureimage];
}

/*
 插入预览视图到主视图中
 **/
+ (void)embedPreviewInView: (UIView *) aView{
    [[self sharedInstance] embedPreviewInView:aView];
}

+ (void)removePreviewInView: (UIView *) aView{
    [[self sharedInstance] removePreviewInView:aView];
}
/*
 改变预览视图的方向
 **/
+ (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [[self sharedInstance] changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation];
}

@end