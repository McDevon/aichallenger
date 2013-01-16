//
//  ScriptControlManager.h
//  AiPong
//
//  Created by Jussi Enroos on 15.1.2013.
//
//

#import "Paddle.h"
#import "PongState.h"
#import "Player.h"
#import "Ball.h"

@protocol ScriptControlManager <NSObject>

@required

// Pong
-(int)pongInitializePlayer:(Player*)player file:(NSString*)file;
-(int)pongUpdatePlayers:(NSArray*)players ball:(Ball*)ball width:(float)width height:(float)height delta:(float)timeDelta;
-(int)pongFinish;

@property(retain)Player *player;

@end
