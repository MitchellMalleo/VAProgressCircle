# VAProgressCircle

![](https://github.com/MitchellMalleo/VAProgressCircle/blob/master/vaProgressCircle.gif)

---

## Example Setup

1. Clone the repo and drag the Classes folder into your project. This should include VAProgressCircle.h/.m, and UIProgressLabel.h/.m
2. Either create a VAProgressCircle using the `- (id)initWithFrame:(CGRect)frame` method or you can drag and drop a UIView into your Interface Builder, subclass it to VAProgressCircle, and link it up to a property in your UIViewController

Here is the snippet of code slightly modified from the example app included in the repo. This shows how to initalize and add a VAProgressChart to your UIViewController using `- (id)initWithFrame:(CGRect)frame`

	self.circleChart = [[VAProgressCircle alloc] initWithFrame:CGRectMake(50, 60, 250, 250)];
	[self.view addSubview:self.circleChart];


## Documentation
___

## Methods

##### - (void)setProgress:(int)progress <br/>
The bread and butter method. Takes the current state of the VAProgressCircle and updates the circle to the progress that was passed

##### - (void)setColor:(UIColor *)color <br/>
Sets the color for all the relevant properties of the circle. This includes circleColor, accentLineColor, and numberLabelColor. Also sets the circleHighlightColor by taking the `(UIColor *)color` and making it slightly transparent

##### - (void)setTransitionColor:(UIColor * )transitionColor <br/>
Sets the transition color for all the relevant properties of the circle. This includes circleTransitionColor, accentLineTransitionColor, and numberLabelTransitionColor. Also sets the circleHighlightTransitionColor by taking the `(UIColor *)transitionColor` and making it slightly transparent

##### - (void)setColor:(UIColor * )color withHighlightColor:(UIColor *)highlightColor <br/>
Functions similar to `- (void)setColor:(UIColor *)color` but allows the specification of a highlightColor

##### - (void)setTransitionColor:(UIColor * )color withHighlightTransitionColor:(UIColor *)highlightColor <br/>
Functions similar to `- (void)setTransitionColor:(UIColor *)transitionColor` but allows the specification of a highlightColor

<br/>

## Properties

##### VAProgressCircleColorTransitionType transitionType <br/>
Should be set to `VAProgressCircleColorTransitionTypeGradual` if you want the spinner to transition to a second color as it approaches 100%. Defaults to `VAProgressCircleColorTransitionTypeNone`

##### float animationSpeed <br/>
Designates how fast the animation should animate. Defaults to `1.0f`

##### BOOL shouldShowAccentLine <br/>
Designates whether or not an accent line should be allocated and animated every time a progress piece reaches the outer circle. Defaults to `YES`

##### BOOL shouldShowFinishedAccentCircle <br/>
Designates whether or not the VAProgressCircle will create a full accent circle when it reaches 100%. Defaults to `YES`

##### BOOL shouldHighlightProgress <br/>
Designates whether or not a progress piece will highlight when it reaches the outer circle. Defaults to `YES`

##### BOOL shouldNumberLabelTransition <br/>
If transitionType is set to `VAProgressCircleColorTransitionTypeGradual`, shouldNumberLabelTransition specifies if the number label should change color along with the rest of the VAProgressCircle. Defaults to `YES` 

##### UIColor *circleColor <br/>
Designates what color the outer circle should be. Defaults to `VADefaultGreen`

##### UIColor *accentLineColor <br/>
Designates what color line the VAProgressCircle generates as a progress piece reaches the outer circle. Defaults to `VADefaultGreen`

##### UIColor *numberLabelColor <br/>
Designates the color of the number label. Defaults to `VADefaultGreen`

##### UIColor *circleHighlightColor <br/>
Designates the highlight color of the progress pieces if `shouldHighlightProgress` is set to `YES`. Defaults to `VADefaultGreen`

##### UIColor *circleTransitionColor <br/>
Designates what color the outer circle should transition to as it approaches 100%. Defaults to `VADefaultBlue`

##### UIColor *accentLineTransitionColor <br/>
Designates what color line the VAProgressCircle generates should transition to as it approaches 100%. Defaults to `VADefaultBlue`

##### UIColor *numberLabelTransitionColor <br/>
Designates the color of the number label should transition to as it approaches 100%. Defaults to `VADefaultBlue`

##### UIColor *circleHighlightTransitionColor <br/>
Designates the transition highlight color of the progress pieces as the VAProgressCircle approaches 100% if `shouldHighlightProgress` is set to `YES`. Defaults to `VADefaultBlue`


## License

VAProgressCircle is available under the MIT license. See the LICENSE file for more info.