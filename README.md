# VAProgressCircle

![](https://github.com/MitchellMalleo/VAProgressCircle/blob/master/vaProgressCircle.gif)

## Description

VAProgressCircle is a custom loading animation for loading iOS content from 0 to 100%.

## Requirements

- ARC
- iOS 5.0+

## Installation

1. VAProgressCircle can be installed via [Cocoapods](http://cocoapods.org/) by adding `pod 'VAProgressCircle'` to your podfile, or you can manually add `UICountingLabel.h/.m` and `VAProgressCircle.h/.m` into your project.
2. Either create a VAProgressCircle by using a UIView in your Interface Builder, subclassing it to VAProgressCircle, and linking it up to a property in your UIViewController or by using `- (id)initWithFrame:(CGRect)frame`

    ```
    self.progressCircle = [[VAProgressCircle alloc] initWithFrame:CGRectMake(50, 60, 250, 250)];
[self.view addSubview:self.circleChart];
    ```

## Usage
Set the base color of your VAProgressCircle.

	[self.progressCircle setColor:[UIColor greenColor]];
	
	//Or you can specify a highlight color with your base color

	[self.progressCircle setColor:[UIColor greenColor] withHighlightColor:VADefaultGreen];

VAProgressCircle has the ability to transition from one color to another as it reaches 100%. This can be enabled by setting your `transitionType`.

	self.progressCircle.transitionType = VAProgressCircleColorTransitionTypeGradual;

Set the transition color of your VAProgressCircle.

	[self.progressCircle setTransitionColor:[UIColor blueColor]];
	
	//Or you can specify a highlight color with your transition color

	[self.progressCircle setColor:[UIColor blueColor] withHighlightTransitionColor:VADefaultBlue];
	
Use the progessBlock to add functionality to execute before or after a progress piece has finished animating
    
    self.circleChart.progressBlock = ^(int progress, BOOL isAnimationCompleteForProgress){
        
        //Add custom block functionality here
        
    };
    
If you need the delegate pattern, do not implement the block and set your delegate and they will get called instead

	- (void)viewDidLoad
	{
    	self.progressCircle.delegate = self;
	}
	
	#pragma mark - VAProgressCircleDelegate

    - (void)progressCircle:(VAProgressCircle *)circle willAnimateToProgress:(int)progress
	{
    	//Add custom delegate functionality here
	}

	- (void)progressCircle:(VAProgressCircle *)circle didAnimateToProgress:(int)progress
	{
    	//Add custom delegate functionality here
	}

Toggle animation features of the VAProgressCircle.

	@property BOOL shouldShowAccentLine;
	@property BOOL shouldShowFinishedAccentCircle;
	@property BOOL shouldHighlightProgress;
	@property BOOL shouldNumberLabelTransition;

Set the rotation direction of your VAProgressCircle.

	self.progressCircle.rotationDirection = VAProgressCircleRotationDirectionClockwise;

## License

VAProgressCircle is available under the MIT license. See the LICENSE file for more info.