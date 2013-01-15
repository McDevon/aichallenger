//
//  LuaControlManager.h
//  AiPong
//
//  Created by Jussi Enroos on 15.1.2013.
//
//

#import <Foundation/Foundation.h>
#import "ScriptControlManager.h"

#include "LuaInc.h"

@interface LuaControlManager : NSObject <ScriptControlManager>
{
    // Player status in lua and on screen
    lua_State   *pl_lua_state;
    Paddle      *paddle;
    
    NSString    *fileName;
};

@end
