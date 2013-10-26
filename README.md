MFLFoldingClock
----------

####Beginnings of a fun animation project in UIBezierPaths

This is a highly complex animation library for showing numbers changing, be it a countdown, a clock, or a scoreboard. It now allows for any size frame with special affine transforms.

After creating it you can increment, decrement or set it directly to a digit.

Much more is planned in the future, but for now check out a [video here.](http://www.youtube.com/watch?v=AWKp-sXtM90)
**Note:** This video is now out dated, check out the sample projects for a better idea of capability.

###Initialize Types

The previous two initializers have been coalesced into one:

     - (id)initWithFrame:(CGRect)frame initialDigit:(NSInteger)initialDigit foldingStyle:(MFLFoldingStyle)foldingStyle;


Use the following initializer if you wish to copy a digit you already have:

     - (id)initWithFoldingDigit:(MFLTransformingDigit *)digit; 

###Editable Properties

The following properties are available to customize the style and animation of the digits.

####Style Properties

     @property (nonatomic) CGColorRef strokeColor;
     @property (nonatomic) CGFloat lineThickness;
     @property CGFloat transformDuration;
     
####Animation Values

     @property NSString *calculationMode;
     @property id timingFunction;
     @property MFLAnimationStyle animationStyle;

####Extra Animations

     @property MFLRotateAnimationStyle rotate3DStyle;
     @property MFLScaleAnimationStyle scaleStyle;
     @property BOOL shouldRotateIn2D;
     @property BOOL shouldAnimationNewSuperview;

###Available Functions

     - (void)animateToDigit:(NSInteger)digit;
     - (void)animateToDigit:(NSInteger)digit completion:(void (^)(BOOL))completion;
     
     - (void)decrement;
     - (void)decrementWithCompletion:(void (^)(BOOL))completion;
     
     - (void)increment;
     - (void)incrementWithCompletion:(void (^)(BOOL))completion;
     
     
###Future Plans

Eventually this will hold multiple fonts, but is currently based on Futura. 

A clock is still in the works, but the current plan is to implement a scoreboard of sorts which string together multiple MFLTransformingDigits

####Credit due.
This animation is inspired by the "Timely" Android App, and this [writeup](http://sriramramani.wordpress.com/2013/10/14/number-tweening/) describing it's bezier math.
