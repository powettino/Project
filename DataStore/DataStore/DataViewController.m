//
//  DataViewController.m
//  DataStore
//
//  Created by Iacopo Peri on 13/03/15.
//  Copyright (c) 2015 Iacopo Peri. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *familyNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *employmentLabel;
@property (weak, nonatomic) IBOutlet UIButton *ok;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)okPreseed:(id)sender {
    
    self.firstName = _firstNameLabel.text;
    self.familyName = _familyNameLabel.text;
    self.employment = _employmentLabel.text;
    self.isOk = true;
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)cancelPressed:(id)sender {
    self.isOk = false;
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
