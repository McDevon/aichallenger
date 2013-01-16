//
//  Player.m
//  AiPong
//
//  Created by Jussi Enroos on 16.1.2013.
//
//

#import "Player.h"

@implementation Player

-(id)init
{
    if (self = [super init]) {
        self.paddles = [NSMutableArray arrayWithCapacity:1];
    }
    
    return self;
}

-(void)dealloc
{
    self.paddles = nil;
    self.name = nil;
    
    [super dealloc];
}

@synthesize paddles;
@synthesize name;
@synthesize side;

@end
