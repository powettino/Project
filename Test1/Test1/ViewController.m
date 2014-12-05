//
//  ViewController.m
//  Test1
//
//  Created by Iacopo Peri on 28/11/14.
//  Copyright (c) 2014 Iacopo Peri. All rights reserved.
//

#import "ViewController.h"
#import "OrangeViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *red;
@property (weak, nonatomic) IBOutlet UITextField *blue;
@property (weak, nonatomic) IBOutlet UITextField *green;
@property (weak, nonatomic) IBOutlet UIView *overlay;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation ViewController{
    bool isOrangeActive;
    OrangeViewController *orangeView;
    NSTimer *timer;
}
- (IBAction)Fiqo:(id)sender {
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:false];
   CGRect fra = [self.overlay frame];
  self.overlay.frame = CGRectMake(0, self.view.frame.size.height, fra.size.width, fra.size.height);
   [UIView animateWithDuration:1 animations:^{
        [self.overlay setAlpha:0.5];
        [self.overlay setFrame:fra];
    }];
    
    [self.activity setHidden:false];
    [self.activity startAnimating];
}

- (void) onTimer {
     [self performSegueWithIdentifier:@"ShowDiVista" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self performSegueWithIdentifier:@"ShowDiVista" sender:self];
    isOrangeActive=false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [self.overlay setAlpha:0];
    [self.activity stopAnimating];
    
}
-(void) viewDidAppear:(BOOL)animated{
    if(isOrangeActive){
        isOrangeActive=false;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bei colori!" message:[NSString stringWithFormat:@"I tuoi colori precedenti erano: red %d blu %d verde %d",orangeView.red, orangeView.blue, orangeView.green] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowDiVista"]) {
        orangeView = segue.destinationViewController;
        orangeView.red= [self.red.text intValue];
        orangeView.blue = [self.blue.text intValue];
        orangeView.green = [self.green.text intValue];
        isOrangeActive=true;
    }
}


@end
