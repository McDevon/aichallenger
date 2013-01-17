//
//  Segment.m
//  AiPong
//
//  Created by Jussi Enroos on 17.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Segment.h"

float pow2f(float x)
{
	return x * x;
}

@implementation Vector

@synthesize x;
@synthesize y;

+ (Vector*)vector
{
	Vector *vector = [[Vector alloc] init];
	return [vector autorelease];
}

+ (Vector*)vectorWithX:(float)xval y:(float)yval
{
	Vector *vector = [[Vector alloc] initWithX:xval y:yval];
	return [vector autorelease];
}

- (id)initWithX:(float)xval y:(float)yval
{
	if (self = [super init]) {
		x = xval;
		y = yval;
	}
	return self;
}

- (float)distanceSquaredTo:(Vector*)vector
{
	return (pow2f(x - vector.x) + pow2f(y - vector.y));
}

- (float)length
{
	return sqrtf(pow2f(x) + pow2f(y));
}

- (Vector*)minusVector:(Vector*)vector
{
	return [[[Vector alloc] initWithX:x - vector.x y:y - vector.y] autorelease];
}

@end


@implementation Segment

@synthesize	a;
@synthesize	b;
@synthesize	vertical;
@synthesize controls;
@synthesize curveAffects;
@synthesize	begin;
@synthesize	end;

+ (Segment*)segment
{
	Segment *segment = [[Segment alloc] init];
	return [segment autorelease];
}

- (id)init
{
	if (self = [super init]) {
		vertical = NO;
		controls = NO;
		curveAffects = NO;
	}
	return self;
}

- (Vector*)intersectionWith:(Segment*)segment
{
	// Check for parallel lines
	if ((segment.a == a && !!! vertical && !!! segment.vertical) || (vertical && segment.vertical)) {
		return nil;
	}
	
	if (segment.vertical) {
		float x = segment.b;
		float y = a * segment.b + b;
		
		if (  (x < begin && x < end)
			||(x > begin && x > end)
			||(y < segment.begin && y < segment.end)
			||(y > segment.begin && y > segment.end)){
			return nil;
		}
		return [Vector vectorWithX:x y:y];
	}
	if (vertical) {
		float x = b;
		float y = segment.a * b + segment.b;
		
		if (  (y < begin && x < end)
			||(y > begin && x > end)
			||(x < segment.begin && y < segment.end)
			||(x > segment.begin && y > segment.end)){
			return nil;
		}
		NSLog(@"Hit");
		return [Vector vectorWithX:x y:y];
	}
	
	// General case
	float x = (segment.b - b) / (a - segment.a);
	float y = a * x + b;

    if (  (x < begin && x < end)
		||(x > begin && x > end)
		||(x < segment.begin && y < segment.end)
		||(x > segment.begin && y > segment.end)){
        return nil;
	}
		
	return [Vector vectorWithX:x y:y];
		
}

- (Vector*)collisionWith:(Vector*)point radius:(float)radius
{
	// Create a normal
	Segment *normal = [Segment segment];
	
	if (vertical) {
		normal.a = 0.0f;
		normal.b = point.y;
	} else if (a == 0.0f) {
		normal.vertical = YES;
		normal.b = point.x;
	} else {
		normal.a = -1.0f / a;
		normal.b = normal.a * -point.x + point.y;
	}
	
	// Just give arbitrarily large numbers here
	normal.begin = -9999999.0f;
	normal.end	 =  9999999.0f;
	
	// Intersection with normal
	Vector *intersection = [self intersectionWith:normal];
	
	// If distance is short enough, there is a collision
	if ([point distanceSquaredTo:intersection] <= radius * radius) {
#ifdef DEBUG
		NSLog(@"Corner hit");
#endif
		return intersection;
	}
	return nil;
}

- (float)length
{
	return sqrtf(pow2f(begin - end) + pow2f(a*(begin - end)));
}

@end
