MFLFoldingClock
----------


####Beginnings of a fun animation project in UIBezierPaths

Currently the only way you can use this is to create a 200x200 view and place it somewhere. You can then increment, decrement or set it.

###Initialize Types
For segment based animatons initialize with:

     - (id)initWithFrame:(CGRect)frame andDigit:(NSInteger)initialDigit;  
     
For Single Path based animations initialize with:

     - (id)initFlatWithFrame:(CGRect)frame andDigit:(NSInteger)initialDigit;


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

###Available Functions

     - (void)animateToDigit:(NSInteger)digit;
     - (void)decrement;
     - (void)increment;
     
     
###Future Plans

Eventually this will hold multiple fonts, but is currently based on Futura. Next up is setting up the resizing ability, following by work on creating a clock by stringing these views together.

####Credit due.
This animation is inspired by the "Timely" Android App, and this [writeup](http://sriramramani.wordpress.com/2013/10/14/number-tweening/) describing it's bezier math.
