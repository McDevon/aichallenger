//
//  PongLayer.h
//  AiPong
//
//  Created by Jussi Enroos on 12.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Ball.h"

typedef enum {
	state_nd,
	state_paused,
	state_ended,
	state_running,
} runStates;

typedef enum {
	coll_novalue,
	coll_no,
	coll_left,
	coll_right,
	coll_top,
	coll_bottom,
	coll_topright,
	coll_topleft,
	coll_bottomright,
	coll_bottomleft,
} collisions;

@interface PongLayer : CCLayer {

	// Size of the window
	CGSize windowSize;
    CGSize playAreaSize;
	
	NSMutableArray	*paddles;
	//NSMutableArray	*boundaries;
    
    float   updateInterval;
    float   updateTimer;
    
    Ball    *ball;
	
	int 	runState;
	int		winner;
	
	BOOL	playTest;
}

@property (retain) NSMutableArray *paddles;

+(CCScene *) scene;


@end
