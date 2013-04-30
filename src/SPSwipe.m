//
//  SPSwipe.m
//  Life
//
//  Created by Jon Como on 4/27/13.
//
//

#import "SPSwipe.h"
#import "JCMath.h"

@implementation SPSwipe
{
    SPPoint *touchLocationBegan;
    SPPoint *touchLocationEnded;
}

-(void)detectSwipeInTouchEvents:(SPTouchEvent *)touchEvent target:(SPDisplayObject *)target container:(SPDisplayObject *)container began:(void (^)(SPPoint *))began ended:(void (^)(SPPoint *, SPPoint *))ended
{
    NSArray *touchesBegan = [[touchEvent touchesWithTarget:target andPhase:SPTouchPhaseBegan] allObjects];
    NSArray *touchesEnded = [[touchEvent touchesWithTarget:target andPhase:SPTouchPhaseEnded] allObjects];
    
    if (touchesBegan.count > 0)
    {
        SPTouch *touchBegan = touchesBegan[0];
        touchLocationBegan = [touchBegan locationInSpace:container];
        
        if (began)
            began(touchLocationBegan);
    }
    
    if (touchesEnded.count > 0)
    {
        SPTouch *touchEnded = touchesEnded[0];
        touchLocationEnded = [touchEnded locationInSpace:container];
        
        if (ended)
            ended(touchLocationBegan, touchLocationEnded);
    }
}

@end
