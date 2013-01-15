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
	CGFloat width;
	CGFloat height;
	
	int		side;	// Left or right player (only in visual mode, in gameplay both think they are left)
}

@property CGFloat width;
@property CGFloat height;
@property int side;

@end
