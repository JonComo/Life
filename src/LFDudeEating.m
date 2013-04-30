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
#import "SPSwipe.h"

@implementation LFDudeEating
{
    SPImage *head;
    SPSprite *bodySprite;
    SPSprite *sushiSprite;
    
    SPSwipe *detector;
    SPImage *touchedSushi;
    
    SPTextField *text;
    
    int timeLeft;
    int points;
}

-(id)init
{
    if (self = [super init]) {
        
        //init
        timeLeft = 20;
        NSTimer *countdown;
        countdown = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
        
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
        [LFWiggler wiggle:bodySprite amount:0.5 time:1];
        
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
        [LFWiggler wiggle:head amount:0.6 time:0.8];
        
        SPImage *table = [SPImage imageWithContentsOfFile:@"table@2x.png"];
        table.y = 355;
        [self addChild:table];
        
        //Label
        text = [[SPTextField alloc] initWithWidth:320 height:50 text:@"" fontName:@"Helvetica-Bold" fontSize:22 color:SP_WHITE];
        [text setHAlign:SPHAlignCenter];
        [self addChild:text];
        
        sushiSprite = [SPSprite sprite];
        [self addChild:sushiSprite];
        
        [self countDown:nil];
        
        [sushiSprite addEventListener:@selector(touchedSushi:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        detector = [[SPSwipe alloc] init];
        
        [self addEventListener:@selector(enterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        
        NSTimer *moreSushi;
        moreSushi = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addSushi) userInfo:nil repeats:YES];
    }
    
    return self;
}

-(void)enterFrame:(SPEnterFrameEvent *)event
{
    [self updateText];
}

-(void)countDown:(NSTimer *)timer
{
    timeLeft --;
    
    if (timeLeft < 0) {
        [timer invalidate];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LFGameOver" object:nil userInfo:@{@"game":@"DE", @"points" : @(points)}];
    }
}

-(void)updateText
{
    //[text setText:[NSString stringWithFormat:@"Time: %i second Points:%i", timeLeft, points]];
}

-(void)addSushi
{
    if (sushiSprite.numChildren > 3) return; //Don't add more than three.
    
    SPImage *sushi = [SPImage imageWithContentsOfFile:@"sushi@2x.png"];
    sushi.pivotX = sushi.width/2;
    sushi.pivotY = sushi.height/2;
    [sushiSprite addChild:sushi];
    
    sushi.x = 40 + arc4random()%240;
    sushi.y = -30;
    
    float targetY = 400 + arc4random()%10;
    
    [LFWiggler wiggle:sushi amount:0.05 time:0.07];
    
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
}

-(void)touchedSushi:(SPTouchEvent *)touchEvent
{
    [detector detectSwipeInTouchEvents:touchEvent target:sushiSprite container:self began:^(SPPoint *began) {
        
        touchedSushi = nil;
        float dist = FLT_MAX;
        
        for (int i = 0; i < sushiSprite.numChildren; i++) {
            SPImage *sushi = (SPImage *)[sushiSprite childAtIndex:i];
            float testDist = [JCMath distanceBetweenPoint:CGPointMake(began.x, began.y) andPoint:CGPointMake(sushi.x, sushi.y) sorting:NO];
            
            if (testDist < dist && testDist < 200)
            {
                dist = testDist;
                touchedSushi = sushi;
            }
        }
        
    } ended:^(SPPoint *began, SPPoint *ended) {
        
        float angle = [JCMath angleFromPoint:CGPointMake(began.x, began.y) toPoint:CGPointMake(ended.x, ended.y)];
        
        [self flickSushi:touchedSushi atAngle:angle];
        touchedSushi = nil;
        
    }];
}

-(void)flickSushi:(SPImage *)sushi atAngle:(float)angle
{
    CGPoint deltaPoint = [JCMath pointFromPoint:CGPointMake(sushi.x, sushi.y) pushedBy:280 inDirection:angle];
    
    //flick it
    SPTween *flick = [SPTween tweenWithTarget:sushi time:0.3 transition:SP_TRANSITION_EASE_OUT];
    [flick animateProperty:@"x" targetValue:deltaPoint.x];
    [flick animateProperty:@"y" targetValue:deltaPoint.y];
    [flick animateProperty:@"scaleX" targetValue:0.3];
    [flick animateProperty:@"scaleY" targetValue:0.3];
    [flick animateProperty:@"rotation" targetValue:((float)(arc4random()%30))/15];
    [Sparrow.juggler addObject:flick];
    
    flick.onComplete = ^{
        //check shiz
        
        CGPoint startPoint = CGPointMake(bodySprite.x, bodySprite.y);
        
        CGPoint neck = [JCMath pointFromPoint:startPoint pushedBy:150 inDirection:bodySprite.rotation - M_PI/2];
        CGPoint mouth = [JCMath pointFromPoint:neck pushedBy:30 inDirection:head.rotation + bodySprite.rotation - M_PI/2];
        
        if ([JCMath distanceBetweenPoint:CGPointMake(sushi.x, sushi.y) andPoint:mouth sorting:NO] < 60) {
            [self landedSomeSushi];
        }else{
            [self wastedSushi];
        }
        
        [sushi removeFromParent];
    };
    
}

-(void)landedSomeSushi
{
    points ++;
    
    [head setTexture:[SPTexture textureWithContentsOfFile:@"headHappy@2x.png"]];
    
    [self performSelector:@selector(stillHungry) withObject:nil afterDelay:0.5];
}

-(void)wastedSushi
{
    [head setTexture:[SPTexture textureWithContentsOfFile:@"headAngry@2x.png"]];
    
    [self performSelector:@selector(stillHungry) withObject:nil afterDelay:0.5];
}

-(void)stillHungry
{
    [head setTexture:[SPTexture textureWithContentsOfFile:@"head@2x.png"]];
}

@end