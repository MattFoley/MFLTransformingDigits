//
//  MFLScoreBoard.h
//  Folding Clock
//
//  Created by teejay on 10/26/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFLTransformingDigit.h"

static const NSInteger kDigitKerningValue;

@interface MFLTransformingScoreBoard : UIView

//Set the baseDigit property to control the styling of your Scoreboard.
@property (nonatomic) MFLTransformingDigit *baseDigit;

- (void)setToValue:(NSInteger)value;

- (void)decrementByValue:(NSInteger)value;
- (void)incrementByValue:(NSInteger)value;

@end
