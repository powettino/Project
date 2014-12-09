//
//  ViewController.m
//  CsvViewer
//
//  Created by Iacopo Peri on 05/12/14.
//  Copyright (c) 2014 Iacopo Peri. All rights reserved.
//

#import "ViewController.h"
#import "GraphBarView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *numeroColonne;
@property (weak, nonatomic) IBOutlet UILabel *totaleElementi;
@property (weak, nonatomic) IBOutlet UILabel *numCol;
@property (weak, nonatomic) IBOutlet UILabel *totElem;
@property (weak, nonatomic) IBOutlet GraphBarView *graphView;


@end

@implementation ViewController{
    UIView *coveringDrawView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self roundLabel:self.fileName];
    [self roundLabel:self.numeroColonne];
    [self roundLabel:self.totaleElementi];
    [self roundLabel:self.numCol];
    [self roundLabel:self.totElem];
    coveringDrawView = [[UIView alloc] initWithFrame:CGRectMake(self.graphView.frame.origin.x
                                               ,self.graphView.frame.origin.y
                                               ,self.graphView.frame.size.width,self.graphView.frame.size.height)];
    [coveringDrawView setBackgroundColor:[UIColor blackColor]];
    [coveringDrawView setAlpha:0.0];

    [self.view addSubview:coveringDrawView];
    
    [UIView animateWithDuration:1 animations:^{
        [coveringDrawView setAlpha:0.5];
    }];

    
    //    [UIView animateWithDuration:1 animations:^{
//        [self.overlay setAlpha:0.5];
//        [self.overlay setFrame:fra];
//    }];
    

    
    //    CAShapeLayer *l = [CAShapeLayer layer];
    //    l.path=CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 10, 10), nil);
    //    l.strokeColor = [UIColor blackColor].CGColor;
    //    l.lineWidth = 2;
    
    //    l.fillColor = [UIColor whiteColor].CGColor;
    //    self.FadingButton.alpha =0;
    //    [UIView animateWithDuration:2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{self.FadingButton.alpha=1;} completion:^(BOOL finished){}];
    //    // Do any additional setup after loading the view, typically from a nib.
}

- (void) roundLabel:(UILabel*)label{
    [label setBackgroundColor:[UIColor clearColor]];
    [label.layer setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5].CGColor];
    [label.layer setCornerRadius:5];
    [label.layer setBorderWidth:1.0];
    [label.layer setBorderColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5].CGColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
