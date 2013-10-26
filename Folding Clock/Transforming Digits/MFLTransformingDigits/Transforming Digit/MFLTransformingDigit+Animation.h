//
//  MFLFoldingDigit+Animation.h
//  Folding Clock
//
//  Created by teejay on 10/26/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import "MFLTransformingDigit.h"

@interface MFLTransformingDigit (Animation)


/**
 *  Will animate directly to a digit, skipping those in between the current digit and digit argument
 *
 *  @param digit Digit to transform to
 */
- (void)animateToDigit:(NSInteger)digit;

/**
 *  Will animate directly to a digit, skipping those in between the current digit and digit argument
 *
 *  @param digit Digit to transform to
 *  @param completion Allows you to execute code on the completion of the animation
 *
 */
- (void)animateToDigit:(NSInteger)digit completion:(void (^)(BOOL success))completion;

/**
 *  Will decrement by one number, @Note: 0 will decrement to 9.
 */
- (void)decrement;

/**
 *  Will decrement by one number, @Note: 0 will decrement to 9.
 *
 *  @param completion Allows you to execute code on the completion of the animation
 */
- (void)decrementWithCompletion:(void (^)(BOOL success))completion;

/**
 *  Will increment by one number, @Note 9 will increment to 0.
 */
- (void)increment;

/**
 *  Will increment by one number, @Note 9 will increment to 0.
 *
 *  @param completion Allows you to execute code on the completion of the animation
 */
- (void)incrementWithCompletion:(void (^)(BOOL success))completion;



#pragma mark Ignore Me!

- (void)animateSegmentsToDigit:(NSInteger)digit completion:(void (^)(BOOL success))completion;;
- (void)animateToDigitFlat:(NSInteger)digit completion:(void (^)(BOOL success))completion;;

- (void)animateOnScreen;

@end
