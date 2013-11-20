//
//  MFLFoldingDigit.m
//  NumberTweening
//
//  Created by teejay on 10/15/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import "MFLTransformingDigit.h"
#import "CAAnimation+Blocks.h"
#import "MFLTransformingDigit+Animation.h"

@interface MFLTransformingDigit()

@property NSInteger frameCount;

@property NSInteger currentFrameIndex;
@property NSInteger toDigit;

@property UIBezierPath *drawPath;

@end

@implementation MFLTransformingDigit

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

- (id)initWithFrame:(CGRect)frame initialDigit:(NSInteger)initialDigit foldingStyle:(MFLFoldingStyle)foldingStyle
{
    switch (foldingStyle) {
        case kMFLSingleLineFold: { return [self initFlatWithFrame:frame andDigit:initialDigit]; }
        case kMFLSegmentFold: { return [self initWithFrame:frame andDigit:initialDigit]; }
        default: { return nil; }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Initialization code
        [self sharedInit];
        [self initializeLayer:0];
        
        _foldingStyle = kMFLSingleLineFold;
    }
    
    return self;
}

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
        
        self.drawnDigit.shadowColor = [UIColor blueColor].CGColor;
        self.drawnDigit.shadowOffset = CGSizeMake(0, 3);
        _foldingStyle = kMFLSingleLineFold;
    }
    
    return self;
}

- (id)initWithFoldingDigit:(MFLTransformingDigit *)digit
{
    if (digit.foldingStyle == kMFLSingleLineFold) {
        self = [self initFlatWithFrame:digit.frame andDigit:digit.currentDigit];
    } else {
        self = [self initWithFrame:digit.frame andDigit:digit.currentDigit];
    }
    
    self.strokeColor = digit.strokeColor;
    self.lineThickness = digit.lineThickness;
    self.animationDuration = digit.animationDuration;
    self.calculationMode = digit.calculationMode;
    self.timingFunction = digit.timingFunction;
    self.animationStyle = digit.animationStyle;
    self.rotate3DStyle = digit.rotate3DStyle;
    self.shouldRotateIn2D = digit.shouldRotateIn2D;
    self.scaleStyle = digit.scaleStyle;
    self.shouldAnimationNewSuperview = digit.shouldAnimationNewSuperview;
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [self transformToProperFrame];
        [self animateOnScreen];
    }
}

- (void)setFrame:(CGRect)frame
{
    self.layer.transform = CATransform3DIdentity;
    [super setFrame:frame];
    
    if (self.superview) {
        [self transformToProperFrame];
    }
}

- (void)setFrameAnimated:(CGRect)frame duration:(CGFloat)duration
{
    CGRect prevFrame = self.frame;
    self.layer.transform = CATransform3DIdentity;
    [super setFrame:frame];
    [self animateToProperFrame:duration prevFrame:prevFrame];
}

- (void)transformToProperFrame
{
    if (!CGSizeEqualToSize(self.frame.size, (CGSize){200,200})) {
        CGPoint prevCenter = self.layer.position;
        CGAffineTransform transform = CGAffineTransformFromRectToRect(CGRectMake(0, 0, 200, 200),
                                                                      self.frame);
        //self.layer.transform = CATransform3DIdentity;
        [self.layer setFrame:CGRectMake(0, 0, 200, 200)];
        
        [self setCenter:prevCenter];
        
        self.layer.anchorPoint = CGPointMake(.5,.5);
        self.layer.contentsGravity = @"center";
        
        self.layer.transform = CATransform3DMakeAffineTransform(transform);
    }
    
}

- (void)animateToProperFrame:(CGFloat)duration prevFrame:(CGRect)prevFrame
{
    if (!CGSizeEqualToSize(self.frame.size, (CGSize){200,200})) {
        CGPoint prevCenter = self.layer.position;
        CGAffineTransform transform = CGAffineTransformFromRectToRect(CGRectMake(0, 0, 200, 200),
                                                                      self.frame);
        //self.layer.transform = CATransform3DIdentity;
        //[self.layer setFrame:CGRectMake(0, 0, 200, 200)];
        [self setFrame:prevFrame];
        [self setCenter:prevCenter];
        
        self.layer.anchorPoint = CGPointMake(.5,.5);
        self.layer.contentsGravity = @"center";
        
        [UIView animateWithDuration:duration animations:^{
            self.layer.transform = CATransform3DMakeAffineTransform(transform);
        }];
    }
}

CGAffineTransform CGAffineTransformFromRectToRect(CGRect fromRect, CGRect toRect)
{
    
    CGAffineTransform scale = CGAffineTransformMakeScale(toRect.size.width/fromRect.size.width, toRect.size.height/fromRect.size.height);
    return scale;
}

- (void)sharedInit
{
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.masksToBounds = YES;
    
    _calculationMode = kCAAnimationCubic;
    _timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    _animationDuration = .6;
    _lineThickness = 3;
    _strokeColor = [[UIColor whiteColor] CGColor];
    
    _drawnSegments = [@[] mutableCopy];
    
    _rotate3DStyle = kMFLNoRotate;
    _scaleStyle = kMFLNoScale;
    
    _shouldRotateIn2D = NO;
    _shouldAnimationNewSuperview = YES;
}

- (void)initializeLayer:(NSInteger)initialDigit
{
    self.drawnDigit = [[CAShapeLayer alloc] init];
    
    [self.drawnDigit setFrame:CGRectMake(0, 0, 200, 200)];
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
        [segment setFrame:CGRectMake(0, 0, 200, 200)];
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
    
    [_drawnDigit setLineWidth:lineThickness];
    
    _lineThickness = lineThickness;
}

- (void)setStrokeColor:(CGColorRef)strokeColor
{
    [_drawnSegments enumerateObjectsUsingBlock:^(CAShapeLayer *segment, NSUInteger idx, BOOL *stop) {
        [segment setStrokeColor:strokeColor];
    }];
    
    [_drawnDigit setStrokeColor:strokeColor];
    
    _strokeColor = strokeColor;
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

- (void)removeFromSuperview:(BOOL)animated
{
    [self.layer removeAllAnimations];
    if (animated) {
        CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animateStrokeEnd.duration  = self.animationDuration;
        animateStrokeEnd.fromValue = @(1.0f);
        animateStrokeEnd.toValue   = @(0.0f);
        
        [animateStrokeEnd setCompletion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
        switch (self.foldingStyle) {
            case kMFLSingleLineFold:
            {
                self.drawnDigit.strokeEnd = 0.0;
                [self.drawnDigit addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
                break;
            }
            case kMFLSegmentFold:
            {
                [self.drawnSegments enumerateObjectsUsingBlock:^(CAShapeLayer *layer, NSUInteger idx, BOOL *stop) {
                    layer.strokeEnd = 0.0;
                    [layer addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
                }];
                break;
            }
            default:
                break;
        }
        
    } else {
        [self removeFromSuperview];
    }
}

@end
