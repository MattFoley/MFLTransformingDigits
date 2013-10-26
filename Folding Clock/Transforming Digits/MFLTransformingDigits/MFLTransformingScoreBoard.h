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

/**
 *  Set the baseDigit property to control the styling of your Scoreboard.
 */
@property (nonatomic) MFLTransformingDigit *baseDigit;

@property (copy) MFLCompletionBlock completionBlock;

@property CGFloat animationDuration;

@property NSInteger targetValue;
/**
 *  This is here for autocompletion purposes, may not have the desired effect if used elsewhere.
 *
 *  @param completionBlock
 */
- (void)setCompletionBlock:(MFLCompletionBlock)completionBlock;;

- (void)setToValue:(NSInteger)value;

- (void)decrementByValue:(NSInteger)value;

- (void)incrementByValue:(NSInteger)value;

- (void)setToValue:(NSInteger)value completion:(void (^)(BOOL success))completion;

- (void)decrementByValue:(NSInteger)value completion:(void (^)(BOOL success))completion;

- (void)incrementByValue:(NSInteger)value completion:(void (^)(BOOL success))completion;


- (void)stopAnimation;

@end
