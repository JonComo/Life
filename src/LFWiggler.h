//
//  LFWiggler.h
//  Life
//
//  Created by Jon Como on 4/26/13.
//
//

#import <Foundation/Foundation.h>

@interface LFWiggler : NSObject

+(void)wiggle:(SPDisplayObject *)object amount:(float)amount time:(float)time;
+(void)shake:(SPDisplayObject *)object amount:(float)amount time:(float)time;

@end