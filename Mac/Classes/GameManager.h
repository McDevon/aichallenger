//
//  GameManager.h
//  AiPong
//
//  Created by Jussi Enroos on 13.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "LuaInc.h"

@interface GameManager : NSObject {

	// Game stats
	float paddleHeight;
	float paddleWidth;
	
	float ballRadius;
    
    CGSize sceneSize;
	
    NSMutableArray  *controlManagers;
}

@property	float paddleHeight;
@property	float paddleWidth;
@property	float ballRadius;
@property	CGSize sceneSize;
@property (retain) NSMutableArray *controlManagers;

+(GameManager*)instance;

-(void)setSpeed:(float)speed forLuaState:(lua_State*)state;

-(void)defaultSettings;

-(void)runTest;

@end
