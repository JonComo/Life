//
//  LFViewController.m
//  Life
//
//  Created by Jon Como on 4/26/13.
//
//

#import "LFViewController.h"

//Challenges...
#import "LFDudeEating.h"

@interface LFViewController ()

@end

@implementation LFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)eat:(id)sender
{
    [self presentViewWithChallenge:[LFDudeEating class]];
}

-(void)presentViewWithChallenge:(Class)class
{
    SPViewController *sparrowViewController = [[SPViewController alloc] init];
    [sparrowViewController startWithRoot:class supportHighResolutions:YES];
    sparrowViewController.preferredFramesPerSecond = 60;
    sparrowViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:sparrowViewController animated:YES completion:nil];
}

@end
