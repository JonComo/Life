//
//  JCMotionManager.h
//  Life
//
//  Created by Jon Como on 4/27/13.
//
//

#import <Foundation/Foundation.h>

@interface JCMotionManager : NSObject

-(void)startUpdatesHandler:(void(^)(float x, float y, float z))handler;

@end