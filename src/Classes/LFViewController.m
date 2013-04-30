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
#import "LFCars.h"

@interface LFViewController ()
{
    SPViewController *sparrowViewController;
    __weak IBOutlet UILabel *eatenLabel;
    __weak IBOutlet UILabel *drivenLabel;
}

@end

@implementation LFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    eatenLabel.alpha = 0;
    drivenLabel.alpha = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver:) name:@"LFGameOver" object:nil];
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

- (IBAction)drive:(id)sender
{
    [self presentViewWithChallenge:[LFCars class]];
}

-(void)presentViewWithChallenge:(Class)class
{
    sparrowViewController = [[SPViewController alloc] init];
    [sparrowViewController startWithRoot:class supportHighResolutions:YES];
    sparrowViewController.preferredFramesPerSecond = 60;
    sparrowViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:sparrowViewController animated:YES completion:nil];
}

-(void)gameOver:(NSNotification *)notification
{
    if ([notification.userInfo[@"game"] isEqualToString:@"DE"]) {
        eatenLabel.alpha = 0;
        int points = [notification.userInfo[@"points"] intValue];
        eatenLabel.text = [NSString stringWithFormat:@"Eaten: %i", points];
        
        [sparrowViewController dismissViewControllerAnimated:YES completion:^{
            [UIView animateWithDuration:1 animations:^{
                eatenLabel.alpha = 1;
            }];
        }];
    }else if ([notification.userInfo[@"game"] isEqualToString:@"CO"]) {
        drivenLabel.alpha = 0;
        int points = [notification.userInfo[@"points"] intValue];
        drivenLabel.text = [NSString stringWithFormat:@"Driven: %i", points];
        
        [sparrowViewController dismissViewControllerAnimated:YES completion:^{
            [UIView animateWithDuration:1 animations:^{
                drivenLabel.alpha = 1;
            }];
        }];
    }
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
