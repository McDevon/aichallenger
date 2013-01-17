//
//  Paddle.h
//  AiPong
//
//  Created by Jussi Enroos on 12.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Paddle : CCNode {
    
    NSString    *name;
    
	float       width;
	float       height;
	
    float       speed;
}

@property(copy) NSString    *name;
@property       float       width;
@property       float       height;
@property       float       speed;

- (NSArray*)getBoundariesForRadius:(float)radius;

@end
