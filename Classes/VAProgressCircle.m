//
//  VAProgressCircle.m
//  VAProgressCircleExample
//
//  Created by Malleo, Mitch on 4/22/15.
//  Copyright (c) 2015 Mitchell Malleo. All rights reserved.
//

#import "VAProgressCircle.h"
#import "UIProgressLabel.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define kName @"name"
#define kLayer @"layer"
#define kLine @"line"
#define kCurrent @"current"

#define kProgressPieceIncreaseLineWidthAnimation @"increaseLineWidthAnimation"
#define kProgressPieceInnerToOuterMoveAnimation @"innerToOuterMoveAnimation"
#define kProgressPieceFlashStartAnimation @"flashStartAnimation"
#define kProgressPieceFlashFadeAnimation @"flashFadeAnimation"

#define kProgressPieceLineMoveAnimation @"lineMoveAnimation"
#define kProgressPieceLineFadeAnimation @"lineFadeAnimation"
#define kProgressPieceLineIsFinishedNarrowAnimation @"lineIsFinishedNarrowAnimation"
#define kProgressPieceLineIsFinishedRetractAnimation @"lineIsFinishedRetractAnimation"

typedef enum{
    UIColorRed = 0,
    UIColorGreen = 1,
    UIColorBlue = 2
} UIColorRGBIndex;

@interface VAProgressCircle()

@property (strong, nonatomic) CAShapeLayer *backgroundCircle;

@property (strong, nonatomic) UIBezierPath *backgroundCirclePath;
@property (strong, nonatomic) UIBezierPath *innerBackgroundPath;
@property (strong, nonatomic) UIBezierPath *outerBackgroundPath;
@property (strong, nonatomic) UIBezierPath *numberViewPath;

@property (strong, nonatomic) UIView *progressPieceView;
@property (strong, nonatomic) UIView *numberView;
@property (strong, nonatomic) UIProgressLabel *numberLabel;

@property (strong, nonatomic) NSMutableArray *progressPieceArray;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (nonatomic) CGFloat total;

@end

#pragma mark - VAProgressCircle

@implementation VAProgressCircle

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self setupDefaults];
        [self setupLines];
        [self setupViews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self setupDefaults];
        [self setupLines];
        [self setupViews];
    }
    
    return self;
}

- (void)setupDefaults
{
    self.total = 0;
    self.animationSpeed = 1.0;
    
    self.circleColor = VADefaultGreen;
    self.accentLineColor = VADefaultGreen;
    self.numberLabelColor = VADefaultGreen;
    self.circleHighlightColor = [self colorConvertedToRGBA:VADefaultGreen isColorHighlightColor:YES];
    
    self.circleTransitionColor = VADefaultBlue;
    self.accentLineTransitionColor = VADefaultBlue;
    self.numberLabelTransitionColor = VADefaultBlue;
    self.circleHighlightTransitionColor = [self colorConvertedToRGBA:VADefaultBlue isColorHighlightColor:YES];
    
    self.finished = NO;
    self.shouldShowAccentLine = YES;
    self.shouldShowFinishedAccentCircle = YES;
    self.shouldHighlightProgress = YES;
    self.shouldNumberLabelTransition = YES;
    
    self.transitionType = VAProgressCircleColorTransitionTypeNone;
    self.rotationDirection = VAProgressCircleRotationDirectionCounterClockwise;
    
    self.progressPieceArray = [[NSMutableArray alloc] init];
}

- (void)setupViews
{
    self.progressPieceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - self.backgroundCircle.lineWidth * 2, self.frame.size.height)];
    [self addSubview:self.progressPieceView];
    
    self.numberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 6, self.frame.size.height / 6)];
    self.numberView.layer.cornerRadius = self.numberView.frame.size.width / 2;
    self.numberView.center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y);
    [self.numberView setBackgroundColor:[UIColor whiteColor]];
    
    self.numberLabel = [[UIProgressLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 6, self.frame.size.height / 6)];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:self.numberView.frame.size.width / 2];
    [self.numberLabel setText:[NSString stringWithFormat:@"%i", (int)self.total]];
    [self.numberLabel setTextColor:self.numberLabelColor];
    
    [self.numberView addSubview:self.numberLabel];
    [self addSubview:self.numberView];
}

- (void)setupLines
{
    self.backgroundCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y) radius:self.frame.size.height * 0.5 startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(270.01) clockwise:NO];
    
    self.backgroundCircle = [CAShapeLayer layer];
    self.backgroundCircle.path = self.backgroundCirclePath.CGPath;
    self.backgroundCircle.lineCap = kCALineCapRound;
    self.backgroundCircle.fillColor = [UIColor clearColor].CGColor;
    self.backgroundCircle.lineWidth = [[NSNumber numberWithInt:self.frame.size.width / 12] floatValue];
    self.backgroundCircle.strokeColor = [UIColor whiteColor].CGColor;
    self.backgroundCircle.strokeEnd = 1.0;
    self.backgroundCircle.zPosition = -1;
    
    self.innerBackgroundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y- self.frame.origin.y) radius:self.frame.size.height * 0.5 + self.backgroundCircle.lineWidth / 2 startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(270.01) clockwise:NO];
    
    self.outerBackgroundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y) radius:self.frame.size.height * 0.5 + self.backgroundCircle.lineWidth * 2.5 startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(270.01) clockwise:NO];
    
    self.numberViewPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y) radius:self.frame.size.height * 0.07 startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(270.01) clockwise:NO];
    
    [self.layer addSublayer:self.backgroundCircle];
}

#pragma mark - Public Methods

- (void)setRotationDirection:(VAProgressCircleRotationDirection)rotationDirection
{
    if(_rotationDirection != rotationDirection)
    {
        [self invertPathToOppositeRotationDirection:self.backgroundCirclePath];
        [self invertPathToOppositeRotationDirection:self.innerBackgroundPath];
        [self invertPathToOppositeRotationDirection:self.outerBackgroundPath];
        [self invertPathToOppositeRotationDirection:self.numberViewPath];
        
        _rotationDirection = rotationDirection;
    }
}

- (void)setColor:(UIColor *)color
{
    self.circleColor = color;
    self.accentLineColor = color;
    self.numberLabelColor = color;
    self.numberLabel.textColor = self.numberLabelColor;
    self.circleHighlightColor = [self colorConvertedToRGBA:color isColorHighlightColor:YES];
}

- (void)setTransitionColor:(UIColor *)transitionColor
{
    self.circleTransitionColor = transitionColor;
    self.accentLineTransitionColor = transitionColor;
    self.numberLabelTransitionColor = transitionColor;
    self.circleHighlightTransitionColor = [self colorConvertedToRGBA:transitionColor isColorHighlightColor:YES];
}

- (void)setColor:(UIColor *)color withHighlightColor:(UIColor *)highlightColor
{
    self.circleColor = color;
    self.accentLineColor = color;
    self.numberLabelColor = color;
    self.numberLabel.textColor = self.numberLabelColor;
    self.circleHighlightColor = highlightColor;
}

- (void)setTransitionColor:(UIColor *)color withHighlightTransitionColor:(UIColor *)highlightColor
{
    self.circleTransitionColor = color;
    self.accentLineTransitionColor = color;
    self.numberLabelTransitionColor = color;
    self.circleHighlightTransitionColor = highlightColor;
}

- (void)setProgress:(int)progress
{
    CGFloat floatProgress = (CGFloat)progress;
    
    CAShapeLayer *progressPiece = [CAShapeLayer layer];
    progressPiece.path = self.numberViewPath.CGPath;
    progressPiece.strokeStart = self.total / 100;
    progressPiece.strokeEnd = (floatProgress / 100) + 0.0004;
    progressPiece.lineWidth = [[NSNumber numberWithInt:self.frame.size.width / 100] floatValue];
    
    if(self.transitionType == VAProgressCircleColorTransitionTypeGradual)
    {
        progressPiece.strokeColor = [self transitionFromColor:self.circleColor toColor:self.circleTransitionColor WithProgress:floatProgress].CGColor;
    }
    else
    {
        progressPiece.strokeColor = self.circleColor.CGColor;
    }
    
    progressPiece.backgroundColor = [UIColor whiteColor].CGColor;
    progressPiece.fillColor = [UIColor clearColor].CGColor;
    
    CAShapeLayer *progressPieceLine = [CAShapeLayer layer];
    progressPieceLine.path = self.innerBackgroundPath.CGPath;
    progressPieceLine.strokeStart = self.total / 100;
    progressPieceLine.strokeEnd = (floatProgress / 100) + 0.001;
    progressPieceLine.lineWidth = [[NSNumber numberWithInt:self.frame.size.width / 100] floatValue];
    
    if(self.transitionType == VAProgressCircleColorTransitionTypeGradual)
    {
        progressPieceLine.strokeColor = [self transitionFromColor:self.circleColor toColor:self.circleTransitionColor WithProgress:floatProgress].CGColor;
    }
    else
    {
        progressPieceLine.strokeColor = self.circleColor.CGColor;
    }
    
    progressPieceLine.fillColor = [UIColor clearColor].CGColor;
    
    [self.progressPieceView.layer addSublayer:progressPiece];
    
    if(floatProgress >= 100)
    {
        self.total = 100;
        
        if(!self.isFinished && self.shouldShowFinishedAccentCircle)
        {
            progressPieceLine.strokeStart = 0.0;
            progressPieceLine.strokeEnd = 100.001;
            self.finished = YES;
        }
    }
    else
    {
        self.total = floatProgress;
    }
    
    [progressPiece setValue:progressPieceLine forKey:kLine];
    
    CABasicAnimation *increaseLineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    increaseLineWidthAnimation.delegate = self;
    increaseLineWidthAnimation.beginTime = 0.0;
    increaseLineWidthAnimation.duration = 0.1;
    increaseLineWidthAnimation.speed = self.animationSpeed;
    increaseLineWidthAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    increaseLineWidthAnimation.fromValue = [NSNumber numberWithInt:self.frame.size.width / 100];
    increaseLineWidthAnimation.toValue = [NSNumber numberWithInt:self.frame.size.width / 12];
    [increaseLineWidthAnimation setValue:progressPiece forKey:kLayer];
    [increaseLineWidthAnimation setValue:kProgressPieceIncreaseLineWidthAnimation forKey:kName];
    
    CABasicAnimation *innerToOuterMoveAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    innerToOuterMoveAnimation.delegate = self;
    innerToOuterMoveAnimation.beginTime = CACurrentMediaTime() + 0.4 / self.animationSpeed;
    innerToOuterMoveAnimation.duration = 0.5;
    innerToOuterMoveAnimation.speed = self.animationSpeed;
    innerToOuterMoveAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.1 :0.25 :0.88 :0.0];
    innerToOuterMoveAnimation.fromValue = (id)self.numberViewPath.CGPath;
    innerToOuterMoveAnimation.toValue = (id)self.backgroundCirclePath.CGPath;
    [innerToOuterMoveAnimation setValue:progressPiece forKey:kLayer];
    [innerToOuterMoveAnimation setValue:kProgressPieceInnerToOuterMoveAnimation forKey:kName];
    
    CABasicAnimation *flashStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    flashStartAnimation.delegate = self;
    flashStartAnimation.beginTime = CACurrentMediaTime() + 0.9 / self.animationSpeed;
    flashStartAnimation.speed = self.animationSpeed;
    flashStartAnimation.duration = 0.1;
    flashStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    flashStartAnimation.fromValue = self.circleColor;
    
    if(self.shouldHighlightProgress)
    {
        flashStartAnimation.toValue = self.circleHighlightColor;
    }
    else if(self.transitionType == VAProgressCircleColorTransitionTypeGradual)
    {
        flashStartAnimation.toValue = [self transitionFromColor:self.circleColor toColor:self.circleTransitionColor WithProgress:floatProgress];
    }
    else
    {
        flashStartAnimation.toValue = self.circleColor;
    }
    
    [flashStartAnimation setValue:progressPiece forKey:kLayer];
    [flashStartAnimation setValue:kProgressPieceFlashStartAnimation forKey:kName];
    [flashStartAnimation setValue:[NSNumber numberWithFloat:self.total] forKey:kCurrent];
    
    CABasicAnimation *flashFadeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeColorFade"];
    flashFadeAnimation.delegate = self;
    flashFadeAnimation.beginTime = CACurrentMediaTime() + 1.2 / self.animationSpeed;
    flashFadeAnimation.speed = self.animationSpeed;
    flashFadeAnimation.duration = 0.5;
    flashFadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    if(self.shouldHighlightProgress)
    {
        flashFadeAnimation.fromValue = self.circleHighlightColor;
    }
    else
    {
        flashFadeAnimation.fromValue = self.circleColor;
    }
    
    flashFadeAnimation.toValue = self.circleColor;
    [flashFadeAnimation setValue:progressPiece forKey:kLayer];
    [flashFadeAnimation setValue:[NSNumber numberWithFloat:self.total] forKey:kCurrent];
    [flashFadeAnimation setValue:kProgressPieceFlashFadeAnimation forKey:kName];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        [progressPiece addAnimation:innerToOuterMoveAnimation forKey:@"path"];
        [progressPiece addAnimation:increaseLineWidthAnimation forKey:@"lineWidth"];
        [progressPiece addAnimation:flashStartAnimation forKey:@"strokeColor"];
        [progressPiece addAnimation:flashFadeAnimation forKey:@"strokeColorFade"];
    });
}

#pragma mark - Private Methods

- (void)invertPathToOppositeRotationDirection:(UIBezierPath *)path
{
    CGAffineTransform mirrorOverXOrigin = CGAffineTransformMakeScale(-1.0f, 1.0f);
    CGAffineTransform translate = CGAffineTransformMakeTranslation(self.frame.size.width, 0);
    [path applyTransform:mirrorOverXOrigin];
    [path applyTransform:translate];
}

- (UIColor *)colorConvertedToRGBA:(UIColor *)colorToConvert isColorHighlightColor:(BOOL)isHighlight;
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    alpha = CGColorGetAlpha(colorToConvert.CGColor);
    
    CGColorRef opaqueColor = CGColorCreateCopyWithAlpha(colorToConvert.CGColor, 1.0f);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[CGColorSpaceGetNumberOfComponents(rgbColorSpace)];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, opaqueColor);
    CGColorRelease(opaqueColor);
    CGContextFillRect(context, CGRectMake(0.f, 0.f, 1.f, 1.f));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    if(!isHighlight)
    {
        red = resultingPixel[0] / 255.0f;
        green = resultingPixel[1] / 255.0f;
        blue = resultingPixel[2] / 255.0f;
    }
    else
    {
        red = (resultingPixel[0] * 0.2 + resultingPixel[0]) / 255.0f;
        green = (resultingPixel[1] * 0.2 + resultingPixel[1]) / 255.0f;
        blue = (resultingPixel[2] * 0.2 + resultingPixel[2]) / 255.0f;
    }
    
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)transitionFromColor:(UIColor *)originalColor toColor:(UIColor *)transitionColor WithProgress:(CGFloat)progress
{
    UIColor *intermittentColor;
    
    if(progress < 100)
    {
        CGFloat progressPercentage = progress / 100;
        CGFloat progressPercentageInversion = 1 - progressPercentage;
        originalColor = [self colorConvertedToRGBA:originalColor isColorHighlightColor:NO];
        transitionColor = [self colorConvertedToRGBA:transitionColor isColorHighlightColor:NO];
        const CGFloat *colorComponents = CGColorGetComponents(originalColor.CGColor);
        const CGFloat *transitionColorComponents = CGColorGetComponents(transitionColor.CGColor);
    
        CGFloat red = transitionColorComponents[UIColorRed] * progressPercentage + colorComponents[UIColorRed] * progressPercentageInversion;
        CGFloat green = transitionColorComponents[UIColorGreen] * progressPercentage + colorComponents[UIColorGreen] * progressPercentageInversion;
        CGFloat blue = transitionColorComponents[UIColorBlue] * progressPercentage + colorComponents[UIColorBlue] * progressPercentageInversion;
        
        intermittentColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    }
    else
    {
        intermittentColor = transitionColor;
    }
    
    return intermittentColor;
}

- (void)addProgressPieceLine:(CAShapeLayer *)progressPieceLine withCurrent:(float)current
{
    BOOL shouldAnimateFullCircle = (current == [[NSNumber numberWithInt:100] floatValue]);
    
    CABasicAnimation *lineMoveAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    lineMoveAnimation.delegate = self;
    lineMoveAnimation.beginTime = 0.0f;
    lineMoveAnimation.duration = 0.8;
    lineMoveAnimation.speed = self.animationSpeed;
    lineMoveAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.1 :0.33 :0.33 :0.33];
    lineMoveAnimation.fromValue = (id)self.innerBackgroundPath.CGPath;
    lineMoveAnimation.toValue = (id)self.outerBackgroundPath.CGPath;
    [lineMoveAnimation setValue:progressPieceLine forKey:kLayer];
    [lineMoveAnimation setValue:kProgressPieceLineMoveAnimation forKey:kName];
    
    CABasicAnimation *lineFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    lineFadeAnimation.delegate = self;
    lineFadeAnimation.beginTime = CACurrentMediaTime() + 0.3f / self.animationSpeed;
    lineFadeAnimation.duration = 0.8;
    lineFadeAnimation.speed = self.animationSpeed;
    lineFadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    lineFadeAnimation.fromValue = [NSNumber numberWithInt:1.0];
    lineFadeAnimation.toValue = [NSNumber numberWithInt:0.1];
    [lineFadeAnimation setValue:progressPieceLine forKey:kLayer];
    [lineFadeAnimation setValue:kProgressPieceLineFadeAnimation forKey:kName];
    
    CABasicAnimation *lineIsFinishedNarrowAnimation;
    CABasicAnimation *lineIsFinishedRetractAnimation;
    
    if(shouldAnimateFullCircle && self.shouldShowFinishedAccentCircle)
    {
        lineMoveAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.33 :0.88 :0.33 :0.88];
        
        lineIsFinishedNarrowAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
        lineIsFinishedNarrowAnimation.delegate = self;
        lineIsFinishedNarrowAnimation.beginTime = CACurrentMediaTime() + 0.3f / self.animationSpeed;
        lineIsFinishedNarrowAnimation.duration = 0.7;
        lineIsFinishedNarrowAnimation.speed = self.animationSpeed;
        lineIsFinishedNarrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        lineIsFinishedNarrowAnimation.fromValue = [NSNumber numberWithInt:progressPieceLine.lineWidth];
        lineIsFinishedNarrowAnimation.toValue = [NSNumber numberWithInt:progressPieceLine.lineWidth / 4];
        [lineIsFinishedNarrowAnimation setValue:progressPieceLine forKey:kLayer];
        [lineIsFinishedNarrowAnimation setValue:kProgressPieceLineIsFinishedNarrowAnimation forKey:kName];
        
        lineIsFinishedRetractAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        lineIsFinishedRetractAnimation.delegate = self;
        lineIsFinishedRetractAnimation.beginTime = CACurrentMediaTime() + 0.7f / self.animationSpeed;
        lineIsFinishedRetractAnimation.duration = 0.3;
        lineIsFinishedRetractAnimation.speed = self.animationSpeed;
        lineIsFinishedRetractAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.77 :0.33 :0.77 :0.33];
        lineIsFinishedRetractAnimation.fromValue = (id)self.outerBackgroundPath.CGPath;
        lineIsFinishedRetractAnimation.toValue = (id)self.innerBackgroundPath.CGPath;
        [lineIsFinishedRetractAnimation setValue:progressPieceLine forKey:kLayer];
        [lineIsFinishedRetractAnimation setValue:kProgressPieceLineIsFinishedRetractAnimation forKey:kName];
    }
    
    [self.progressPieceView.layer addSublayer:progressPieceLine];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        if(shouldAnimateFullCircle && self.shouldShowFinishedAccentCircle)
        {
            [progressPieceLine addAnimation:lineMoveAnimation forKey:@"path"];
            [progressPieceLine addAnimation:lineIsFinishedNarrowAnimation forKey:@"lineWidth"];
            [progressPieceLine addAnimation:lineIsFinishedRetractAnimation forKey:@"pathRetract"];
        }
        else
        {
            [progressPieceLine addAnimation:lineMoveAnimation forKey:@"path"];
            [progressPieceLine addAnimation:lineFadeAnimation forKey:@"opacity"];
        }
    });
}

#pragma mark - CABasicAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    NSString *name = [anim valueForKey:kName];
    CAShapeLayer *progressLayer = [anim valueForKey:kLayer];
    
    
    if([name  isEqualToString:kProgressPieceInnerToOuterMoveAnimation])
    {
        progressLayer.path = self.backgroundCirclePath.CGPath;
    }
    else if([name isEqualToString:kProgressPieceIncreaseLineWidthAnimation])
    {
        progressLayer.lineWidth = [[NSNumber numberWithInt:self.frame.size.width / 12] floatValue];
    }
    else if([name isEqualToString:kProgressPieceFlashStartAnimation])
    {
        NSNumber *current = [anim valueForKey:kCurrent];
        
        CAShapeLayer *progressPieceLine = [progressLayer valueForKey:kLine];

        if(self.transitionType == VAProgressCircleColorTransitionTypeGradual)
        {
            for (CAShapeLayer *pastProgressPiece in self.progressPieceArray)
            {
                pastProgressPiece.strokeColor = progressLayer.strokeColor;
            }
            
            [self.progressPieceArray addObject:progressLayer];
        }
        
        if(self.transitionType == VAProgressCircleColorTransitionTypeGradual && self.shouldNumberLabelTransition)
        {
            [self.numberLabel setTextColor:[self transitionFromColor:self.numberLabelColor toColor:self.numberLabelTransitionColor WithProgress:[current floatValue]]];
        }
        else
        {
            [self.numberLabel setTextColor:self.numberLabelColor];
        }
        
        if(self.shouldShowAccentLine)
        {
           [self addProgressPieceLine:progressPieceLine withCurrent:[current floatValue]];
        }
        
        if(self.transitionType == VAProgressCircleColorTransitionTypeGradual && self.shouldHighlightProgress)
        {
            progressLayer.strokeColor = [[self transitionFromColor:self.circleHighlightColor toColor:self.circleHighlightTransitionColor WithProgress:[current floatValue]] colorWithAlphaComponent:0.8f].CGColor;
        }
        else if(self.shouldHighlightProgress)
        {
            progressLayer.strokeColor = self.circleHighlightColor.CGColor;
        }
        else if(!self.shouldHighlightProgress)
        {
            progressLayer.strokeColor = progressLayer.strokeColor;
        }
        else
        {
            progressLayer.strokeColor = self.circleColor.CGColor;
        }
        
        [self.numberLabel countToNumber:[current intValue]];
    }
    else if([name isEqualToString:kProgressPieceFlashFadeAnimation])
    {
        NSNumber *current = [anim valueForKey:kCurrent];
        
        if(self.transitionType == VAProgressCircleColorTransitionTypeGradual)
        {
            for (CAShapeLayer *pastProgressPiece in self.progressPieceArray)
            {
                pastProgressPiece.strokeColor = [self transitionFromColor:self.circleColor toColor:self.circleTransitionColor WithProgress:[current floatValue]].CGColor;
            }
            
            progressLayer.strokeColor = [self transitionFromColor:self.circleColor toColor:self.circleTransitionColor WithProgress:[current floatValue]].CGColor;
        }
        else
        {
            progressLayer.strokeColor = self.circleColor.CGColor;
        }
    }
    else if([name isEqualToString:kProgressPieceLineMoveAnimation])
    {
        progressLayer.path = self.outerBackgroundPath.CGPath;
    }
    else if([name isEqualToString:kProgressPieceLineFadeAnimation])
    {
        progressLayer.opacity = 0.0f;
    }
    else if([name isEqualToString:kProgressPieceLineIsFinishedNarrowAnimation])
    {
        progressLayer.lineWidth = progressLayer.lineWidth / 4;
    }
    else if([name isEqualToString:kProgressPieceLineIsFinishedRetractAnimation])
    {
        progressLayer.path = self.innerBackgroundPath.CGPath;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString *name = [anim valueForKey:kName];
    CAShapeLayer *progressLayer = [anim valueForKey:kLayer];
    
    if([name isEqualToString:kProgressPieceLineIsFinishedRetractAnimation])
    {
        [progressLayer removeFromSuperlayer];
    }
}

@end
