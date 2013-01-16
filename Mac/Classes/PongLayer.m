//
//  PongLayer.m
//  AiPong
//
//  Created by Jussi Enroos on 12.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PongLayer.h"
#import	"Paddle.h"
#import "Player.h"
#import	"GameManager.h"
#import "LuaControlManager.h"

#define PADDLE_MAX_SPEED 111.1111f

@implementation PongLayer

@synthesize paddles;

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
	for (NSObject<ScriptControlManager> *manager in [GameManager instance].controlManagers) {
        
        for (Paddle *paddle in manager.player.paddles) {
            paddle.anchorPoint = ccp(0.0f, 0.0f);
            
            paddle.width = gman.paddleWidth;
            paddle.height = gman.paddleHeight;
            
            if (manager.player.side == side_left) {
                paddle.position = ccp(0.0f, windowSize.height / 2.0f - (paddle.height / 2.0f));
            } else {
                paddle.position = ccp(windowSize.width - paddle.width, windowSize.height / 2.0f - (paddle.height / 2.0f));
            }
            [self addChild:paddle];
        }
	}
}

-(void)drawBall
{
    GameManager *gman = [GameManager instance];
    
    [ball setPosition:ccp(playAreaSize.width / 2.0f, playAreaSize.height / 2.0f)];
    
    ball.radius = gman.ballRadius;
    ball.angle  = 0.0f;
    
    ball.curve  = 0.0f;
    
    ball.xSpeed = 1.0f;
    ball.ySpeed = 1.0f;
    
    ball.acceleration = 2.0f;
    
    [self addChild:ball];
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// ask director the the window size
		windowSize = [[CCDirector sharedDirector] winSize];
        playAreaSize = windowSize;
		
#ifdef DEBUG
		NSLog(@"Window size x: %.1f y: %.1f", windowSize.width, windowSize.height);
#endif
        updateTimer     = 0.0f;
        updateInterval  = 0.1f;
        
		[[GameManager instance] defaultSettings];
		
		// Prepare players
		self.paddles            = [NSMutableArray array];
		
		// Create two players?
		Player *pl1 = [[Player alloc] init];
		Player *pl2 = [[Player alloc] init];
		
		pl1.side = side_left;
		pl2.side = side_right;
        
        pl1.name = @"Jussi";
        pl2.name = @"Janne";
        
        Paddle *p1 = [[Paddle alloc] init];
        Paddle *p2 = [[Paddle alloc] init];
        
        [pl1.paddles addObject:p1];
        [pl2.paddles addObject:p2];
        
        LuaControlManager *ctrl1 = [[LuaControlManager alloc] init];
        LuaControlManager *ctrl2 = [[LuaControlManager alloc] init];
		
        [ctrl1 pongInitializePlayer:pl1 file:@"test.lua"];
        [ctrl2 pongInitializePlayer:pl2 file:@"test.lua"];
        
		//[paddles addObject:pl1];
		//[paddles addObject:pl2];
        
        [[GameManager instance].controlManagers addObject:ctrl1];
        [[GameManager instance].controlManagers addObject:ctrl2];
        
        [pl1 release];
        [pl2 release];
        [ctrl1 release];
        [ctrl2 release];
        
        ball = [[Ball alloc] init];
		
		[self drawPaddles];
		[self drawBall];
        
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
    updateTimer += dt;
    
    if (updateTimer >= updateInterval) {
        
        for (NSObject<ScriptControlManager> *manager in [GameManager instance].controlManagers) {
            //PongState *state = [PongState state];
            
            NSMutableArray *opponents = [NSMutableArray arrayWithCapacity:1];
            
            // No probably the best way to handle this?
            for (NSObject<ScriptControlManager> *mgr in [GameManager instance].controlManagers) {
                [opponents addObject:mgr.player];
            }
            [manager pongUpdatePlayers:opponents ball:ball width:playAreaSize.width height:playAreaSize.height delta:updateTimer];
        }
        
        updateTimer = 0.0;
    }
    
    // Move everyone
    ball.position = ccp(ball.position.x + ball.xSpeed * dt, ball.position.y + ball.ySpeed * dt);
    
    for (NSObject<ScriptControlManager> *manager in [GameManager instance].controlManagers) {
        for (Paddle *paddle in manager.player.paddles) {
            paddle.position = ccp(paddle.position.x , paddle.position.y + paddle.speed * dt * PADDLE_MAX_SPEED);
        }
    }
    
    // increase ball speed
    float ballSpeed = sqrtf(ball.xSpeed * ball.xSpeed + ball.ySpeed * ball.ySpeed);
    ballSpeed += ball.acceleration * dt;
    float ballAngle = atan2f(ball.xSpeed, ball.ySpeed);
    ball.xSpeed = ballSpeed * cosf(ballAngle);
    ball.ySpeed = ballSpeed * cosf(ballAngle);
    
}

-(void)dealloc
{
	self.paddles = nil;
    
    if (ball != nil) {
        [ball release];
    }
	
	[super dealloc];
}

@end
