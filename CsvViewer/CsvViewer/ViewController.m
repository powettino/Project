//
//  ViewController.m
//  CsvViewer
//
//  Created by Iacopo Peri on 05/12/14.
//  Copyright (c) 2014 Iacopo Peri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *numeroColonne;
@property (weak, nonatomic) IBOutlet UILabel *totaleElementi;
@property (weak, nonatomic) IBOutlet UILabel *numCol;
@property (weak, nonatomic) IBOutlet UILabel *totElem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
