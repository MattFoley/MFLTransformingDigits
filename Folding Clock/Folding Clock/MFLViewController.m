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

@property (strong) IBOutlet MFLFoldingDigit *digitTest;

@end

@implementation MFLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.digitTest = [[MFLFoldingDigit alloc] initFlatWithFrame:CGRectMake(0, 0, 200, 200) andDigit:0];
    
    [self.digitTest setBackgroundColor:[UIColor clearColor]];
    [self.digitTest setStrokeColor:[UIColor whiteColor].CGColor];
    
    [self.view addSubview:self.digitTest];
    [self.digitTest setCenter:self.view.center];
    [self.digitTest setAnimationStyle:kMFLCubicKeyframe];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self rotateDigit];
    });
}

- (void)rotateDigit
{
    [self.digitTest increment];

    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self rotateDigit];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
