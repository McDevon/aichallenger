//
//  GameManager.m
//  AiPong
//
//  Created by Jussi Enroos on 13.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameManager.h"
#import "LuaControlManager.h"

@implementation GameManager

static GameManager* m_GameManagerInstance = nil;

@synthesize paddleWidth;
@synthesize paddleHeight;
@synthesize ballRadius;

+(GameManager*)instance
{
	@synchronized([GameManager class])
	{
		if (!m_GameManagerInstance) {
			m_GameManagerInstance = [[super allocWithZone:NULL] init];
		}
	}
	return m_GameManagerInstance;
}

+(id)allocWithZone:(NSZone *)zone
{
	return [[self instance] retain];
}

-(id)copyWithZone:(NSZone *)zone
{
	return self;
}

-(id)sretain
{
	return self;
}

-(NSUInteger)retainCount
{
	return NSUIntegerMax;  // Denotes object cannot be released
}

-(void)release
{
	// Do nothing
}

-(id)autorelease
{
	return self;
}

#pragma mark -
#pragma mark Game Control

-(void)defaultSettings
{
	paddleWidth = 10.0f;
	paddleHeight = 50.0f;
	ballRadius = 5.0f;
}

-(void)runTest
{

}

@end
