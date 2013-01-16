//
//  PongState.h
//  AiPong
//
//  Created by Jussi Enroos on 15.1.2013.
//
//

#import <Foundation/Foundation.h>
#import "Paddle.h"

@interface PongState : NSObject
{
    Paddle *pl1;
    Paddle *pl2;
}

+(id)state;

@end
