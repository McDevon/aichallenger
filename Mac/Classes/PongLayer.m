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
#import "Segment.h"

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
            [paddle setAnchorPoint:ccp(0.5f, 0.0f)];
            
            paddle.width = gman.paddleWidth;
            paddle.height = gman.paddleHeight;
            
            if (manager.player.side == side_left) {
                paddle.position = ccp(paddle.width / 2.0f, playAreaSize.height / 2.0f - (paddle.height / 2.0f));
            } else {
                paddle.position = ccp(playAreaSize.width - (paddle.width / 2.0f), playAreaSize.height / 2.0f - (paddle.height / 2.0f));
            }
            [self addChild:paddle];
        }
	}
}

-(void)drawBall
{
    GameManager *gman = [GameManager instance];
    
    [ball setAnchorPoint:ccp(0.5f, 0.5f)];
    [ball setPosition:ccp(playAreaSize.width / 2.0f, playAreaSize.height / 2.0f)];
    
#ifdef DEBUG
	ball.showAngle = YES;
#else
	ball.showAngle = NO;
#endif
	
    ball.radius = gman.ballRadius;
    ball.rotangle  = 0.0f;
    
    ball.curve  = 1.0f;
    
    ball.xSpeed = 150.0f;
    ball.ySpeed = 3.0f;
    
    ball.acceleration = 8.0f;
    
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
		
        [GameManager instance].sceneSize = playAreaSize;
        
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
		
		//[paddles addObject:pl1];
		//[paddles addObject:pl2];
        
        [[GameManager instance].controlManagers addObject:ctrl1];
        [[GameManager instance].controlManagers addObject:ctrl2];
        
        [ctrl1 pongInitializePlayer:pl1 file:@"test.lua"];
        [ctrl2 pongInitializePlayer:pl2 file:@"test.lua"];
        
        [pl1 release];
        [pl2 release];
        [ctrl1 release];
        [ctrl2 release];
        
        ball = [[Ball alloc] init];
		
		[self drawPaddles];
		[self drawBall];
        
		runState = state_running;
		
		[self schedule:@selector(tick:)];
        
        /*
         *  TEST CODE
         */
        
        playTest = NO;
		
	}
	return self;
}

#pragma mark -
#pragma mark Drawing

-(void)collisionCheckBall:(Ball*)circle paddle:(Paddle*)paddle
{
	//BOOL collision = NO;
	int collision = coll_no;
	
	// Get paddle center coordinates
	float paddleX = paddle.position.x - (paddle.width * (paddle.anchorPoint.x - 0.5f));
	float paddleY = paddle.position.y - (paddle.height * (paddle.anchorPoint.y - 0.5f));
	
	//NSLog(@"Paddlecenter x: %.2f y: %.2f", paddleX, paddleY);
	
	float circleDistanceX = fabsf(circle.position.x - paddleX);
    float circleDistanceY = fabsf(circle.position.y - paddleY);
	
	// No collision
    if (circleDistanceX > (paddle.width / 2.0f + circle.radius)) { return; }
    if (circleDistanceY > (paddle.height / 2.0f + circle.radius)) { return; }
	
	// x collision
    if (circleDistanceY <= (paddle.height / 2.0f)) { 
		if (ball.xSpeed > 0.0f) {
			collision = coll_left;
			
			float paddleLeft = paddle.position.x - (paddle.width * paddle.anchorPoint.x);
			float diff = (ball.position.x + ball.radius) - paddleLeft;
			
			[ball setPosition:ccp(paddleLeft - ball.radius - diff ,ball.position.y)];
			
		} else if (ball.xSpeed < 0.0f) {
			collision = coll_right;
			
			float paddleRight = paddle.position.x + (paddle.width * (1.0f - paddle.anchorPoint.x));
			float diff = paddleRight - (ball.position.x - ball.radius);
						
			[ball setPosition:ccp(paddleRight + ball.radius + diff ,ball.position.y)];

		}
		
		// TODO: Apply control
		ball.xSpeed = -ball.xSpeed;
	} 
		
	// y collision
    else if (circleDistanceX <= (paddle.width / 2.0f)) {
		if (ball.ySpeed > 0.0f) {
			collision = coll_bottom;
			
			float paddleBottom = paddle.position.y - (paddle.height * paddle.anchorPoint.y);
			float diff = (ball.position.y + ball.radius) - paddleBottom;
			
			[ball setPosition:ccp(ball.position.x, paddleBottom - diff)];
			
		} else if (ball.xSpeed < 0.0f) {
			collision = coll_top;
			
			float paddleTop = paddle.position.y + (paddle.height * (1.0f - paddle.anchorPoint.y));
			float diff = paddleTop - (ball.position.y - ball.radius);
			
			[ball setPosition:ccp(ball.position.x, paddleTop + diff)];
			
		}
		
		ball.ySpeed = -ball.ySpeed;
		
	}
	

	
    //cornerDistance_sq = (circleDistance.x - rect.width/2)^2 +
	//(circleDistance.y - rect.height/2)^2;
	
    //return (cornerDistance_sq <= (circle.r^2));*/
}

-(NSObject*)nextIntersectionForBall:(Ball*)circle obstacles:(NSArray*)boundaries previousIntersection:(NSObject*)previous
{
	// Create a segment that ball has travelled
	float relation = 0.0f;
	Segment *travel = [Segment segment];

	if (circle.xSpeed > 0.0f || circle.xSpeed < 0.0f) {
		relation = circle.ySpeed / circle.xSpeed;

		travel.a = relation;
		travel.begin = circle.previousPosition.x;
		travel.end = circle.position.x;
		travel.b = circle.position.y - circle.position.x * relation;
	} else {
		NSLog(@"Vertical ball direction");
		travel.vertical = YES;
		travel.begin = circle.previousPosition.y;
		travel.end = circle.position.y;
		travel.b = circle.position.x;
	}
	
	NSObject 	*closestObstacle = nil;
	Vector		*nextIntersection = nil;
	float		closestDistanceSqrd = 5000000.0f;

	// Get nearest bounce point
	for (NSObject *obstacle in boundaries) {
		
		if (obstacle == previous) {
			continue;
		}
		
		// Check for segment collisions
		if ([obstacle isKindOfClass:[Segment class]]) {
			Segment *segment = (Segment*)obstacle;
			
			// Check for intersection
			Vector *point = [travel intersectionWith:segment];
			
			if (point == nil) {
				continue;
			}
						
			Vector 	*pos			= [Vector vectorWithX:circle.previousPosition.x y:circle.previousPosition.y];
			float 	distanceSqrd  	= [point distanceSquaredTo:pos];
			
			if (distanceSqrd < closestDistanceSqrd) {
				NSLog(@"HitPos: %.2f distance: %.2f", segment.b, distanceSqrd);
				closestDistanceSqrd = distanceSqrd;
				closestObstacle = segment;
				
				if (nextIntersection != nil) {
					[nextIntersection release];
				}
				nextIntersection = [point retain];
			}
		}
		
		// Check for point collisions (corners of paddles)
		else if ([obstacle isKindOfClass:[Vector class]]) {
			Vector *corner = (Vector*)obstacle;
			
			// Check for collisionPoint
			Vector *point = [travel collisionWith:corner radius:circle.radius];
			
			if (point == nil) {
				continue;
			}
			
			Vector 	*pos			= [Vector vectorWithX:circle.previousPosition.x y:circle.previousPosition.y];
			float 	distanceSqrd  	= [point distanceSquaredTo:pos];

			if (distanceSqrd < closestDistanceSqrd) {
				NSLog(@"HitPos: %.2f distance: %.2f", point.x, distanceSqrd);
				closestDistanceSqrd = distanceSqrd;
				closestObstacle = corner;
				
				if (nextIntersection != nil) {
					[nextIntersection release];
				}
				nextIntersection = [point retain];
			}
		}
	}
	
	if (nextIntersection != nil) {
		if ([closestObstacle isKindOfClass:[Segment class]]) {
			Segment *segment = (Segment*)closestObstacle;
			
			// Bounce from this obstacle
			if (segment.vertical) {
				float diff = nextIntersection.x - circle.position.x;
				circle.position = ccp(nextIntersection.x + diff, circle.position.y);
				circle.xSpeed = -circle.xSpeed;
				// TODO: control and curve
			} else {
				float diff = nextIntersection.y - circle.position.y;
				circle.position = ccp(circle.position.x, nextIntersection.y + diff);
				circle.ySpeed = -circle.ySpeed;
				// TODO: control and curve
			}
			
			// Move previous known position to intersection point
			circle.previousPosition = ccp(nextIntersection.x, nextIntersection.y);
		} else if ([closestObstacle isKindOfClass:[Vector class]]) {
			Vector *corner = (Vector*)closestObstacle;
			
			// Bounce from this obstacle
		}
		
		[nextIntersection release];
		
		NSLog(@"Bounce");

	}
	
	return closestObstacle;
}

-(void)bounceBallFromObstacles:(NSArray*)boundaries
{
	NSObject *previous = nil;
	BOOL	 done = NO;
	while (!!! done) {
		previous = [self nextIntersectionForBall:ball obstacles:boundaries previousIntersection:previous];
		if (previous == nil) {
			done = YES;
		}
	}
}

-(void)tick:(float)dt
{
	// Do not update if paused etc.
	if (runState < state_running) {
		return;
	}
	
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
	
	// Ball movement
	ball.previousPosition = ball.position;
    ball.position = ccp(ball.position.x + ball.xSpeed * dt, ball.position.y + ball.ySpeed * dt);
    ball.rotangle += ball.curve * dt;
	
	
	/*
	 *	Super nice bounce engine for physics
	 *
	 *	Handles situations where ball bounces multiple times
	 *	or goes entirely through a paddle (or several paddles, and walls) during one update cycle
	 *
	 *  (if there are more than one ball, this should be calculated separately for each ball)
	 *
	 *	Optimisation in the engine can be done, but is not yet necessary
	 */
	
	// Create boundaries
	NSMutableArray *boundaries = [[NSMutableArray alloc] initWithCapacity:18];
	
	Segment *ceiling = [Segment segment];
	Segment *floor   = [Segment segment];
	
	ceiling.a = 0.0f;
	ceiling.b = playAreaSize.height - ball.radius;
	ceiling.begin = 0.0f;
	ceiling.end = playAreaSize.width;
	ceiling.controls = NO;
	ceiling.curveAffects = YES;
	
	floor.a = 0.0f;
	floor.b = ball.radius;
	floor.begin = 0.0f;
	floor.end = playAreaSize.width;
	floor.controls = NO;
	floor.curveAffects = YES;
	
	[boundaries addObject:ceiling];
	[boundaries addObject:floor];
	
	// Add paddle boundaries
	for (NSObject<ScriptControlManager> *manager in [GameManager instance].controlManagers) {
        for (Paddle *paddle in manager.player.paddles) {
			[boundaries addObjectsFromArray:[paddle getBoundariesForRadius:ball.radius]];
		}
	}
	
	// Get some bounces then
	[self bounceBallFromObstacles:boundaries];
	
	// Old simple bounce engine
	/*float top = playAreaSize.height - ball.radius;
	float bottom = ball.radius;
	
	// Check for sides and apply possible curve
	// TODO: Apply curve
	if (ball.position.y < bottom) {
		ball.position = ccp(ball.position.x , bottom + (bottom - ball.position.y));
		if (ball.ySpeed < 0) {
			ball.ySpeed = -ball.ySpeed;
		}
	} else if (ball.position.y > top) {
		ball.position = ccp(ball.position.x , top - (ball.position.y - top));
		if (ball.ySpeed > 0) {
			ball.ySpeed = -ball.ySpeed;
		}
	}
	
	// Check for paddle hits
	for (NSObject<ScriptControlManager> *manager in [GameManager instance].controlManagers) {
        for (Paddle *paddle in manager.player.paddles) {
			[self collisionCheckBall:ball paddle:paddle];
		}
	}*/
	
	// Victory conditions
	if (ball.position.x < 0) {
		// Left player loses
		if (playTest && ball.xSpeed < 0.0f) {
			ball.xSpeed = -ball.xSpeed;
		} else {
			runState = state_ended;
			winner = side_right;
		}
	} else if (ball.position.x > playAreaSize.width) {
		// Right player loses
		if (playTest && ball.xSpeed > 0.0f) {
			ball.xSpeed = -ball.xSpeed;
		} else {
			runState = state_ended;
			winner = side_left;
		}
	}
	
	// Paddle movement
    for (NSObject<ScriptControlManager> *manager in [GameManager instance].controlManagers) {
        for (Paddle *paddle in manager.player.paddles) {
            paddle.position = ccp(paddle.position.x , paddle.position.y + paddle.speed * dt * PADDLE_MAX_SPEED);
			
			float top = playAreaSize.height - paddle.height;
			
			// Check for sides
			if (paddle.position.y < 0) {
				paddle.position = ccp(paddle.position.x , -paddle.position.y);
				if (paddle.speed < 0) {
					paddle.speed = -paddle.speed;
				}
			} else if (paddle.position.y > top) {
				paddle.position = ccp(paddle.position.x , top - (paddle.position.y - top));
				if (paddle.speed > 0) {
					paddle.speed = -paddle.speed;
				}
			}
        }
    }
    
    // increase ball speed
    float ballSpeed = sqrtf(ball.xSpeed * ball.xSpeed + ball.ySpeed * ball.ySpeed);
    ballSpeed += ball.acceleration * dt;
    float ballAngle = atan2f(ball.ySpeed, ball.xSpeed);
    ball.xSpeed = ballSpeed * cosf(ballAngle);
    ball.ySpeed = ballSpeed * sinf(ballAngle);
    
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
