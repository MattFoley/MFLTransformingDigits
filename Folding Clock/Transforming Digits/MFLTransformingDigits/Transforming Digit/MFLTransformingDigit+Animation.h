//
//  MFLFoldingDigit+Animation.h
//  Folding Clock
//
//  Created by teejay on 10/26/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import "MFLTransformingDigit.h"

@interface MFLTransformingDigit (Animation)

- (void)animateSegmentsToDigit:(NSInteger)digit;
- (void)animateToDigitFlat:(NSInteger)digit;

- (void)animateOnScreen;

@end
