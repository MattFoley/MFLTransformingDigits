//
//  MFLFoldingDigit+Animation.m
//  Folding Clock
//
//  Created by teejay on 10/26/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import "MFLTransformingDigit.h"
#import "CAAnimation+Blocks.h"

@implementation MFLTransformingDigit (Animation)

- (void)animateOnScreen
{
    if (self.shouldAnimationNewSuperview) {
        CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animateStrokeEnd.duration  = self.animationDuration;
        animateStrokeEnd.fromValue = @(0.0f);
        animateStrokeEnd.toValue   = @(1.0f);
        
        switch (self.foldingStyle) {
            case kMFLSingleLineFold:
            {
                self.drawnDigit.strokeEnd = 1.0;
                [self.drawnDigit addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
                break;
            }
            case kMFLSegmentFold:
            {
                [self.drawnSegments enumerateObjectsUsingBlock:^(CAShapeLayer *layer, NSUInteger idx, BOOL *stop) {
                    layer.strokeEnd = 1.0;
                    [layer addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
                }];
                break;
            }
            default:
                break;
        }
    }
}

- (void)animateSegmentsToDigit:(NSInteger)digit completion:(void (^)(BOOL success))completion;
{
    self.currentDigit = digit;
    
    [self.drawnSegments enumerateObjectsUsingBlock:^(CAShapeLayer *segment, NSUInteger idx, BOOL *stop) {
        UIBezierPath *newPath = [self segmentPathForDigit:digit atIndex:idx];
        [self attachAnimationForPath:newPath toLayer:segment completion:completion];
    }];
}

- (void)animateToDigitFlat:(NSInteger)digit completion:(void (^)(BOOL success))completion;
{
    self.currentDigit = digit;
    UIBezierPath *newPath = [self linePathForDigit:digit];
    
    [self attachAnimationForPath:newPath toLayer:self.drawnDigit completion:completion];
}

- (void)attachAnimationForPath:(UIBezierPath *)path toLayer:(CAShapeLayer *)layer completion:(void (^)(BOOL success))completion;
{
    CAAnimationGroup *pathAnim = (CAAnimationGroup *)[self animationForPath:path fromPath:layer.path];
    [pathAnim setCompletion:completion];
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
    
    group.duration = self.animationDuration;
    
    return group;
}

- (CAAnimation *)getBasicAnimationForPath:(UIBezierPath *)path fromPath:(CGPathRef)fromPath
{
    switch (self.animationStyle) {
        case kMFLAnimationBounce:
        {
            return [self bounceAnimationForPath:path fromPath:fromPath];
            break;
        }
        case kMFLAnimationSmooth:
        {
            return [self smoothAnimationForPath:path fromPath:fromPath];
            break;
        }
        case kMFLAnimationCubicKeyframe:
        {
            return [self keyframeAnimationForPath:path fromPath:fromPath];
            break;
        }
        case kMFLAnimationRestroke:
        {
            return [self restrokeAnimationForPath:path fromPath:fromPath];
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
    
    animation.duration = self.animationDuration / 2;
    animation.fromValue = @(1);
    animation.toValue = @(0);
    
    animation.autoreverses = YES;
    return animation;
}

#pragma mark Rotate Animations

- (CAAnimation *)rotate3DHorizontalAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = self.animationDuration;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(.5 * M_PI, 0, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.5 * M_PI, 0, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2 * M_PI, 0, 1, 0)]];
    
    animation.autoreverses = NO;
    return animation;
}

- (CAAnimation *)rotate3DVerticalAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = self.animationDuration;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(.5 * M_PI, 1, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.5 * M_PI, 1, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2 * M_PI, 1, 0, 0)]];
    
    animation.autoreverses = NO;
    return animation;
}

- (CAAnimation *)rotate3DFullAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = self.animationDuration;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(.5 * M_PI, 1, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.5 * M_PI, 1, 1, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2 * M_PI, 1, 1, 0)]];
    
    animation.autoreverses = NO;
    return animation;
}


- (CAAnimation *)rotate2DAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = self.animationDuration;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    animation.autoreverses = NO;
    return animation;
}

#pragma mark Path Animations

- (CAAnimation *)keyframeAnimationForPath:(UIBezierPath *)path fromPath:(CGPathRef)fromPath
{
    CAKeyframeAnimation *pathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    
    pathAnim.values = @[(__bridge id)fromPath, (__bridge id)path.CGPath];
    pathAnim.duration = self.animationDuration;
    
    pathAnim.calculationMode = self.calculationMode;
    
    pathAnim.fillMode = kCAFillModeForwards;
    pathAnim.timingFunction = self.timingFunction;
    
    return pathAnim;
}

- (CAAnimation *)bounceAnimationForPath:(UIBezierPath *)path fromPath:(CGPathRef)fromPath
{
    CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    pathAnim.fromValue = (__bridge id)fromPath;
    pathAnim.toValue = (__bridge id)path.CGPath;
    pathAnim.duration = self.animationDuration;
    pathAnim.fillMode = kCAFillModeForwards;
    pathAnim.timingFunction = self.timingFunction;
    
    return pathAnim;
}

- (CAAnimation *)smoothAnimationForPath:(UIBezierPath *)path fromPath:(CGPathRef)fromPath
{
    CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    pathAnim.fromValue = (__bridge id)fromPath;
    pathAnim.toValue = (__bridge id)path.CGPath;
    pathAnim.duration = self.animationDuration;
    pathAnim.fillMode = kCAFillModeForwards;
    pathAnim.timingFunction = self.timingFunction;
    
    return pathAnim;
}

- (CAAnimationGroup *)restrokeAnimationForPath:(UIBezierPath *)path fromPath:(CGPathRef)fromPath
{
    CAAnimation *pathAnim = (CAAnimation *)[self smoothAnimationForPath:path fromPath:fromPath];
    pathAnim.duration = 0;
    
    CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animateStrokeEnd.duration  = self.animationDuration;
    animateStrokeEnd.fromValue = @(0.0f);
    animateStrokeEnd.toValue   = @(1.0f);
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    [group setAnimations:@[pathAnim, animateStrokeEnd]];
    
    return group;
}

- (void)animateToDigit:(NSInteger)digit
{
    [self animateToDigit:digit completion:nil];
}

- (void)animateToDigit:(NSInteger)digit completion:(void (^)(BOOL success))completion
{
    switch (self.foldingStyle) {
        case kMFLSegmentFold:
        {
            [self animateSegmentsToDigit:digit completion:completion];
            break;
        }
        case kMFLSingleLineFold:
        {
            [self animateToDigitFlat:digit completion:completion];
            break;
        }
        default:
            break;
    }
}


- (void)decrement
{
    [self decrementWithCompletion:nil];
}

- (void)decrementWithCompletion:(void (^)(BOOL success))completion
{
    if (self.currentDigit == 0) {
        self.currentDigit = 9;
    } else {
        self.currentDigit--;
    }
    
    [self animateToDigit:self.currentDigit % 10 completion:completion];
}

- (void)increment
{
    [self incrementWithCompletion:nil];
}

- (void)incrementWithCompletion:(void (^)(BOOL success))completion
{
    [self animateToDigit:(self.currentDigit + 1) % 10 completion:completion];
}


@end
