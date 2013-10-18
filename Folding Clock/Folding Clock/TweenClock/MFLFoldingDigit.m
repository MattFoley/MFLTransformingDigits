//
//  MFLFoldingDigit.m
//  NumberTweening
//
//  Created by teejay on 10/15/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

typedef enum {
    kMFLSingleLineFold,
    kMFLSegmentFold
} MFLFoldingStyle;

#import "MFLFoldingDigit.h"

@interface MFLFoldingDigit()

@property NSInteger frameCount;

@property NSInteger currentFrameIndex;
@property NSInteger toDigit;
@property NSInteger currentDigit;

@property UIBezierPath *drawPath;
@property NSMutableArray *drawnSegments;
@property CAShapeLayer *drawnDigit;

@property MFLFoldingStyle foldingStyle;
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

#pragma mark Initialization
- (id)initWithFrame:(CGRect)frame andDigit:(NSInteger)initialDigit
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self sharedInit];
        [self initializeSegments:initialDigit];
        
        _foldingStyle = kMFLSegmentFold;
    }
    
    return self;
}

- (id)initFlatWithFrame:(CGRect)frame andDigit:(NSInteger)initialDigit
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self sharedInit];
        [self initializeLayer:initialDigit];
        
        _foldingStyle = kMFLSingleLineFold;
    }
    
    return self;
}

- (void)sharedInit
{
    _calculationMode = kCAAnimationCubic;
    _timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    _transformDuration = .6;
    _lineThickness = 3;
    _strokeColor = [[UIColor whiteColor] CGColor];
    
    _drawnSegments = [@[] mutableCopy];
    
    _rotate3DStyle = kMFLNoRotate;
    _scaleStyle = kMFLNoScale;
    
    _shouldRotateIn2D = NO;
}

- (void)initializeLayer:(NSInteger)initialDigit
{
    self.drawnDigit = [[CAShapeLayer alloc] init];
    
    [self.drawnDigit setBounds:self.bounds];
    [self.drawnDigit setPosition:self.center];
    [self.drawnDigit setFillColor:[[UIColor clearColor] CGColor]];
    [self.drawnDigit setStrokeColor:_strokeColor];
    [self.drawnDigit setLineWidth:_lineThickness];
    [self.drawnDigit setLineJoin:kCALineJoinRound];
    
    UIBezierPath *newPath = [self linePathForDigit:initialDigit];
    [self.drawnDigit setPath:newPath.CGPath];
    
    [self.layer addSublayer:self.drawnDigit];
}

- (void)initializeSegments:(NSInteger)initialDigit
{
    for (int i = 0; i < 4; i++) {
        _drawnSegments[i] = [[CAShapeLayer alloc] init];
    }
    
    [_drawnSegments enumerateObjectsUsingBlock:^(CAShapeLayer *segment, NSUInteger idx, BOOL *stop) {
        [segment setBounds:self.bounds];
        [segment setPosition:self.center];
        [segment setFillColor:[[UIColor clearColor] CGColor]];
        [segment setStrokeColor:_strokeColor];
        [segment setLineWidth:_lineThickness];
        [segment setLineJoin:kCALineJoinRound];
        
        UIBezierPath *newPath = [self segmentPathForDigit:initialDigit atIndex:idx];
        [segment setPath:newPath.CGPath];
        
        [self.layer addSublayer:segment];
    }];
}

- (void)setLineThickness:(CGFloat)lineThickness
{
    [_drawnSegments enumerateObjectsUsingBlock:^(CAShapeLayer *segment, NSUInteger idx, BOOL *stop) {
        [segment setLineWidth:lineThickness];
    }];
    
    _lineThickness = lineThickness;
}

- (void)setStrokeColor:(CGColorRef)strokeColor
{
    [_drawnSegments enumerateObjectsUsingBlock:^(CAShapeLayer *segment, NSUInteger idx, BOOL *stop) {
        [segment setStrokeColor:strokeColor];
    }];
    
    _strokeColor = strokeColor;
}



- (void)animateToDigit:(NSInteger)digit
{
    switch (self.foldingStyle) {
        case kMFLSegmentFold:
        {
            [self animateSegmentsToDigit:digit];
            break;
        }
        case kMFLSingleLineFold:
        {
            [self animateToDigitFlat:digit];
            break;
        }
        default:
            break;
    }
}

- (void)animateSegmentsToDigit:(NSInteger)digit
{
    self.currentDigit = digit;
    
    [self.drawnSegments enumerateObjectsUsingBlock:^(CAShapeLayer *segment, NSUInteger idx, BOOL *stop) {
        UIBezierPath *newPath = [self segmentPathForDigit:digit atIndex:idx];
        [self attachAnimationForPath:newPath toLayer:segment];
    }];
}

- (void)animateToDigitFlat:(NSInteger)digit
{
    self.currentDigit = digit;
    UIBezierPath *newPath = [self linePathForDigit:digit];
    
    [self attachAnimationForPath:newPath toLayer:self.drawnDigit];
}

- (void)attachAnimationForPath:(UIBezierPath *)path toLayer:(CAShapeLayer *)layer
{
    CAAnimationGroup *pathAnim = (CAAnimationGroup *)[self animationForPath:path fromPath:layer.path];
    [layer addAnimation:pathAnim forKey:@"segmentTransform"];
    [layer setPath:path.CGPath];
}

#pragma mark Animations

- (CAAnimationGroup *)animationForPath:(UIBezierPath *)path fromPath:(CGPathRef)fromPath
{
    NSMutableArray *animations = [@[] mutableCopy];
    
    [animations addObject:[self getBasicAnimationForPath:path fromPath:fromPath]];
    
    [self add3DRotateAnimationToArray:animations];
    [self addScaleAnimationToArray:animations];
    
    if (self.shouldRotateIn2D) {
        [animations addObject:[self rotate2DAnimation]];
    }
    
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = [animations copy];
    
    group.duration = self.transformDuration;
    
    return group;
}

- (CAAnimation *)getBasicAnimationForPath:(UIBezierPath *)path fromPath:(CGPathRef)fromPath
{
    switch (self.animationStyle) {
        case kMFLBounce:
        {
            return [self bounceAnimationForPath:path fromPath:fromPath];
            break;
        }
        case kMFLSmooth:
        {
            return [self smoothAnimationForPath:path fromPath:fromPath];
            break;
        }
        case kMFLCubicKeyframe:
        {
            return [self keyframeAnimationForPath:path fromPath:fromPath];
            break;
        }
            
        default:
            break;
    }
}

- (void)add3DRotateAnimationToArray:(NSMutableArray*)animations
{
    switch (self.rotate3DStyle) {
        case kMFLFull3D:
        {
            [animations addObject:[self rotate3DFullAnimation]];
            break;
        }
        case kMFLHorizontal3D:
        {
            [animations addObject:[self rotate3DHorizontalAnimation]];
            break;
        }
        case kMFLVertical3D:
        {
            [animations addObject:[self rotate3DVerticalAnimation]];
            break;
        }
        case kMFLNoRotate:
        default:
            break;
    }
    
}

- (void)addScaleAnimationToArray:(NSMutableArray*)animations
{
    switch (self.scaleStyle) {
        case kMFLPinHole:
        {
            [animations addObject:[self pinholeScaleAnimation]];
            break;
        }

        case kMFLNoScale:
        default:
            break;
    }
    
}

#pragma mark Scale Animations

- (CAAnimation *)pinholeScaleAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = self.transformDuration / 2;
    animation.fromValue = @(1);
    animation.toValue = @(0);
    
    animation.autoreverses = YES;
    return animation;
}

#pragma mark Rotate Animations

- (CAKeyframeAnimation *)rotate3DHorizontalAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = self.transformDuration;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(.5 * M_PI, 0, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.5 * M_PI, 0, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2 * M_PI, 0, 1, 0)]];
    
    animation.autoreverses = NO;
    return animation;
}

- (CAKeyframeAnimation *)rotate3DVerticalAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = self.transformDuration;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(.5 * M_PI, 1, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.5 * M_PI, 1, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2 * M_PI, 1, 0, 0)]];
    
    animation.autoreverses = NO;
    return animation;
}

- (CAKeyframeAnimation *)rotate3DFullAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = self.transformDuration;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(.5 * M_PI, 1, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.5 * M_PI, 1, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2 * M_PI, 1, 1, 0)]];
    
    animation.autoreverses = NO;
    return animation;
}


- (CABasicAnimation *)rotate2DAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = self.transformDuration;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    animation.autoreverses = NO;
    return animation;
}

#pragma mark Path Animations

- (CAKeyframeAnimation *)keyframeAnimationForPath:(UIBezierPath *)path fromPath:(CGPathRef)fromPath
{
    CAKeyframeAnimation *pathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    
    pathAnim.values = @[(__bridge id)fromPath, (__bridge id)path.CGPath];
    pathAnim.duration = self.transformDuration;
    
    pathAnim.calculationMode = self.calculationMode;
    
    pathAnim.fillMode = kCAFillModeForwards;
    pathAnim.timingFunction = self.timingFunction;
    
    return pathAnim;
}

- (CAPropertyAnimation *)bounceAnimationForPath:(UIBezierPath *)path fromPath:(CGPathRef)fromPath
{
    CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    pathAnim.fromValue = (__bridge id)fromPath;
    pathAnim.toValue = (__bridge id)path.CGPath;
    pathAnim.duration = self.transformDuration;
    pathAnim.fillMode = kCAFillModeForwards;
    pathAnim.timingFunction = self.timingFunction;
    
    return pathAnim;
}

- (CAPropertyAnimation *)smoothAnimationForPath:(UIBezierPath *)path fromPath:(CGPathRef)fromPath
{
    CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    pathAnim.fromValue = (__bridge id)fromPath;
    pathAnim.toValue = (__bridge id)path.CGPath;
    pathAnim.duration = self.transformDuration;
    pathAnim.fillMode = kCAFillModeForwards;
    pathAnim.timingFunction = self.timingFunction;
    
    return pathAnim;
}

#pragma mark Paths

- (UIBezierPath *)segmentPathForDigit:(NSInteger)digit atIndex:(NSInteger) idx
{
    UIBezierPath *newPath = [[UIBezierPath alloc] init];
    [newPath moveToPoint:points[digit][idx]];
    [newPath addCurveToPoint:points[digit][idx+1]
               controlPoint1:controlOne[digit][idx]
               controlPoint2:controlTwo[digit][idx]];
    return newPath;
}

- (UIBezierPath *)linePathForDigit:(NSInteger)digit
{
    UIBezierPath *newPath = [[UIBezierPath alloc] init];
    [newPath moveToPoint:points[digit][0]];
    
    for (int idx = 0; idx < 4; idx++) {
        [newPath addCurveToPoint:points[digit][idx+1]
                   controlPoint1:controlOne[digit][idx]
                   controlPoint2:controlTwo[digit][idx]];
    }

    return newPath;
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
