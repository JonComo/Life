//
//  SPSwipe.h
//  Life
//
//  Created by Jon Como on 4/27/13.
//
//

#import <Foundation/Foundation.h>

@class SPSwipe;

@interface SPSwipe : NSObject

-(void)detectSwipeInTouchEvents:(SPTouchEvent *)touchEvent target:(SPDisplayObject *)target container:(SPDisplayObject *)container began:(void (^)(SPPoint *began))began ended:(void (^)(SPPoint *began, SPPoint *ended))ended;

@end