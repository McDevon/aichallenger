//
//  PongState.m
//  AiPong
//
//  Created by Jussi Enroos on 15.1.2013.
//
//

#import "PongState.h"

@implementation PongState

-(id)init
{
    if (self = [super init]) {
        pl1 = nil;
        pl2 = nil;
    }
    
    return self;
}

+(id)state
{
    PongState * state = [[PongState alloc] init];
    
    return [state autorelease];
}

@end
