//
//  LFDudeEating.m
//  Life
//
//  Created by Jon Como on 4/26/13.
//
//

#import "LFDudeEating.h"
#import "JCMath.h"
#import "LFWiggler.h"

@implementation LFDudeEating
{
    SPImage *head;
    SPSprite *bodySprite;
    
    BOOL p1, p2, p3, p4;
}

-(id)init
{
    if (self = [super init]) {
        //init
        
        p1 = NO;
        p2 = NO;
        p3 = NO;
        p4 = NO;
        
        SPImage *bg = [SPImage imageWithContentsOfFile:@"DEBackground@2x.png"];
        bg.pivotX = bg.width/2;
        bg.pivotY = bg.height/2;
        bg.scaleX = 1.5;
        bg.scaleY = 1.5;
        bg.x = 160;
        bg.y = 320;
        [self addChild:bg];
        [LFWiggler wiggle:bg amount:0.3 time:3];
        
        bodySprite = [SPSprite sprite];
        bodySprite.x = 160;
        bodySprite.y = 360;
        [self addChild:bodySprite];
        [LFWiggler wiggle:bodySprite amount:0.4 time:1.5];
        
        SPImage *body = [SPImage imageWithContentsOfFile:@"bod@2x.png"];
        body.x = -body.width/2;
        body.y = -body.height * 4/5;
        [bodySprite addChild:body];
        
        head = [SPImage imageWithContentsOfFile:@"head@2x.png"];
        head.pivotX = head.width/2;
        head.pivotY = head.height;
        head.x = 0;
        head.y = -150;
        [bodySprite addChild:head];
        [LFWiggler wiggle:head amount:0.5 time:1.5];
        
        SPImage *table = [SPImage imageWithContentsOfFile:@"table@2x.png"];
        table.y = 355;
        [self addChild:table];
        
        
        NSTimer *moreSushi;
        moreSushi = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addSushi) userInfo:nil repeats:YES];
    }
    
    return self;
}

-(void)addSushi
{
    int position = 0;
    
    if (!p1)
    {
        position = 1;
    }else if(!p2)
    {
        position = 2;
    }else if(!p3)
    {
        position = 3;
    }else if(!p4)
    {
        position = 4;
    }
    
    if (position == 0) return; //no open spaces
    
    
    switch (position) {
        case 1:
            p1 = YES;
            break;
        case 2:
            p2 = YES;
            break;
        case 3:
            p3 = YES;
            break;
        case 4:
            p4 = YES;
            break;
            
        default:
            break;
    }
    
    SPImage *sushi = [SPImage imageWithContentsOfFile:@"sushi@2x.png"];
    sushi.pivotX = sushi.width/2;
    sushi.pivotY = sushi.height/2;
    [self addChild:sushi];
    
    sushi.x = 40 + (position - 1) * 80;
    sushi.y = -30;
    
    float targetY = 400 + arc4random()%10;
    
    [LFWiggler wiggle:sushi amount:0.05 time:0.07];
    
    __weak SPImage *sushiWeak = sushi;
    
    SPTween *dropIn = [SPTween tweenWithTarget:sushi time:0.4 transition:SP_TRANSITION_EASE_IN];
    [dropIn animateProperty:@"y" targetValue:targetY];
    [Sparrow.juggler addObject:dropIn];
    
    SPTween *bounceUp = [SPTween tweenWithTarget:sushi time:0.2 transition:SP_TRANSITION_EASE_OUT];
    bounceUp.delay = 0.4;
    [bounceUp animateProperty:@"y" targetValue:targetY - 30];
    [Sparrow.juggler addObject:bounceUp];
    
    SPTween *bounceDown = [SPTween tweenWithTarget:sushi time:0.2 transition:SP_TRANSITION_EASE_IN];
    bounceDown.delay = 0.6;
    [bounceDown animateProperty:@"y" targetValue:targetY + 30];
    [Sparrow.juggler addObject:bounceDown];
    
    dropIn.onComplete = ^{
        
        [sushi addEventListenerForType:SP_EVENT_TYPE_TOUCH block:^(id event) {
            
            SPTouchEvent *touchEvent = (SPTouchEvent *)event;
            
            NSArray *touches = [[touchEvent touchesWithTarget:sushiWeak andPhase:SPTouchPhaseMoved] allObjects];
            
            if (touches.count == 0) return;
            
            SPTouch *touch = [touches objectAtIndex:0];
            SPPoint *currentPos = [touch locationInSpace:self];
            SPPoint *previousPos = [touch previousLocationInSpace:self];
            
            if (sushiWeak.scaleX == 1)
            {
                float deltaX = currentPos.x - previousPos.x;
                float deltaY = currentPos.y - previousPos.y;
                
                sushiWeak.scaleX = 0.9;
                sushiWeak.scaleY = 0.9;
                
                //flicked dat
                
                switch (position) {
                    case 1:
                        p1 = NO;
                        break;
                    case 2:
                        p2 = NO;
                        break;
                    case 3:
                        p3 = NO;
                        break;
                    case 4:
                        p4 = NO;
                        break;
                        
                    default:
                        break;
                }
                
                //flick it
                SPTween *flick = [SPTween tweenWithTarget:sushiWeak time:0.3 transition:SP_TRANSITION_EASE_OUT];
                [flick animateProperty:@"x" targetValue:sushiWeak.x + deltaX * 30];
                [flick animateProperty:@"y" targetValue:sushiWeak.y + deltaY * 30];
                [flick animateProperty:@"scaleX" targetValue:0.3];
                [flick animateProperty:@"scaleY" targetValue:0.3];
                [Sparrow.juggler addObject:flick];
                
                flick.onComplete = ^{
                    //check shiz
                    
                    CGPoint startPoint = CGPointMake(bodySprite.x, bodySprite.y);
                    
                    CGPoint neck = [JCMath pointFromPoint:startPoint pushedBy:150 inDirection:bodySprite.rotation - M_PI/2];
                    CGPoint mouth = [JCMath pointFromPoint:neck pushedBy:30 inDirection:head.rotation + bodySprite.rotation - M_PI/2];
                    
                    if ([JCMath distanceBetweenPoint:CGPointMake(sushiWeak.x, sushiWeak.y) andPoint:mouth sorting:NO] < 60) {
                        [self landedSomeSushi];
                    }
                    
                    [sushiWeak removeFromParent];
                };
            }
        }];
    };
}

-(void)landedSomeSushi
{
    [head setTexture:[SPTexture textureWithContentsOfFile:@"headHappy@2x.png"]];
    
    [self performSelector:@selector(stillHungry) withObject:nil afterDelay:0.5];
}

-(void)stillHungry
{
    [head setTexture:[SPTexture textureWithContentsOfFile:@"head@2x.png"]];
}

@end
