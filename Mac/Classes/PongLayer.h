//
//  PongLayer.h
//  AiPong
//
//  Created by Jussi Enroos on 12.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Ball.h"

@interface PongLayer : CCLayer {

	// Size of the window
	CGSize windowSize;
    CGSize playAreaSize;
	
	NSMutableArray	*paddles;
    
    float   updateInterval;
    float   updateTimer;
    
    Ball    *ball;
}

@property (retain) NSMutableArray *paddles;

+(CCScene *) scene;


@end
