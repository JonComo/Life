//
//  LFCarsOncoming.m
//  Life
//
//  Created by Jon Como on 4/27/13.
//
//

#import "LFCars.h"
#import "JCMath.h"
#import "JCMotionManager.h"
#import "LFWiggler.h"

#define CAR_FRQ 24

@implementation LFCars
{
    SPMovieClip *car;
    JCMotionManager *motion;
    
    SPSprite *cars;
    SPSprite *buildings;
    
    float speed;
    int carFrequency;
    
    int score;
    
    BOOL isDead;
}

-(id)init
{
    if (self = [super init]) {
        //init
        speed = 6;
        carFrequency = CAR_FRQ;
        
        SPImage *bg = [SPImage imageWithContentsOfFile:@"COBG@2x.png"];
        [JCMath centerPivot:bg];
        bg.scaleX = 1.5;
        bg.scaleY = 1.5;
        bg.x = 160;
        bg.y = 320;
        [self addChild:bg];
        [LFWiggler wiggle:bg amount:0.2 time:0.5];
        
        car = [SPMovieClip movieWithFrame:[SPTexture textureWithContentsOfFile:@"COCar@2x.png"] fps:30];
        [JCMath centerPivot:car];
        car.scaleX = 0.7;
        car.scaleY = 0.7;
        car.x = 160;
        car.y = 90;
        [self addChild:car];
        [LFWiggler wiggle:car amount:0.1 time:0.05];
        
        cars = [SPSprite sprite];
        [self addChild:cars];
        
        buildings = [SPSprite sprite];
        [self addChild:buildings];
        
        for (int i = 0; i<5; i++)
        {
            [self addBuildingAtY:i * 960/5];
        }
        
        motion = [[JCMotionManager alloc] init];
        [motion startUpdatesHandler:^(float x, float y, float z) {
            if (isDead) return;
            
            car.x -= (car.x - (160 + (x * 300)))/6;
            
            if (car.x < 100) {
                car.x = 100;
            }else if (car.x > 220)
            {
                car.x = 220;
            }
            
            self.x = (160 - car.x)/2 - 44.4;
        }];
        
        self.scaleX = 1.27;
        self.scaleY = 1.27;
        
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        
        NSTimer *increaseScore;
        increaseScore = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(increaseScore:) userInfo:nil repeats:YES];
    }
    
    return self;
}

-(void)increaseScore:(NSTimer *)timer
{
    score += 1;
}

-(void)onEnterFrame:(SPEnterFrameEvent *)event
{
    if (isDead) return;
    
    if (speed < 18) {
        speed += 0.0005;
    }
    
    carFrequency -= 1;
    if (carFrequency < 0) {
        carFrequency = CAR_FRQ;
        [self addCar];
    }
    
    [self moveBuildings];
    [self moveCars];
}

-(void)addCar
{
    [self addCarAtX:100 + (arc4random()%120)];
}

-(void)addBuildingAtY:(float)y
{
    SPImage *building = [SPImage imageWithContentsOfFile:[NSString stringWithFormat:@"COBuildings%i@2x.png", arc4random()%3 + 1]];
    [JCMath centerPivot:building];
    building.x = 160;
    building.y = y;
    [buildings addChild:building];
}

-(void)addCarAtX:(float)x
{
    SPImage *carEnemy = [SPImage imageWithContentsOfFile:@"COCarBack@2x.png"];
    [JCMath centerPivot:carEnemy];
    carEnemy.x = x;
    carEnemy.y = 960;
    
    [LFWiggler wiggle:carEnemy amount:0.1 time:0.05];
    
    carEnemy.scaleX = 0.7;
    carEnemy.scaleY = 0.7;
    [cars addChild:carEnemy];
}

-(void)moveCars
{
    for (int i = 0; i<cars.numChildren; i++) {
        SPImage *carEnemy = (SPImage *)[cars childAtIndex:i];
        
        carEnemy.y -= speed * 1.5;
        
        if ([JCMath distanceBetweenPoint:CGPointMake(car.x, car.y) andPoint:CGPointMake(carEnemy.x, carEnemy.y) sorting:NO] < 30) {
            [self hitCar];
        }
        
        if (carEnemy.y < -100) {
            [carEnemy removeFromParent];
        }
    }
}

-(void)hitCar
{
    isDead = YES;
    
    SPImage *boom = [SPImage imageWithContentsOfFile:@"COBoom@2x.png"];
    
    [JCMath centerPivot:boom];
    [self addChild:boom];
    
    boom.x = car.x;
    boom.y = car.y;
    
    boom.scaleX = 0;
    boom.scaleY = 0;
    
    [LFWiggler wiggle:boom amount:0.3 time:0.1];
    
    SPTween *boomTween = [SPTween tweenWithTarget:boom time:0.7 transition:SP_TRANSITION_EASE_IN_OUT_ELASTIC];
    [Sparrow.juggler addObject:boomTween];
    boomTween.delay = 0.3;
    
    [boomTween animateProperty:@"scaleX" targetValue:1.6];
    [boomTween animateProperty:@"scaleY" targetValue:1.6];
    
    [self performSelector:@selector(gameOver) withObject:nil afterDelay:2];
}

-(void)gameOver
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LFGameOver" object:nil userInfo:@{@"game" : @"CO", @"points" : @(score)}];
}

-(void)moveBuildings
{
    for (int i = 0; i<buildings.numChildren; i++) {
        SPImage *building = (SPImage *)[buildings childAtIndex:i];
        
        building.y -= (speed + (building.y)/100 - 2);
        
        if (building.y < -100) {
            building.scaleX = arc4random()%2 ? -1 : 1;
            building.y = 700;
        }
    }
}

@end