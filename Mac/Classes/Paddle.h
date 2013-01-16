//
//  Paddle.h
//  AiPong
//
//  Created by Jussi Enroos on 12.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

typedef enum {
	side_left,
	side_right,
} PaddleSides;

@interface Paddle : CCNode {
    
    NSString    *name;
    
	CGFloat     width;
	CGFloat     height;
	
    float       speed;
}

@property(copy) NSString    *name;
@property       CGFloat     width;
@property       CGFloat     height;
@property       float       speed;

@end
