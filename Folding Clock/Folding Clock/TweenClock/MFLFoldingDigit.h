//
//  MFLFoldingDigit.h
//  NumberTweening
//
//  Created by teejay on 10/15/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kMFLSmooth,
    kMFLBounce,
    kMFLCubicKeyframe
} MFLAnimationStyle;

typedef enum {
    kMFLVertical3D,
    kMFLHorizontal3D,
    kMFLFull3D,
    kMFLNoRotate
} MFLRotateAnimationStyle;

typedef enum {
    kMFLPinHole,
    kMFLNoScale
} MFLScaleAnimationStyle;

@interface MFLFoldingDigit : UIView

@property (nonatomic) CGColorRef strokeColor;
@property (nonatomic) CGFloat lineThickness;

@property CGFloat transformDuration;

//Animation values
@property NSString *calculationMode;
@property id timingFunction;
@property MFLAnimationStyle animationStyle;

//Animation addons
@property MFLRotateAnimationStyle rotate3DStyle;
@property MFLScaleAnimationStyle scaleStyle;

@property BOOL shouldRotateIn2D;

- (id)initFlatWithFrame:(CGRect)frame andDigit:(NSInteger)initialDigit;
- (id)initWithFrame:(CGRect)frame andDigit:(NSInteger)initialDigit;

- (void)animateToDigit:(NSInteger)digit;
- (void)decrement;
- (void)increment;

@end
