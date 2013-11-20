//
//  MFLFoldingDigit.h
//  NumberTweening
//
//  Created by teejay on 10/15/13.
//  Copyright (c) 2013 MFL. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Dictates whether to draw digits as a single line or series of segments.
 */
typedef NS_ENUM(NSInteger, MFLFoldingStyle) {
    /**
     *  Will draw a single line and transform that
     */
    kMFLSingleLineFold,
    
    /**
     *  Will draw multiple segments and transform those individually.
     */
    kMFLSegmentFold
};


/**
 *  Possible animation styles.
 */
typedef NS_ENUM(NSInteger, MFLAnimationStyle) {
    /**
     *  Standard animation - likely what you want for now.
     */
    kMFLAnimationSmooth,
    
    /**
     *  Not yet implemented
     */
    kMFLAnimationBounce,
    
    /**
     *  Uses CAKeyFrameAnimaton
     */
    kMFLAnimationCubicKeyframe,
    
    /**
     *  Will restroke the digit for each transform
     */
    kMFLAnimationRestroke
};

/**
 *  Determines 3D rotation effect, none, horizontal, vertical or both.
 */
typedef NS_ENUM(NSInteger, MFLRotateAnimationStyle) {
    /**
     *  Will flip vertically 3D
     */
    kMFLVertical3D,
    
    /**
     *  Will flip horizontally 3d
     */
    kMFLHorizontal3D,
    
    /**
     *  Will flip both horizontally and vertically simultaneously
     */
    kMFLFull3D,
    
    /**
     *  Will not rotate 3D
     */
    kMFLNoRotate
};

/**
 *  Values to define scaling animation for digit transform
 */
typedef NS_ENUM(NSInteger, MFLScaleAnimationStyle) {
    /**
     *  Will pinhole scale the digit while transforming
     */
    kMFLPinHole,
    /**
     *  Will do no scaling during transform
     */
    kMFLNoScale
};

/**
 *  This is a base transforming digit class
 */
@interface MFLTransformingDigit : UIView

/**
 *  Stroke Color determines your digit's fill color
 */
@property (nonatomic) CGColorRef strokeColor;
/**
 *  Line Thickness determines how thick the lines are on your digit
 */
@property (nonatomic) CGFloat lineThickness;

/**
 *  Time it takes to transform from one digit to another
 */
@property CGFloat animationDuration;

/**
 *  Calculation mode for transformation animation. Use the values defined in CAAnimation.h, such as kCAAnimationLinear.
 */
@property NSString *calculationMode;

/**
 *  Timing function for the transformation between digits
 */
@property CAMediaTimingFunction *timingFunction;

/**
 *  Values defined above.
 */
@property MFLAnimationStyle animationStyle;

/**
 *  Determines 3D rotation effect, none, horizontal, vertical or both. Values defined above.
 */
@property MFLRotateAnimationStyle rotate3DStyle;

/**
 *  Set to add Pinhole scaling effect to your animation transformation.
 */
@property MFLScaleAnimationStyle scaleStyle;


/**
 *  Set to true will add a flat 2D rotation to the digits transformation
 */
@property BOOL shouldRotateIn2D;

/**
 *  Defaults to true, will animate stroke when added to superview.
 */
@property BOOL shouldAnimationNewSuperview;


/**
 *  Primary initializer
 *
 *  @param frame        Frame to draw within
 *  @param initialDigit Initial Digit to start as
 *  @param foldingStyle Folding style, currently draws either a single line, or multiple line segments.
 *
 *  @return Returns an initialized MFLTransformingDigit object
 */

- (id)initWithFrame:(CGRect)frame initialDigit:(NSInteger)initialDigit foldingStyle:(MFLFoldingStyle)foldingStyle;

/**
 *  Cloning method
 *
 *  @param digit The MFLTransformingDigit to copy.
 *
 *  @return Will return a duplicate MFLTransforming digit.
 */
- (id)initWithFoldingDigit:(MFLTransformingDigit *)digit;


/**
 *  Will draw UIBezierpath and return it for your own use.
 *
 *  @param digit The digit to draw the path for.
 *
 *  @return Same bezier path used to draw the digit in kMFLSingleLineFold folding style.
 */
- (UIBezierPath *)linePathForDigit:(NSInteger)digit;

/**
 *  Will draw UIBezierpath and return it for your own use.
 *
 *  @param digit The digit to draw the path for.
 *  @param idx The segment
 *
 *  @return Same bezier path used to draw the digit in kMFLSegmentFold folding style.
 */
- (UIBezierPath *)segmentPathForDigit:(NSInteger)digit atIndex:(NSInteger) idx;

/**
 *  A way to animate the superview removal
 *
 *  @param animated If true, will animate by erasing the line and then removing form superview.
 */
- (void)removeFromSuperview:(BOOL)animated;

- (void)setFrameAnimated:(CGRect)frame duration:(CGFloat)duration;

#pragma mark Ignore Me!

//You probably don't need any of these properties to use this class.
//They're defined here so I can seperate animation into a category.

/**
 *  Modifying the following properties will cause undefined behavior
 */
@property NSMutableArray *drawnSegments;
/**
 *  Modifying the following properties will cause undefined behavior
 */
@property CAShapeLayer *drawnDigit;
/**
 *  Modifying the following properties will cause undefined behavior
 */
@property NSInteger currentDigit;
/**
 *  Modifying the following properties will cause undefined behavior
 */
@property MFLFoldingStyle foldingStyle;

@end

#import "MFLTransformingDigit+Animation.h"