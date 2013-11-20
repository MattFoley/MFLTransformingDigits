//
//  MFLScoreBoard.m
//  Folding Clock
//
//  Created by teejay on 10/26/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import "MFLTransformingScoreBoard.h"

static CGFloat kMFLMaxTimerRefreshRate = 0.1; // = 60 fps

@interface MFLTransformingScoreBoard ()

@property NSTimer *animationTimer;

@property MFLAnimationDirection animationDirection;

@property NSMutableArray *digitArray;

@property NSInteger nextValue;
@property NSInteger prevValue;

@property NSTimeInterval stepDuration;
@property NSTimeInterval intervalRest;
@property NSTimeInterval neededInterval;

@end

@implementation MFLTransformingScoreBoard

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithBaseDigit:[self defaultBaseDigit] forFrame:frame];
}

- (id)initWithBaseDigit:(MFLTransformingDigit *)digit forFrame:(CGRect)frame
{
    return [self initWithBaseDigit:digit andValue:0 forFrame:frame];
}

- (id)initWithBaseDigit:(MFLTransformingDigit *)digit andValue:(NSInteger)value forFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupForValue:value withStyle:digit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupForValue:0 withStyle:[self defaultBaseDigit]];
    }
    
    return self;
}

- (void)setupForValue:(NSInteger)initialValue withStyle:(MFLTransformingDigit *)digit
{
    NSAssert((initialValue >= 0), @"You must use positive values");
    _baseDigit = digit;
    
    self.digitArray = [@[] mutableCopy];
    self.animationDuration = 3.0;
    
    self.prevValue = initialValue;
    self.targetValue = initialValue;
    self.nextValue = initialValue;
    
    NSString *stringValue = [@(self.nextValue) stringValue];
    
    for (int i = (stringValue.length - 1); i >= 0 ; i--) {
        [self addMostSignificantDigitWithValue:[[stringValue substringWithRange:NSMakeRange(i, 1)] integerValue]];
    }
}


- (MFLTransformingDigit *)defaultBaseDigit
{
    static MFLTransformingDigit *defaultDigit;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultDigit = [[MFLTransformingDigit alloc] initWithFrame:CGRectMake(0, 0, 50, 60)
                                                      initialDigit:0
                                                      foldingStyle:kMFLSingleLineFold];
    });
    
    return defaultDigit;
}


- (void)addMostSignificantDigitWithValue:(NSInteger)value
{
    [self.baseDigit  setCurrentDigit:value];
    MFLTransformingDigit *newDigit = [[MFLTransformingDigit alloc] initWithFoldingDigit:self.baseDigit];
    
    
    CGRect prevDigitsFrame = [self.digitArray.lastObject frame];
    if (CGRectEqualToRect(prevDigitsFrame, CGRectZero)) {
        prevDigitsFrame.size = self.baseDigit.frame.size;
        prevDigitsFrame.origin = CGPointMake(self.frame.size.width - self.baseDigit.frame.size.width,
                                             (self.frame.size.height - self.baseDigit.frame.size.height)/2);
    } else {
        //Affix after previous digit
        prevDigitsFrame.origin.x -= (prevDigitsFrame.size.width + kDigitKerningValue);
    }
    
    [newDigit setFrame:prevDigitsFrame];
    
    [self.digitArray addObject:newDigit];
    [self addSubview:newDigit];
}

- (void)removeMostSignificantDigit
{
    MFLTransformingDigit *mostSigDigit = self.digitArray.lastObject;
    [mostSigDigit setAnimationDuration:.2];
    [self.digitArray removeObject:mostSigDigit];
    [mostSigDigit removeFromSuperview:YES];
}

- (void)decrementByValue:(NSInteger)value
{
    [self setToValue:self.targetValue - value withDuration:self.animationDuration completion:nil];
}

- (void)incrementByValue:(NSInteger)value
{
    [self setToValue:self.targetValue + value withDuration:self.animationDuration completion:nil];
}

- (void)decrementByValue:(NSInteger)value completion:(void (^)(BOOL success))completion
{
    [self setToValue:self.targetValue - value withDuration:self.animationDuration completion:completion];
}

- (void)incrementByValue:(NSInteger)value completion:(void (^)(BOOL success))completion
{
    [self setToValue:self.targetValue + value withDuration:self.animationDuration completion:completion];
}

- (void)setToValue:(NSInteger)value
{
    [self setToValue:value withDuration:self.animationDuration completion:nil];
}

- (void)setToValue:(NSInteger)value completion:(void (^)(BOOL success))completion
{
    [self setToValue:value withDuration:self.animationDuration completion:completion];
}

- (void)setToValue:(NSInteger)value withDuration:(NSTimeInterval)timeInterval completion:(void (^)(BOOL success))completion
{
    [self stopAnimation];
    
    if (value < 0) {
        value = 0;
    }
    self.animationDirection = (value < self.targetValue) ? kMFLAnimateDown : kMFLAnimateUp;
    self.completionBlock = completion;
    
    self.targetValue = value;
    
    self.animationDuration = timeInterval;
    
    
    NSInteger stepCount = ABS(self.prevValue - self.targetValue);
    self.neededInterval = (self.animationDuration/stepCount);
    
    CGFloat actualInterval = fmaxf(self.neededInterval, kMFLMaxTimerRefreshRate);
    
    self.animationTimer = [NSTimer timerWithTimeInterval:actualInterval
                                                  target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [self.animationTimer fire]; // fire instantly for first change
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}
- (void)stopAnimation
{
    if (_completionBlock) {
        _completionBlock(NO);
    }
    self.targetValue = self.nextValue;
    [self.animationTimer invalidate];
}

- (void)handleTimer:(NSTimer*)timer
{
    // if timer is too slow, add more than 1 per timer call
    NSInteger step = 1;
    if (timer.timeInterval > self.neededInterval) {
        CGFloat ratio = timer.timeInterval/self.neededInterval;
        step = floor(ratio);
        self.intervalRest += ratio-step;
        if (self.intervalRest > 1) {
            step += floor(self.intervalRest);
            self.intervalRest -= floor(self.intervalRest);
        }
    }
    
    self.nextValue = (self.animationDirection == kMFLAnimateDown ? self.nextValue-step : self.nextValue+step);
    
    // check target mode finish conditions
    
    if (self.nextValue == self.targetValue ||
        (self.animationDirection == kMFLAnimateUp && self.nextValue > self.targetValue) ||
        (self.animationDirection == kMFLAnimateDown && self.nextValue < self.targetValue))
    {
        self.nextValue = self.prevValue = self.targetValue;
        
        [self updateVisibleValue:step];
        
        if (self.completionBlock != nil) {
            self.completionBlock(YES);
            self.completionBlock = nil;
        }
        [self stopAnimation];
        return;
    } else {
        [self updateVisibleValue:step];
    }
    
}

- (void)updateVisibleValue:(NSInteger)stepValue;
{
    
    NSString *stringValue = [@(self.nextValue) stringValue];
    
    
    if (self.animationDirection == kMFLAnimateDown) {
        NSInteger prevStringLen = [[@(self.nextValue + stepValue) stringValue] length];
        NSInteger significantDigitsLost = (prevStringLen - stringValue.length);
        
        while (significantDigitsLost > 0) {
            //Animate from current digit to zero before disappearing
            /*
            if (stringValue.length > 1) {
                MFLTransformingDigit *mostSigDigit = self.digitArray.lastObject;
                [self.digitArray removeObject:mostSigDigit];
                [mostSigDigit animateToDigit:0 completion:^(BOOL success) {
                    [mostSigDigit removeFromSuperview:YES];
                }];
            } else {
                [self removeMostSignificantDigit];
            }*/

            //Animate from current digit to gone.
            
            [self removeMostSignificantDigit];
            significantDigitsLost--;
        }
    }
    
    
    for (int i = (stringValue.length - 1); i >= 0 ; i--) {
        
        NSInteger freshDigitValue = [[stringValue substringWithRange:NSMakeRange(i, 1)] integerValue];
        if (i >= self.digitArray.count) {
            [self addMostSignificantDigitWithValue:freshDigitValue];
            continue;
        }
        
        MFLTransformingDigit *digit = (MFLTransformingDigit*) self.digitArray[self.digitArray.count-(1+i)];
        if (freshDigitValue != digit.currentDigit) {
            [self updateVisibleValueForDigit:digit toValue:freshDigitValue];
        }
    };
}

- (void)updateVisibleValueForDigit:(MFLTransformingDigit*)digit toValue:(NSInteger)newValue
{
    // convert to string
    NSInteger digitSpeedFactor = self.digitArray.count - ([self.digitArray indexOfObject:digit] + 1);
    //NSLog(@"digit animation length %f", (self.neededInterval*10)*digitSpeedFactor);
    [digit setAnimationDuration:fmin(.3, .1 + (.3/self.digitArray.count) * digitSpeedFactor)];
    [digit animateToDigit:newValue];
    
}


- (void)setBaseDigit:(MFLTransformingDigit *)digit
{
    [self.digitArray enumerateObjectsUsingBlock:^(MFLTransformingDigit *boardDigit, NSUInteger idx, BOOL *stop) {
        boardDigit.strokeColor = digit.strokeColor;
        boardDigit.lineThickness = digit.lineThickness;
        boardDigit.animationDuration = digit.animationDuration;
        boardDigit.calculationMode = digit.calculationMode;
        boardDigit.timingFunction = digit.timingFunction;
        boardDigit.animationStyle = digit.animationStyle;
        boardDigit.rotate3DStyle = digit.rotate3DStyle;
        boardDigit.shouldRotateIn2D = digit.shouldRotateIn2D;
        boardDigit.scaleStyle = digit.scaleStyle;
        boardDigit.shouldAnimationNewSuperview = digit.shouldAnimationNewSuperview;
    }];
}



@end
