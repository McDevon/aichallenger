//
//  LuaControlManager.m
//  AiPong
//
//  Created by Jussi Enroos on 15.1.2013.
//
//

#import "LuaControlManager.h"
#import "GameManager.h"

@implementation LuaControlManager

#pragma mark -
#pragma mark Control initialization

-(int)pongInitializePaddle:(Paddle *)pad file:(NSString *)file
{
    paddle = [pad retain];
    fileName = [file copy];
    
    // Create state
    pl_lua_state = luaL_newstate();
    
    // setup global printing (trace)
    //lua_pushcclosure (lua_state, printMessage, 0);
    //lua_setglobal (lua_state, "trace");
    
    // Open built-in libraries
    /*const luaL_Reg* libraries=lua_libraries;
    for(;libraries->func;libraries++){
        lua_pushcfunction(pl_lua_state,libraries->func);
        lua_pushstring(pl_lua_state,libraries->name);
        lua_call(pl_lua_state,1,0);
    }*/

    
    // Open modules
    /*const luaL_Reg* moduleFunctions=modfuncs;
    for(;moduleFunctions->func;moduleFunctions++){
        lua_pushcfunction(pl_lua_state,modfuncs->func);
        lua_pushstring(pl_lua_state,modfuncs->name);
        lua_call(pl_lua_state,1,0);
    }*/
    
    const luaL_Reg *lib = lua_libraries;
    for(; lib->func != NULL; lib++)
    {
        lib->func(pl_lua_state);
        lua_settop(pl_lua_state, 0);
    }
    
    //lua_register(pl_lua_state, "pong", modfuncs);

    // run the Lua script
    int err = luaL_dofile(pl_lua_state,[fileName cStringUsingEncoding:NSASCIIStringEncoding]);

    if (0 != err) {
        NSLog(@"Lua critical error: %s", lua_tostring(pl_lua_state, -1));
    }

    err = luaL_loadstring(pl_lua_state, "print(\"Hello, world.\")");
    if (0 != err) {
        luaL_error(pl_lua_state, "cannot compile lua file: %s",
                   lua_tostring(pl_lua_state, -1));
    }

    
    return 1;
}

-(int)pongUpdate:(PongState *)state
{
    return 1;
}

-(int)pongFinish
{
    printf("\nDone!\n");
    lua_close(pl_lua_state);
    
    return 1;
}

-(void)runTest
{
    
}

#pragma mark -
#pragma mark Lua wrapper functions

static int printMessage (lua_State *lua)
{
    //assert (lua_isstring (lua,1));
    
    const char *msg = lua_tostring (lua, 1);
    
    // debug output
    NSLog(@"Script: %s", msg);
    
    return 0;
}

#pragma mark -
#pragma mark Lua libraries

static const luaL_Reg lua_libraries [] ={
	{"base",luaopen_base},
	{NULL, NULL}
};

static const luaL_Reg modfuncs [] =
{
    { "trace", printMessage},
    { NULL, NULL }
};


@end
