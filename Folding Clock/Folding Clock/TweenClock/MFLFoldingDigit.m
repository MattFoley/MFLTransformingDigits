//
//  MFLFoldingDigit.m
//  NumberTweening
//
//  Created by teejay on 10/15/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import "MFLFoldingDigit.h"

@interface MFLFoldingDigit()

@property NSInteger frameCount;

@property NSInteger currentFrameIndex;
@property NSInteger toDigit;
@property NSInteger currentDigit;

@property UIBezierPath *drawPath;
@property NSMutableArray *drawnDigits;

@end

@implementation MFLFoldingDigit

static CGPoint points[10][5] =
{
    {
        {44.5, 100}, {100, 18}, {156, 100}, {100, 180}, {44.5, 100}
    }, // 0
    
    {
        {77, 20.5}, {104.5, 20.5}, {104.5, 181}, {104.5, 181}, {104.5, 181} //1
    },
    {
        {56, 60}, {144.5, 61}, {108, 122}, {57, 177}, {147, 177}
    }, // 2
    {
        {63.25, 54}, {99.5, 18}, {99.5, 96}, {100, 180}, {56.5, 143}
    }, // 3
    {
        {155, 146}, {43, 146}, {129, 25}, {129, 146}, {129, 179}
    }, //4
    {
        {146, 20}, {91, 20}, {72, 78}, {145, 129}, {45, 154}
    }, // 5
    {
        {110, 20}, {110, 20}, {46, 126}, {153, 126}, {53.5, 100}
    }, // 6
    {
        {47, 21}, {158, 21}, {120.67, 73.34}, {83.34, 126.67}, {46, 181}
    },  // 7
    {
        {101, 96}, {101, 19}, {101, 96}, {101, 179}, {101, 96}
    }, // 8
    {
        {146.5, 100}, {47, 74}, {154, 74}, {90, 180}, {90, 180}
    } // 9
    
};

static CGPoint controlOne[10][4] =
{
    {
        {44.5, 60}, {133, 18}, {156 , 140}, {67, 180}
    }, // 0
    {
        {77, 20.5}, {104.5, 20.5}, {104.5, 181}, {104.5, 181}
    }, // 1
    {
        {59, 2}, {144.5, 78}, {94, 138}, {57, 177}
    }, // 2
    {
        {63, 27}, {156, 18}, {158, 96}, {54, 180}
    }, // 3
    {
        {155, 146}, {43, 146}, {129, 25}, {129, 146}
    }, // 4
    {
        {91, 20}, {72, 78}, {97, 66}, {140, 183}
    }, // 5
    {
        {110, 20}, {71, 79}, {52, 208}, {146, 66}
    }, // 6
    {
        {47, 21}, {158, 21}, {120.67, 73.34}, {83.34, 126.67}
    }, // 7
    {
        {44, 95}, {154, 19}, {44, 96}, {154, 179}
    }, // 8
    {
        {124, 136}, {42, 8}, {152, 108}, {90, 180}
    } // 9
};

static CGPoint controlTwo[10][4] =
{
    {
        {67, 18}, {156, 60}, {133, 180}, {44.5, 140}
    }, // 0
    {
        {104.5, 20.5}, {104.5, 181}, {104.5, 181}, {104.5, 181}
    }, // 1
    {
        {143, 4}, {130, 98}, {74, 155}, {147, 177}
    }, // 2
    {
        {86, 18}, {146, 96}, {150, 180}, {56, 150}
    }, // 3
    {
        {43, 146}, {129, 25}, {129, 146}, {129, 179}
    }, // 4
    {
        {91, 20}, {72, 78}, {145, 85}, {68, 198}
    }, // 5
    {
        {110, 20}, {48, 92}, {158, 192}, {76, 64}
    }, // 6
    {
        {158, 21}, {120.67, 73.34}, {83.34, 126.67}, {46, 181}
    }, // 7
    {
        {44, 19}, {154, 96}, {36, 179}, {154, 96}
    }, // 8
    {
        {54, 134}, {148, -8}, {129, 121}, {90, 180}
    } // 9
};


- (CGFloat)getInterpolation:(CGFloat)input {
    return (cosf(((input + 1)) * M_PI) / 2) + 0.5;
}

#pragma mark Initialization
- (id)initWithFrame:(CGRect)frame andDigit:(NSInteger)initialDigit
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _transformDuration = .6;
        _lineThickness = 3;
        _strokeColor = [[UIColor brownColor] CGColor];
        _drawnDigits = [@[] mutableCopy];
        
        [self initializeSegments:initialDigit];
    }
    
    return self;
}

- (void)initializeSegments:(NSInteger)initialDigit
{
    for (int i = 0; i < 4; i++) {
        _drawnDigits[i] = [[CAShapeLayer alloc] init];
    }
    
    [_drawnDigits enumerateObjectsUsingBlock:^(CAShapeLayer *segment, NSUInteger idx, BOOL *stop) {
        [segment setBounds:self.bounds];
        [segment setPosition:self.center];
        [segment setFillColor:[[UIColor clearColor] CGColor]];
        [segment setStrokeColor:_strokeColor];
        [segment setLineWidth:_lineThickness];
        [segment setLineJoin:kCALineJoinRound];
        
        UIBezierPath *newPath = [[UIBezierPath alloc] init];
        [newPath moveToPoint:points[initialDigit][idx]];
        [newPath addCurveToPoint:points[initialDigit][idx+1]
                   controlPoint1:controlOne[initialDigit][idx]
                   controlPoint2:controlTwo[initialDigit][idx]];
        
        [segment setPath:newPath.CGPath];
        [self.layer addSublayer:segment];
    }];
}

- (void)setLineThickness:(CGFloat)lineThickness
{
    [_drawnDigits enumerateObjectsUsingBlock:^(CAShapeLayer *segment, NSUInteger idx, BOOL *stop) {
        [segment setLineWidth:lineThickness];
    }];
    
    _lineThickness = lineThickness;
}

- (void)setStrokeColor:(CGColorRef)strokeColor
{
    [_drawnDigits enumerateObjectsUsingBlock:^(CAShapeLayer *segment, NSUInteger idx, BOOL *stop) {
        [segment setStrokeColor:strokeColor];
    }];
    
    _strokeColor = strokeColor;
}

- (void)animateToDigit:(NSInteger)digit
{
    self.currentDigit = digit;
    CGFloat frame = [self getInterpolation:0];
    
    [self.drawnDigits enumerateObjectsUsingBlock:^(CAShapeLayer *segment, NSUInteger idx, BOOL *stop) {
        UIBezierPath *newPath = [[UIBezierPath alloc] init];
        [newPath moveToPoint:points[digit][idx]];
        [newPath addCurveToPoint:points[digit][idx+1]
                   controlPoint1:controlOne[digit][idx]
                   controlPoint2:controlTwo[digit][idx]];
        
        
        CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnim.fromValue = (__bridge id)segment.path;
        pathAnim.toValue = (__bridge id)newPath.CGPath;
        pathAnim.duration = 2;
        pathAnim.fillMode = kCAFillModeForwards;
        pathAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [segment addAnimation:pathAnim forKey:@"segmentTransform"];
        
        [segment setPath:newPath.CGPath];
    }];
}


- (void)decrement
{
    [self animateToDigit:(self.currentDigit - 1) % 10];
}

- (void)increment
{
    [self animateToDigit:(self.currentDigit + 1) % 10];
}

@end
