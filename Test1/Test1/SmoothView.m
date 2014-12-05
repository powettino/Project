//
//  SmoothView.m
//  Test1
//
//  Created by Iacopo Peri on 28/11/14.
//  Copyright (c) 2014 Iacopo Peri. All rights reserved.
//

#import "SmoothView.h"

@implementation SmoothView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) awakeFromNib{
    float radius = 30;
    self.layer.cornerRadius=10;
    float centerX = self.frame.size.width/2;
    float centerY =self.frame.size.height/2;
    
    CAShapeLayer * circle = [CAShapeLayer layer];
    [circle setFillColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor];
    circle.frame = CGRectMake(centerX-radius, centerY-radius, 60, 60);
    circle.cornerRadius = radius;
    [self.layer addSublayer:circle];
    
}

@end
