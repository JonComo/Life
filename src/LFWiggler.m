//
//  LFWiggler.m
//  Life
//
//  Created by Jon Como on 4/26/13.
//
//

#import "LFWiggler.h"

@implementation LFWiggler

+(void)wiggle:(SPDisplayObject *)object amount:(float)amount time:(float)time
{
    object.rotation -= amount;
    SPTween *wiggle = [SPTween tweenWithTarget:object time:time transition:SP_TRANSITION_EASE_IN_OUT];
    [wiggle animateProperty:@"rotation" targetValue:object.rotation + amount * 2];
    wiggle.repeatCount = 0;
    wiggle.reverse = YES;
    [Sparrow.juggler addObject:wiggle];
}

@end