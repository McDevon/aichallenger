//
//  Ball.h
//  AiPong
//
//  Created by Jussi Enroos on 16.1.2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Ball : CCNode
{
    BOOL showAngle;
    
    float radius;
    float rotangle;
    
    float curve;
    
    float xSpeed;
    float ySpeed;
    
    float acceleration;
	
	CGPoint previousPosition;
}

@property   float radius;
@property   float xSpeed;
@property   float ySpeed;
@property   BOOL showAngle;
@property   float rotangle;
@property   float curve;
@property   float acceleration;
@property   CGPoint previousPosition;

@end
