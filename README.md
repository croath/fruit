fruit
=====

<img src="https://raw.githubusercontent.com/croath/fruit/master/doc/fruit.gif" width=30% />


Clone and checkout the sample.

###Wanna modify it?

Checkout `CRFruitView.h`:

```objective-c
/*
 Margin between 2 animation characters.
 */
@property (nonatomic, assign) CGFloat verticalMargin;

/*
 Margin between 2 characters.
 */
@property (nonatomic, assign) CGFloat horizontalMargin;

/*
 Bounds size for one character.
 */
@property (nonatomic, assign) CGSize charSize;

/*
 Label's text's attributed dictionary.
 */
@property (nonatomic, strong) NSDictionary *textAttr;

/*
 Rolling animation number increment or not. Default YES.
 */
@property (nonatomic, assign) BOOL incrementRoll;

/*
 Rolling direction down or up. Default YES.
 */
@property (nonatomic, assign) BOOL downRoll;

/*
 Animation time(seconds) of animating one single character. Default 0.3.
 */
@property (nonatomic, assign) NSTimeInterval charAnimationDuration;

```