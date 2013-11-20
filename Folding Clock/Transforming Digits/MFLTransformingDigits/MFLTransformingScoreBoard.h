//
//  MFLScoreBoard.h
//  Folding Clock
//
//  Created by teejay on 10/26/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFLTransformingDigit.h"

typedef NS_ENUM(NSInteger, MFLAnimationDirection) {
    kMFLAnimateDown,
    kMFLAnimateUp
};

typedef void(^MFLCompletionBlock)(BOOL finished);

static const NSInteger kDigitKerningValue;



@interface MFLTransformingScoreBoard : UIView

- (id)initWithBaseDigit:(MFLTransformingDigit *)digit forFrame:(CGRect)frame;

- (id)initWithBaseDigit:(MFLTransformingDigit *)digit andValue:(NSInteger)value forFrame:(CGRect)frame;

/**
 *  Set the baseDigit property to control the styling of your Scoreboard.
 */
@property (nonatomic) MFLTransformingDigit *baseDigit;


/**
 *  This is the duration it will take to finish animating, unless you use a method that accepts a time as a parameter.
 */
@property CGFloat animationDuration;

/**
 *  The number currently at or animating towards.
 */
@property NSInteger targetValue;


/**
 *  Animate to a certain value using the current animationDuration property
 *
 *  @param value value to reach.
 */
- (void)setToValue:(NSInteger)value;


/**
 *  Convenience method for decrementing
 *
 *  @param value Value to decrement by.
 */
- (void)decrementByValue:(NSInteger)value;


/**
 *  Convenience method for incrementing.
 *
 *  @param value Value to increment by
 */
- (void)incrementByValue:(NSInteger)value;


/**
 *  Animate to a certain value.
 *
 *  @param value      Value to reach
 *  @param completion Block to fire on completion.
 */
- (void)setToValue:(NSInteger)value completion:(void (^)(BOOL success))completion;


/**
 *  Decrement by a certain value
 *
 *  @param value      Value to decrement by
 *  @param completion Block to fire on completion of animation
 */
- (void)decrementByValue:(NSInteger)value completion:(void (^)(BOOL success))completion;

/**
 *  Increment by a certain value
 *
 *  @param value      Value to Increment by
 *  @param completion Block to fire on completion of animation
 */
- (void)incrementByValue:(NSInteger)value completion:(void (^)(BOOL success))completion;

/**
 *  If you'd like to specify a new animation duration and star the animation simultaneously, use this method.
 *
 *  @param value        Value to reach
 *  @param timeInterval Animation Duration
 *  @param completion   Block fired on completion of animation.
 */
- (void)setToValue:(NSInteger)value withDuration:(NSTimeInterval)timeInterval completion:(void (^)(BOOL success))completion;

/**
 *  Halt the animation in place.
 */
- (void)stopAnimation;


/**
 *  This is here for autocompletion purposes, may not have the desired effect if used elsewhere.
 *
 *  @param completionBlock bacon.
 */
- (void)setCompletionBlock:(MFLCompletionBlock)completionBlock;

/**
 *  Also here to autocompletion purposes, you probably shouldn't set this directly.
 */
@property (copy) MFLCompletionBlock completionBlock;
@end
