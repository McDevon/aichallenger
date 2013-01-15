//
//  PongLayer.m
//  AiPong
//
//  Created by Jussi Enroos on 12.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PongLayer.h"
#import	"Paddle.h"
#import	"GameManager.h"
#import "LuaControlManager.h"


@implementation PongLayer

@synthesize paddles;
@synthesize controlManagers;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PongLayer *layer = [PongLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)drawPaddles
{
	GameManager *gman = [GameManager instance];
	for (Paddle *paddle in paddles) {
		paddle.anchorPoint = ccp(0.0f, 0.0f);
		
		paddle.width = gman.paddleWidth;
		paddle.height = gman.paddleHeight;

		if (paddle.side == side_left) {
			paddle.position = ccp(0.0f, windowSize.height / 2.0f - (paddle.height / 2.0f));
		} else {
			paddle.position = ccp(windowSize.width - paddle.width, windowSize.height / 2.0f - (paddle.height / 2.0f));
		}
		[self addChild:paddle];
	}
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// ask director the the window size
		windowSize = [[CCDirector sharedDirector] winSize];
		
#ifdef DEBUG
		NSLog(@"Window size x: %.1f y: %.1f", windowSize.width, windowSize.height);
#endif
		[[GameManager instance] defaultSettings];
		
		// Prepare players
		self.paddles            = [NSMutableArray array];
		self.controlManagers    = [NSMutableArray array];
		
		// Create two players?
		Paddle *pl1 = [[Paddle alloc] init];
		Paddle *pl2 = [[Paddle alloc] init];
		
		pl1.side = side_left;
		pl2.side = side_right;
        
        LuaControlManager *ctrl1 = [[LuaControlManager alloc] init];
        LuaControlManager *ctrl2 = [[LuaControlManager alloc] init];
		
        [ctrl1 pongInitializePaddle:pl1 file:@"test.lua"];
        [ctrl2 pongInitializePaddle:pl2 file:@"test.lua"];
        
		[paddles addObject:pl1];
		[paddles addObject:pl2];
        
        [controlManagers addObject:ctrl1];
        [controlManagers addObject:ctrl2];
        
        [pl1 release];
        [pl2 release];
        [ctrl1 release];
        [ctrl2 release];
		
		[self drawPaddles];
		
		[self schedule:@selector(tick:)];
        
        /*
         *  TEST CODE
         */
        
        [[GameManager instance] runTest];
		
	}
	return self;
}

#pragma mark -
#pragma mark Drawing

-(void)tick:(float)dt
{
	
}

-(void)dealloc
{
	self.paddles = nil;
	
	[super dealloc];
}

@end
