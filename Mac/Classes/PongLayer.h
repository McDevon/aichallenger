//
//  PongLayer.h
//  AiPong
//
//  Created by Jussi Enroos on 12.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface PongLayer : CCLayer {

	// Size of the window
	CGSize windowSize;
	
	NSMutableArray	*paddles;
    NSMutableArray  *controlManagers;
}

@property (retain) NSMutableArray *paddles;
@property (retain) NSMutableArray *controlManagers;

+(CCScene *) scene;


@end
