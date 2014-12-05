//
//  OrangeViewController.m
//  Test1
//
//  Created by Iacopo Peri on 28/11/14.
//  Copyright (c) 2014 Iacopo Peri. All rights reserved.
//

#import "OrangeViewController.h"

@interface OrangeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *CloseButton;

@property (weak, nonatomic) IBOutlet UIView *VistaRossa;

@end

@implementation OrangeViewController {
    __weak IBOutlet UIView *Prova;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.VistaRossa setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [Prova setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    
    // Do any additional setup after loading the view.
}
- (IBAction)Cliccato:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
    //[self dismissViewControllerAnimated:true completion:^{}];
}
- (IBAction)Swype1:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
    //    [self dismissViewControllerAnimated:true completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [self.VistaRossa setBackgroundColor:[UIColor colorWithRed:(float)self.red/255.0f green:(float)self.green/255.0f blue:(float)self.blue/255.0f alpha:1]];
                                         }
                                         


@end
