//
//  MJCollectionViewCell.m
//  RCCPeakableImageSample
//
//  Created by Mayur on 4/1/14.
//  Copyright (c) 2014 RCCBox. All rights reserved.
//

#import "MJCollectionViewCell.h"

@interface MJCollectionViewCell() <UITextViewDelegate>

@property (nonatomic, strong, readwrite) UIImageView *MJImageView;

@end

@implementation MJCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self setup];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) [self setup];
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Setup Method

- (void)setup
{
    [self setupImageView];
    [self setupTextField];

}

- (void)setupTextField
{
    self.captionField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
//    [captionField setDelegate:self];
    [self.captionField setTextAlignment:NSTextAlignmentCenter];
    [self.captionField setBackgroundColor:[UIColor clearColor]];
    [self.captionField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [self.captionField.layer setMasksToBounds:NO];
    [self.captionField setTextColor:[UIColor blackColor]];
    
    [self.captionField setReturnKeyType:UIReturnKeyDone];
    [self.captionField setKeyboardType:UIKeyboardTypeDefault];
    [self.captionField setAutoresizingMask:UIViewAutoresizingFlexibleHeight];


    self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
    [self.captionLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.4]];
//    [self.captionLabel setTextColor:[UIColor whiteColor]];
    [self.captionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [self.captionLabel setTextAlignment:NSTextAlignmentCenter];
    [self.captionLabel setAdjustsFontSizeToFitWidth:YES];
    [self.captionLabel setNumberOfLines:0];
//    [self.captionLabel setText:[NSString stringWithFormat:@"STEP #%ld %@", (long)self.seqNumber, self.caption]];

//    [self.captionLabel setAlpha:0];
    
    [self addSubview:self.captionLabel];
    [self addSubview:self.captionField];
}

- (void)setupImageView
{
    // Clip subviews
    self.clipsToBounds = YES;
    
    // Add image subview
    self.MJImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, IMAGE_HEIGHT)];
    self.MJImageView.backgroundColor = [UIColor redColor];
    self.MJImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.MJImageView.clipsToBounds = NO;
    [self addSubview:self.MJImageView];
    
}

# pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    // Store image
    self.MJImageView.image = image;
    
    // Update padding
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    // Store padding value
    _imageOffset = imageOffset;
    
    // Grow image view
    CGRect frame = self.MJImageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.MJImageView.frame = offsetFrame;
}

- (void)setCaption:(NSString *)caption
{
//    self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
//    [self.captionLabel setBackgroundColor:[UIColor clearColor]];
//    [self.captionLabel setTextColor:[UIColor whiteColor]];
//    [self.captionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
//    [self.captionLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.captionLabel setAdjustsFontSizeToFitWidth:YES];
//    [self.captionLabel setNumberOfLines:0];
//    [self.captionLabel setText:[NSString stringWithFormat:@"STEP #%ld %@", (long)self.seqNumber, self.caption]];
    
//    [self addSubview:self.captionLabel];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    NSLog(@"swipeRight");
    UITextView *textView = [[UITextView  alloc] initWithFrame:self.frame];
    
    textView.textColor = [UIColor blackColor];
    
    textView.font = [UIFont fontWithName:@"Arial" size:18.0];

    textView.delegate = self;

    textView.backgroundColor = [UIColor clearColor];
    
    textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";
    textView.returnKeyType = UIReturnKeyDefault;

    textView.keyboardType = UIKeyboardTypeDefault;

    textView.scrollEnabled = NO;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:textView];
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
        [self setCaption:textView.text];
        
        return NO;
        
    }
    
    return YES;    
    
}

@end
