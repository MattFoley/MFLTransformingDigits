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


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
}
//    ctx.clearRect(0, 0, 200, 200);
//    ctx.beginPath();
//
//    var current = points{i};
//    var next = points{j};
//    var curr1 = control_one{i};
//    var next1 = control_one{j};
//    var curr2 = control_two{i};
//    var next2 = control_two{j};
//
//    // Interpolated value.
//    frame = getInterpolation(frame);
//
//    // First point.
//    ctx.moveTo(current{0}{0} + ((next{0}{0} - current{0}{0}) * frame),
//               current{0}{1} + ((next{0}{1} - current{0}{1}) * frame));
//
//    // Rest of the points connected as bezier curve.
//    for (var index = 1; index < 5; index++) {
//        ctx.bezierCurveTo(
//                          curr1{index-1}{0} + ((next1{index-1}{0} - curr1{index-1}{0}) * frame),
//                          curr1{index-1}{1} + ((next1{index-1}{1} - curr1{index-1}{1}) * frame),
//                          curr2{index-1}{0} + ((next2{index-1}{0} - curr2{index-1}{0}) * frame),
//                          curr2{index-1}{1} + ((next2{index-1}{1} - curr2{index-1}{1}) * frame),
//                          current{index}{0} + ((next{index}{0} - current{index}{0}) * frame),
//                          current{index}{1} + ((next{index}{1} - current{index}{1}) * frame));
//    }
//
//    ctx.stroke();
//
// var canvas = document.getElementById('canvas');
// var ctx = canvas.getContext('2d');
// ctx.strokeStyle = '#FFFFFF';
// ctx.lineWidth = 5;
//
// var current = 0;
// var next = 1;
// var frame = 0;

///*
//
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

//
///**
// * Draws each frame of the animation.
// */
//function draw(i, j, frame) {
//}
//
///*
// * Each number change is divided into 10 frames.
// * First two frames and last two frames are static.
// * Acceleration-Deceleration happens in the in-between 6 frames.
// */
//function nextFrame() {
//    // Frames 0, 1 is the first pause.
//    // Frames 9, 10 is the last pause.
//    if (frame >= 2 && frame <= 8) {
//        draw (current, next, (frame - 2) / 6);
//    }
//
//    frame++;
//
//    // Each number change has 10 frames. Reset.
//    if (frame == 10) {
//        frame = 0;
//        current = next;
//        next++;
//
//        // Reset to zarro.
//        if (next == 10) {
//            next = 0;
//        }
//    }
//
//    setTimeout(nextFrame, 100);
//}
//
//// Start the animation.
//setTimeout(nextFrame, 100);
// */
#pragma mark Initialization
- (id)initWithFrame:(CGRect)frame andDigit:(NSInteger)initialDigit
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _transformDuration = .6;
        _lineThickness = 3;
        _strokeColor = [[UIColor whiteColor] CGColor];
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
        [newPath moveToPoint:[self transformPoint:points[digit][idx] withFrame:frame]];
        [newPath addCurveToPoint:[self transformPoint:points[digit][idx+1] withFrame:frame]
                   controlPoint1:[self transformPoint:controlOne[digit][idx] withFrame:frame]
                   controlPoint2:[self transformPoint:controlTwo[digit][idx] withFrame:frame]];
        
        
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

- (CGPoint)transformPoint:(CGPoint)transformPoint withFrame:(CGFloat)frame
{
    //flipPoint = CGPointMake(flipPoint.x, self.frame.size.height - flipPoint.y);
#pragma mark To Be Implemented
    return transformPoint;
}

- (void)decrement
{
    [self animateToDigit:(self.currentDigit - 1) % 10];
}

- (void)increment
{
    [self animateToDigit:(self.currentDigit + 1) % 10];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
