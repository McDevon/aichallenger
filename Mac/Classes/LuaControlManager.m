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
    


    // THIS OPENS LUA LIBRARIES TO USE
    luaL_openlibs(pl_lua_state);
    
    // THIS SETS MODULE FUNCTIONS AS GLOBALS
    // Open modules
    const luaL_Reg* moduleFunctions=modfuncs;
    for(;moduleFunctions->func;moduleFunctions++){
        lua_register(pl_lua_state, modfuncs->name, modfuncs->func);
    }

    // run the Lua script
    int err = luaL_dofile(pl_lua_state,[fileName cStringUsingEncoding:NSASCIIStringEncoding]);

    if (0 != err) {
        NSLog(@"Lua critical error: %s", lua_tostring(pl_lua_state, -1));
    }

    /*err = luaL_loadstring(pl_lua_state, "print(\"Hello, world.\")");
    if (0 != err) {
        NSLog(@"Cannot compile lua file: %s", lua_tostring(pl_lua_state, -1));
    }*/
    
    
    // Try calling a function
    lua_getglobal(pl_lua_state, "helloWorld");
    
    if (lua_pcall(pl_lua_state, 0, 1, 0) != 0)
        luaL_error(pl_lua_state, "error calling hello: %s", lua_tostring(pl_lua_state, -1));
    
    // Try calling a function with a number parameter
    lua_getglobal(pl_lua_state, "square");
    lua_pushnumber(pl_lua_state, 5);
    
    if (lua_pcall(pl_lua_state, 1, 1, 0) != 0)
        luaL_error(pl_lua_state, "error calling square: %s", lua_tostring(pl_lua_state, -1));
    
    int mynumber = lua_tonumber(pl_lua_state, -1);
    NSLog(@"Returned number=%d\n", mynumber);
    
    // Try calling a function with two number parameters
    lua_getglobal(pl_lua_state, "summa");
    lua_pushnumber(pl_lua_state, 5);
    lua_pushnumber(pl_lua_state, 82);
    
    if (lua_pcall(pl_lua_state, 2, 1, 0) != 0)
        luaL_error(pl_lua_state, "error calling summa: %s", lua_tostring(pl_lua_state, -1));
    
    mynumber = lua_tonumber(pl_lua_state, -1);
    NSLog(@"Returned number=%d\n", mynumber);
    
    // Try calling a function with a table
    lua_getglobal(pl_lua_state, "tweaktable");             /* Tell it to run callfuncscript.lua->square() */
    lua_newtable(pl_lua_state);                            /* Push empty table onto stack table now at -1 */
    lua_pushliteral(pl_lua_state, "fname");                /* Push a key onto the stack, table now at -2 */
    lua_pushliteral(pl_lua_state, "Margie");               /* Push a value onto the stack, table now at -3 */
    lua_settable(pl_lua_state, -3);                        /* Take key and value, put into table at -3, */
    /*  then pop key and value so table again at -1 */
    
    lua_pushliteral(pl_lua_state, "lname");                /* Push a key onto the stack, table now at -2 */
    lua_pushliteral(pl_lua_state, "Martinez");             /* Push a value onto the stack, table now at -3 */
    lua_settable(pl_lua_state, -3);                        /* Take key and value, put into table at -3, */
    /*  then pop key and value so table again at -1 */
    
    if (lua_pcall(pl_lua_state, 1, 1, 0) != 0)
        luaL_error(pl_lua_state, "error calling tweaktable: %s", lua_tostring(pl_lua_state, -1));
    
    // Get the returned table
    lua_pushnil(pl_lua_state);  /* Make sure lua_next starts at beginning */
    const char *k, *v;
    while (lua_next(pl_lua_state, -2)) {                    /* TABLE LOCATED AT -2 IN STACK */
        v = lua_tostring(pl_lua_state, -1);                 /* Value at stacktop */
        lua_pop(pl_lua_state,1);                            /* Remove value */
        k = lua_tostring(pl_lua_state, -1);                 /* Read key at stacktop, */
        /* leave in place to guide next lua_next() */
        printf("Fromc k=>%s<, v=>%s<\n", k, v);
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
