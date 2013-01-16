//
//  Paddle.m
//  AiPong
//
//  Created by Jussi Enroos on 12.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Paddle.h"

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
@synthesize width;
@synthesize height;
@synthesize speed;

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

@end
