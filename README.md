MFLFoldingClock
===============

####Beginnings of a fun animation project in UIBezierPaths

Currently the only way you can use this is to create a 200x200 view and place it somewhere. You can then increment, decrement or set it.

Initialize with:

     - (id)initWithFrame:(CGRect)frame andDigit:(NSInteger)initialDigit;  

Properties you can edit are:


     @property (nonatomic) CGColorRef strokeColor;
     @property (nonatomic) CGFloat lineThickness;
     @property CGFloat transformDuration;

Eventually this will hold multiple fonts, but is currently based on Futura. Next up is setting up the resizing ability, following by work on creating a clock by stringing these views together.

This animation is inspired by the "Timely" Android App, and this [writeup](http://sriramramani.wordpress.com/2013/10/14/number-tweening/) describing it's bezier math.
