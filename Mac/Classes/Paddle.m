//
//  Paddle.m
//  AiPong
//
//  Created by Jussi Enroos on 12.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Paddle.h"
#import	"Segment.h"

void ccFillPoly( CGPoint *poli, int points, BOOL closePolygon )
{
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    // Needed states: GL_VERTEX_ARRAY,
    // Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
	
    glVertexPointer(2, GL_FLOAT, 0, poli);
    if( closePolygon )
		glDrawArrays(GL_TRIANGLE_FAN, 0, points);
    else
		glDrawArrays(GL_LINE_STRIP, 0, points);
	
    // restore default state
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
}

@implementation Paddle

@synthesize name;
@synthesize speed;
@synthesize width;
@synthesize height;

-(id) init
{
	if (self = [super init]) {
		speed = 0.0f;
	}
	return self;
}

-(void) draw
{
	glEnable(GL_LINE_SMOOTH);
	glColor4ub(255, 255, 255, 255);
	glLineWidth(2);
	CGPoint vertices2[] = { ccp(-anchorPoint_.x * width, -anchorPoint_.y * height),
                            ccp((1.0f - anchorPoint_.x ) * width , -anchorPoint_.y * height),
                            ccp((1.0f - anchorPoint_.x ) * width ,  (1.0f - anchorPoint_.y ) * height),
                            ccp(-anchorPoint_.x * width,  (1.0f - anchorPoint_.y ) * height) };
	ccDrawPoly(vertices2, 4, YES);
}

- (NSArray*)getBoundariesForRadius:(float)radius;
{
	// Values
	float	vleft	= position_.x + (-anchorPoint_.x * width);
	float 	vright	= position_.x + ((1.0f - anchorPoint_.x ) * width);
	float	vtop	= position_.y + ((1.0f - anchorPoint_.y ) * height);
	float	vbottom = position_.y + (-anchorPoint_.y * height);
	
	// Corners
	Vector *bottomLeft  = [Vector vectorWithX:vleft		y:vbottom];
	Vector *bottomRight = [Vector vectorWithX:vright  	y:vbottom];
	Vector *topRight 	= [Vector vectorWithX:vright  	y:vtop];
	Vector *topLeft 	= [Vector vectorWithX:vleft	    y:vtop];
	
	// Sides
	Segment *left = [Segment segment];
	left.vertical 	= YES;
	left.b 			= vleft - radius;
	left.begin 		= vbottom;
	left.end		= vtop;
	left.controls   = YES;

	Segment *right  = [Segment segment];
	right.vertical 	= YES;
	right.b 		= vright + radius;
	right.begin 	= vbottom;
	right.end		= vtop;
	right.controls  = YES;
	
	Segment *top	= [Segment segment];
	top.a			= 0.0f;
	top.b 			= vtop + radius;
	top.begin 		= vleft;
	top.end			= vright;

	Segment *bottom	= [Segment segment];
	bottom.a		= 0.0f;
	bottom.b 		= vbottom - radius;
	bottom.begin	= vleft;
	bottom.end		= vright;
	
	return [NSArray arrayWithObjects:bottomLeft, bottomRight, topRight, topLeft, left, right, top, bottom, nil];
	
}

@end
