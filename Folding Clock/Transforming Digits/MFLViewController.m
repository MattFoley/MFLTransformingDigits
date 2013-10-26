//
//  MFLViewController.m
//  NumberTweening
//
//  Created by teejay on 10/15/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import "MFLViewController.h"
#import "MFLTransformingDigit.h"

@interface MFLViewController ()

@property (strong) MFLTransformingDigit *digitTest;

@property (weak) IBOutlet MFLTransformingDigit *digitTest3DVert;
@property (weak) IBOutlet MFLTransformingDigit *digitTest3DHorz;
@property (weak) IBOutlet MFLTransformingDigit *digitTest3DFull;

@property (weak) IBOutlet MFLTransformingDigit *digitTest3DVertPinhole;
@property (weak) IBOutlet MFLTransformingDigit *digitTest3DHorzPinhole;
@property (weak) IBOutlet MFLTransformingDigit *digitTest3DFullPinhole;

@property (weak) IBOutlet MFLTransformingDigit *digitTest2D;
@property (weak) IBOutlet MFLTransformingDigit *digitTest2DPinhole;
@property (weak) IBOutlet MFLTransformingDigit *digitTestPlain;

@property (weak) IBOutlet MFLTransformingDigit *digitTestRestroke;

@property IBOutletCollection(MFLTransformingDigit) NSMutableArray *digitViews;

@property BOOL shouldIncrement;

@end

@implementation MFLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldIncrement = YES;
    [self initExample];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self rotateDigits];
    });
}


- (void)initExample
{
    //digitTest3DVert;
    [self.digitTest3DVert setRotate3DStyle:kMFLVertical3D];
    //digitTest3DHorz;
    [self.digitTest3DHorz setRotate3DStyle:kMFLHorizontal3D];
    //digitTest3DFull;
    [self.digitTest3DFull setRotate3DStyle:kMFLFull3D];
    
    //digitTest3DVertPinhole;
    [self.digitTest3DVertPinhole setRotate3DStyle:kMFLVertical3D];
    [self.digitTest3DVertPinhole setScaleStyle:kMFLPinHole];
    //digitTest3DHorzPinhole;
    [self.digitTest3DHorzPinhole setRotate3DStyle:kMFLHorizontal3D];
    [self.digitTest3DHorzPinhole setScaleStyle:kMFLPinHole];
    //digitTest3DFullPinhole;
    [self.digitTest3DFullPinhole setScaleStyle:kMFLPinHole];
    [self.digitTest3DFullPinhole setRotate3DStyle:kMFLFull3D];
    
    //digitTest2D;
    [self.digitTest2D setShouldRotateIn2D:YES];
    
    //digitTest2DPinhole;
    [self.digitTest2DPinhole setShouldRotateIn2D:YES];
    [self.digitTest2DPinhole setScaleStyle:kMFLPinHole];
    
    //digitTestRestroke
    [self.digitTestRestroke setAnimationStyle:kMFLAnimationRestroke];
    
    [self.digitViews enumerateObjectsUsingBlock:^(MFLTransformingDigit *obj, NSUInteger idx, BOOL *stop) {
        [obj setLineThickness:3];
    }];
}

- (void)rotateDigits
{
    if ( [self.digitViews[0] superview] ) {
        [self.digitViews enumerateObjectsUsingBlock:^(MFLTransformingDigit *digit, NSUInteger idx, BOOL *stop) {
            if (self.shouldIncrement) {
                [digit increment];
            } else {
                [digit decrement];
            }
            
        }];
    }
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self rotateDigits];
    });
}

- (IBAction)toggleRemoveAndAdd:(id)sender
{
    [self.digitViews enumerateObjectsUsingBlock:^(MFLTransformingDigit *digit, NSUInteger idx, BOOL *stop) {
        CGRect oldFrame = digit.frame;
        [digit removeFromSuperview:YES];
      
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            digit.frame = oldFrame;
            [self.view addSubview:digit];
        });
        
    }];
}

- (IBAction)toggleDirectionOfChange:(id)sender
{
    self.shouldIncrement = !self.shouldIncrement;
}

- (IBAction)scrambleDigits:(id)sender
{
    [self.digitViews enumerateObjectsUsingBlock:^(MFLTransformingDigit *digit, NSUInteger idx, BOOL *stop) {
        [digit animateToDigit:arc4random()%10];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
