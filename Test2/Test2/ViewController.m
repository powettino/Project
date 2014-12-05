//
//  ViewController.m
//  Test2
//
//  Created by Iacopo Peri on 05/12/14.
//  Copyright (c) 2014 Iacopo Peri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *CircleView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ViewController{
    NSTimer *timerCount;
    int countSec;
}

- (void)startCountDown:(CAShapeLayer *)layer {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.toValue =[NSNumber numberWithFloat:0.5];
    anim.duration = countSec;
    anim.removedOnCompletion =FALSE;
    anim.fillMode = kCAFillModeForwards;
    anim.delegate =self;
    [layer addAnimation:anim forKey:@"strokeAnimation"];
    timerCount =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onChangeTimer) userInfo:nil repeats:true];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
}

-(void) onChangeTimer{
    int curval = [self.countLabel.text intValue];
    if(curval>0)
        curval--;
    self.countLabel.text = [NSString stringWithFormat:@"%d", curval];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    countSec=10;
    //Circle bar animated
    self.CircleView.backgroundColor = [UIColor colorWithRed:0.8 green:0.88 blue:0.8 alpha:1.0];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, self.CircleView.frame.size.width, self.CircleView.frame.size.height);
    layer.path = CGPathCreateWithEllipseInRect(layer.frame, nil);
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.lineWidth = 5;
    layer.strokeStart=0;
    layer.strokeEnd=0.5;
    [self.CircleView.layer addSublayer:layer];
    
    [self startCountDown:layer];
    
    //Circ bar animated
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
