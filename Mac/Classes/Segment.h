//
//  Segment.h
//  AiPong
//
//  Created by Jussi Enroos on 17.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Vector : NSObject
{
	float	x;
	float	y;
}

@property float	x;
@property float	y;

+ (Vector*)vector;
+ (Vector*)vectorWithX:(float)xval y:(float)yval;

- (id)initWithX:(float)xval y:(float)yval;

- (float)distanceSquaredTo:(Vector*)vector;
- (float)length;
- (Vector*)minusVector:(Vector*)vector;

@end


@interface Segment : NSObject {
	float	a;
	float	b;
	
	// If this is yes, a == inf, b == x coordinate
	BOOL	vertical;
	
	// If yes, hitting this boundary changes the angle of return depending on the position of hit
	BOOL	controls;
	
	// If yes, ball's curve changes the angle of return when colliding
	BOOL	curveAffects;
	
	// These are x coordinates unless a == inf, e.g. verical == YES;
	float	begin;
	float	end;
}

@property float	a;
@property float	b;
@property BOOL	vertical;
@property BOOL	controls;
@property BOOL	curveAffects;
@property float	begin;
@property float	end;

+ (Segment*)segment;

- (Vector*)intersectionWith:(Segment*)segment;
- (Vector*)collisionWith:(Vector*)point radius:(float)radius;
- (float)length;

@end
