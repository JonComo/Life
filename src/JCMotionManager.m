//
//  JCMotionManager.m
//  Life
//
//  Created by Jon Como on 4/27/13.
//
//

#import "JCMotionManager.h"
#import <CoreMotion/CoreMotion.h>

@implementation JCMotionManager
{
    CMMotionManager *manager;
    NSOperationQueue *queue;
}

-(id)init
{
    if (self = [super init]) {
        //init
        queue = [[NSOperationQueue alloc] init];
        manager = [[CMMotionManager alloc] init];
    }
    
    return self;
}

-(void)startUpdatesHandler:(void(^)(float x, float y, float z))handler
{
    [manager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        if (handler) handler(accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
    }];
}

@end
