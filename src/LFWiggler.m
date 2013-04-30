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

+(void)shake:(SPDisplayObject *)object amount:(float)amount time:(float)time
{
    object.y -= amount;
    object.x -= amount;
    
    SPTween *wiggleY = [SPTween tweenWithTarget:object time:time transition:SP_TRANSITION_RANDOMIZE];
    [wiggleY animateProperty:@"y" targetValue:object.y + amount*2];
    wiggleY.repeatCount = 0;
    [Sparrow.juggler addObject:wiggleY];
    
    SPTween *wiggleX = [SPTween tweenWithTarget:object time:time transition:SP_TRANSITION_RANDOMIZE];
    [wiggleX animateProperty:@"x" targetValue:object.y + amount*2];
    wiggleX.repeatCount = 0;
    [Sparrow.juggler addObject:wiggleX];
}

@end