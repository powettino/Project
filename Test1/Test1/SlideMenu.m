//
//  SlideMenu.m
//  Test1
//
//  Created by Iacopo Peri on 28/11/14.
//  Copyright (c) 2014 Iacopo Peri. All rights reserved.
//

#import "SlideMenu.h"

@interface SlideMenu ()
@property (weak, nonatomic) IBOutlet UIButton *ButtonLayer;

@end

@implementation SlideMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.ButtonLayer.layer setBackgroundColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.8 alpha:1.0].CGColor];
    [self.ButtonLayer.layer setCornerRadius:5];
    
    CAShapeLayer *l = [CAShapeLayer layer];
    l.path=CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 10, 10), nil);
    l.strokeColor = [UIColor blackColor].CGColor;
    l.lineWidth = 2;
    l.fillColor = [UIColor whiteColor].CGColor;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
