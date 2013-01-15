//
//  GameManager.h
//  AiPong
//
//  Created by Jussi Enroos on 13.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GameManager : NSObject {

	// Game stats
	float paddleHeight;
	float paddleWidth;
	
	float ballRadius;
	
}

@property	float paddleHeight;
@property	float paddleWidth;
@property	float ballRadius;

+(GameManager*)instance;

-(void)defaultSettings;

-(void)runTest;

@end
