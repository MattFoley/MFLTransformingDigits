//
//  MFLViewController.m
//  NumberTweening
//
//  Created by teejay on 10/15/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import "MFLViewController.h"
#import "MFLFoldingDigit.h"

@interface MFLViewController ()

@property (strong) MFLFoldingDigit *digitTest;

@property (weak) IBOutlet MFLFoldingDigit *padDigitTest3DVert;
@property (weak) IBOutlet MFLFoldingDigit *padDigitTest3DHorz;
@property (weak) IBOutlet MFLFoldingDigit *padDigitTest3DFull;

@property (weak) IBOutlet MFLFoldingDigit *padDigitTest3DVertPinhole;
@property (weak) IBOutlet MFLFoldingDigit *padDigitTest3DHorzPinhole;
@property (weak) IBOutlet MFLFoldingDigit *padDigitTest3DFullPinhole;

@property (weak) IBOutlet MFLFoldingDigit *padDigitTest2D;
@property (weak) IBOutlet MFLFoldingDigit *padDigitTest2DPinhole;
@property (weak) IBOutlet MFLFoldingDigit *padDigitTestPlain;

@property IBOutletCollection(MFLFoldingDigit) NSMutableArray *digitViews;

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
    //padDigitTest3DVert;
    [self.padDigitTest3DVert setRotate3DStyle:kMFLVertical3D];
    //padDigitTest3DHorz;
    [self.padDigitTest3DHorz setRotate3DStyle:kMFLHorizontal3D];
    //padDigitTest3DFull;
    [self.padDigitTest3DFull setRotate3DStyle:kMFLFull3D];
    
    //padDigitTest3DVertPinhole;
    [self.padDigitTest3DVertPinhole setRotate3DStyle:kMFLVertical3D];
    [self.padDigitTest3DVertPinhole setScaleStyle:kMFLPinHole];
    //padDigitTest3DHorzPinhole;
    [self.padDigitTest3DHorzPinhole setRotate3DStyle:kMFLHorizontal3D];
    [self.padDigitTest3DHorzPinhole setScaleStyle:kMFLPinHole];
    //padDigitTest3DFullPinhole;
    [self.padDigitTest3DFullPinhole setScaleStyle:kMFLPinHole];
    [self.padDigitTest3DFullPinhole setRotate3DStyle:kMFLFull3D];
    
    //padDigitTest2D;
    [self.padDigitTest2D setShouldRotateIn2D:YES];
    
    //padDigitTest2DPinhole;
    [self.padDigitTest2DPinhole setShouldRotateIn2D:YES];
    [self.padDigitTest2DPinhole setScaleStyle:kMFLPinHole];
    
    //padDigitTestPlain;
}

- (void)rotateDigits
{
    [self.digitViews enumerateObjectsUsingBlock:^(MFLFoldingDigit *digit, NSUInteger idx, BOOL *stop) {
        if (self.shouldIncrement) {
            [digit increment];
        } else {
            [digit decrement];
        }
        
    }];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self rotateDigits];
    });
}

- (IBAction)toggleDirectionOfChange:(id)sender
{
    self.shouldIncrement = !self.shouldIncrement;
}

- (IBAction)scrambleDigits:(id)sender
{
    [self.digitViews enumerateObjectsUsingBlock:^(MFLFoldingDigit *digit, NSUInteger idx, BOOL *stop) {
        [digit animateToDigit:arc4random()%10];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
