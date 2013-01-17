//
//  Ball.m
//  AiPong
//
//  Created by Jussi Enroos on 16.1.2013.
//
//

#import "Ball.h"

@implementation Ball

@synthesize radius;
@synthesize xSpeed;
@synthesize ySpeed;
@synthesize showAngle;
@synthesize rotangle;
@synthesize curve;
@synthesize acceleration;
@synthesize previousPosition;

-(void) draw
{
	glEnable(GL_LINE_SMOOTH);
	glColor4ub(255, 255, 255, 255);
	glLineWidth(2);
	ccDrawCircle(ccp(0.0f, 0.0f), radius, rotangle, 60, showAngle);
}

@end
