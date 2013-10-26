//
//  MFLScoreBoard.m
//  Folding Clock
//
//  Created by teejay on 10/26/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import "MFLTransformingScoreBoard.h"

@interface MFLTransformingScoreBoard ()

@property NSMutableArray *digitArray;
@property NSInteger currentValue;

@end

@implementation MFLTransformingScoreBoard

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithBaseDigit:[self defaultBaseDigit] forFrame:frame];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithBaseDigit:[self defaultBaseDigit] forCoder:aDecoder];
}

- (id)initWithBaseDigit:(MFLTransformingDigit *)digit forFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self sharedInit:digit];
    }
    
    return self;
}

- (id)initWithBaseDigit:(MFLTransformingDigit *)digit forCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self sharedInit:digit];
    }
    
    return self;
}

- (void)sharedInit:(MFLTransformingDigit *)digit
{
    _baseDigit = digit;
    _currentValue = _baseDigit.currentDigit;
    [self addMostSignificantDigitWithValue:_currentValue];
}


- (MFLTransformingDigit *)defaultBaseDigit
{
    static MFLTransformingDigit *defaultDigit;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultDigit = [[MFLTransformingDigit alloc] initWithFrame:CGRectMake(0, 0, 30, 30)
                                                      initialDigit:0
                                                      foldingStyle:kMFLSingleLineFold];
    });
    
    return defaultDigit;
}


- (void)addMostSignificantDigitWithValue:(NSInteger)value
{
    MFLTransformingDigit *newDigit = [[MFLTransformingDigit alloc] initWithFoldingDigit:self.baseDigit];
    
    CGRect prevDigitsFrame = [self.digitArray.lastObject frame];
    
    //Adding digit to the left side
    prevDigitsFrame.origin.x -= (prevDigitsFrame.size.width + kDigitKerningValue);
    [newDigit setFrame:prevDigitsFrame];
    
    [self.digitArray addObject:newDigit];
    [self addSubview:newDigit];
    
    [newDigit animateToDigit:value];
}

- (void)removeMostSignificantDigit
{
    MFLTransformingDigit *mostSigDigit = self.digitArray.lastObject;
    
    [mostSigDigit removeFromSuperview];
}

- (void)setToValue:(NSInteger)value
{
    
}

- (void)decrementByValue:(NSInteger)value
{
    
}

- (void)incrementByValue:(NSInteger)value
{
    
}


@end
