//
//  MainViewController.m
//  VAProgressCircleExample
//
//  Created by Malleo, Mitch on 4/22/15.
//  Copyright (c) 2015 Mitchell Malleo. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property int circleProgress;

@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
@property (weak, nonatomic) IBOutlet UIButton *randomButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIView *actionsView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *primaryColorSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *transitionColorSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *progressChartTransitionTypeSegmentedControl;

@property (strong, nonatomic) VAProgressCircle *circleChart;
@property (strong, nonatomic) NSTimer *randomTimer;

@end

#pragma mark - MainViewController

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.circleProgress = 0;
    
    [self setupUI];
}

- (void)setupUI
{
    [self addChart];
    
    self.actionsView.layer.shadowRadius = 2.0;
    self.actionsView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.actionsView.layer.shadowOpacity = 0.2f;
    self.actionsView.clipsToBounds = NO;
    
    self.primaryColorSegmentedControl.apportionsSegmentWidthsByContent = YES;
    self.transitionColorSegmentedControl.apportionsSegmentWidthsByContent = YES;
}

#pragma mark - Private Methods

- (void)addChart
{
    CGRect mainFrame = [[UIScreen mainScreen] bounds];
    
    self.circleChart = [[VAProgressCircle alloc] initWithFrame:CGRectMake(mainFrame.size.width / 2 - 100, mainFrame.size.height / 4 - 80, 200, 200)];
    [self setPrimaryColorForChart];
    [self setTransitionColorForChart];
    [self setTransitionTypeForChart];
    [self setBlocksForChart];
    
    [self.view addSubview:self.circleChart];
}

- (void)randomIncrement
{
    if(arc4random() % 2 == 1)
    {
        [self addProgress];
    }
}

- (void)setBlocksForChart
{
    self.circleChart.progressBlock = ^(int progress, BOOL isAnimationCompleteForProgress){
        
        //Add custom block functionality here
        
    };
}

- (void)addProgress
{
    int randomIncrement = self.circleProgress + arc4random_uniform(101 - self.circleProgress) / 3;
    
    if(self.circleProgress != randomIncrement && randomIncrement > self.circleProgress)
    {
        self.circleProgress = randomIncrement;
        [self.circleChart setProgress:self.circleProgress];
    }
    else
    {
        self.circleProgress++;
        [self.circleChart setProgress:self.circleProgress];
    }
}

- (void)setPrimaryColorForChart
{
    switch (self.primaryColorSegmentedControl.selectedSegmentIndex)
    {
        case 0:
        {
            if(self.circleChart.circleColor != VADefaultGreen)
            {
                [self.circleChart setColor:VADefaultGreen withHighlightColor:VADefaultGreen];
            }
        }
            break;
            
        case 1:
        {
            if(self.circleChart.circleColor != [UIColor redColor])
            {
                [self.circleChart setColor:[UIColor redColor]];
            }
        }
            break;
            
        case 2:
        {
            if(self.circleChart.circleColor != [UIColor blueColor])
            {
                [self.circleChart setColor:[UIColor blueColor]];
            }
        }
            break;
            
        case 3:
        {
            if(self.circleChart.circleColor != [UIColor blackColor])
            {
                [self.circleChart setColor:[UIColor blackColor]];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)setTransitionColorForChart
{
    switch (self.transitionColorSegmentedControl.selectedSegmentIndex)
    {
        case 0:
            [self.circleChart setTransitionColor:VADefaultBlue withHighlightTransitionColor:VADefaultBlue];
            break;
            
        case 1:
            [self.circleChart setTransitionColor:[UIColor orangeColor]];
            break;
            
        case 2:
            [self.circleChart setTransitionColor:[UIColor purpleColor]];
            break;
            
        case 3:
            [self.circleChart setTransitionColor:[UIColor whiteColor]];
            break;
            
        default:
            break;
    }
}

- (void)setTransitionTypeForChart
{
    switch (self.progressChartTransitionTypeSegmentedControl.selectedSegmentIndex)
    {
        case 0:
            self.circleChart.transitionType = VAProgressCircleColorTransitionTypeGradual;
            break;
            
        case 1:
            self.circleChart.transitionType = VAProgressCircleColorTransitionTypeNone;
            break;
            
        default:
            break;
    }
}

- (void)resetChart
{
    self.circleProgress = 0;
    
    if([self.randomTimer isValid])
    {
        [self.randomTimer invalidate];
    }
    
    [self.circleChart removeFromSuperview];
    self.circleChart = nil;
    
    [self addChart];
}

#pragma mark - IBActions

- (IBAction)increaseButtonWasTouched:(id)sender
{
    [self addProgress];
}

- (IBAction)randomButtonWasTouched:(id)sender
{
    if(self.circleChart)
    {
        [self resetChart];
    }
    
    self.randomTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                        target:self
                                                      selector:@selector(randomIncrement)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (IBAction)resetButtonWasTouched:(id)sender
{
    [self resetChart];
}

- (IBAction)primaryColorSegmentedControlWasTouched:(id)sender
{
    [self setPrimaryColorForChart];
}

- (IBAction)transitionColorSegmentedControlWasTouched:(id)sender
{
    [self setTransitionColorForChart];
}

- (IBAction)progressChartTransitionTypeSegmentedControlWasTouched:(id)sender
{
    [self setTransitionTypeForChart];
}

@end
