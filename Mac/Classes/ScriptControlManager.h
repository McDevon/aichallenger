//
//  ScriptControlManager.h
//  AiPong
//
//  Created by Jussi Enroos on 15.1.2013.
//
//

#import "Paddle.h"
#import "PongState.h"

@protocol ScriptControlManager <NSObject>

@required

// Pong
-(int)pongInitializePaddle:(Paddle*)paddle file:(NSString*)file;
-(int)pongUpdate:(PongState*)state;
-(int)pongFinish;

@end
