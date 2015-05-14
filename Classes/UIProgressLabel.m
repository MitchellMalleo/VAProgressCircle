//
//  UIProgressLabel.m
//  VAProgressCircleExample
//
//  Created by Malleo, Mitch on 5/4/15.
//  Copyright (c) 2015 Mitchell Malleo. All rights reserved.
//

#import "UIProgressLabel.h"

@interface UIProgressLabel()

@property (strong, nonatomic) NSTimer *countUpTimer;
@property (nonatomic) int countUpToNumber;
@property (nonatomic) int currentNumber;

@end

#pragma mark - UIProgressLabel

@implementation UIProgressLabel

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self setupDefaults];
        [self setupTimer];
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)countToNumber:(int)number
{
    if(number > [self.text intValue])
    {
        self.text = [NSString stringWithFormat:@"%i", self.countUpToNumber];
        self.currentNumber = self.countUpToNumber;
    }
    
    self.countUpToNumber = number;
    
    [[NSRunLoop mainRunLoop] addTimer:self.countUpTimer forMode:NSDefaultRunLoopMode];
}

#pragma mark - Private Methods

- (void)setupDefaults
{
    self.text = @"0";
    self.currentNumber = 0;
}

- (void)setupTimer
{
    self.countUpTimer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(count) userInfo:nil repeats:YES];
}

- (void)count
{
    self.currentNumber++;
    
    self.text = [NSString stringWithFormat:@"%i", self.currentNumber];
    
    if(self.currentNumber == self.countUpToNumber)
    {
        [self.countUpTimer invalidate];
        
        if(self.currentNumber != 100)
        {
            [self setupTimer];
        }
    }
}

@end
