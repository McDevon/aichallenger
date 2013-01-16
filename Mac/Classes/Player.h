//
//  Player.h
//  AiPong
//
//  Created by Jussi Enroos on 16.1.2013.
//
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
{
    NSString        *name;
    NSMutableArray  *paddles;

	int         side;	// Left or right player (only in visual mode, in gameplay both think they are left)
}
@property(copy)     NSString        *name;
@property(retain)   NSMutableArray  *paddles;
@property           int             side;

@end
