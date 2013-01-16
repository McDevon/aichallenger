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

@synthesize player;
@synthesize pl_lua_state;

-(id) init
{
    if (self = [super init]) {
        //paddles = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    return self;
}

-(void) dealloc
{
    //[paddles release];
    self.player = nil;
    
    if (fileName != nil) {
        [fileName release];
    }
    
    [super dealloc];
}

#pragma mark -
#pragma mark Control initialization

-(int)pongInitializePlayer:(Player *)pl file:(NSString *)file
{
    self.player = pl;
    fileName = [file copy];
    
    // Create state
    pl_lua_state = luaL_newstate();
    


    // THIS OPENS LUA LIBRARIES TO USE
    luaL_openlibs(pl_lua_state);
    
    // THIS SETS MODULE FUNCTIONS AS GLOBALS
    // Open modules
    const luaL_Reg* moduleFunctions = modfuncs;
    for(;moduleFunctions->func;moduleFunctions++){
        lua_register(pl_lua_state, modfuncs->name, modfuncs->func);
    }
    
    luaL_requiref(pl_lua_state, "pong", lua_pong, 1);
    lua_pop(pl_lua_state, 1);  /* remove lib */

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
    /*lua_getglobal(pl_lua_state, "helloWorld");
    
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
    lua_getglobal(pl_lua_state, "tweaktable");
    lua_newtable(pl_lua_state);                      
    lua_pushliteral(pl_lua_state, "fname");           
    lua_pushliteral(pl_lua_state, "Margie");             
    lua_settable(pl_lua_state, -3);                       
    //  then pop key and value so table again at -1
    
    lua_pushliteral(pl_lua_state, "lname");             
    lua_pushliteral(pl_lua_state, "Martinez");       
    lua_settable(pl_lua_state, -3);                 
    lua_pushliteral(pl_lua_state, "kname");        
    lua_pushliteral(pl_lua_state, "Taukko");        
    lua_settable(pl_lua_state, -3);                    
    lua_pushliteral(pl_lua_state, "pname");            
    lua_pushliteral(pl_lua_state, "Saulikko");          
    lua_settable(pl_lua_state, -3);                       
    //  then pop key and value so table again at -1 
    
    if (lua_pcall(pl_lua_state, 1, 1, 0) != 0)
        luaL_error(pl_lua_state, "error calling tweaktable: %s", lua_tostring(pl_lua_state, -1));
    
    // Get the returned table
    lua_pushnil(pl_lua_state);  // Make sure lua_next starts at beginning
    const char *k, *v;
    while (lua_next(pl_lua_state, -2)) {                    // TABLE LOCATED AT -2 IN STACK 
        v = lua_tostring(pl_lua_state, -1);                 // Value at stacktop 
        lua_pop(pl_lua_state,1);                            // Remove value 
        k = lua_tostring(pl_lua_state, -1);                 // Read key at stacktop, 
        // leave in place to guide next lua_next() 
        printf("Fromc k=>%s<, v=>%s<\n", k, v);
    }*/

    return 1;
}

-(int)pongUpdatePlayers:(NSArray*)players ball:(Ball*)ball width:(float)width height:(float)height delta:(float)timeDelta;
{
    //return 1;
    
    /*
     * Call update function in Lua
     */
    Player *me;
    Player *pl2;
    
    for (Player *pl in players) {
        if (pl == player) {
            me = pl;
        } else {
            pl2 = pl;
        }
    }
    
    lua_getglobal(pl_lua_state, "update");
    // Player tables (self and opponent)
    [self pushPlayerTableToLua:me];
    [self pushPlayerTableToLua:pl2];
    
    [self pushBallTableToLua:ball];
    
    // Field table
    lua_newtable(pl_lua_state);
    lua_pushliteral(pl_lua_state, "width");
    lua_pushnumber(pl_lua_state, width);
    lua_settable(pl_lua_state, -3);
    
    lua_pushliteral(pl_lua_state, "height");
    lua_pushnumber(pl_lua_state, height);
    lua_settable(pl_lua_state, -3);
    
    lua_pushliteral(pl_lua_state, "dt");
    lua_pushnumber(pl_lua_state, timeDelta);
    lua_settable(pl_lua_state, -3);
    
    if (lua_pcall(pl_lua_state, 4, 0, 0) != 0)
        luaL_error(pl_lua_state, "error calling update: %s", lua_tostring(pl_lua_state, -1));

    return 1;
}

-(void)pushBallTableToLua:(Ball*)ball
{
    lua_newtable(pl_lua_state);
    
    // Fix x positions if we are on the right
    float xPosition = ball.position.x;
    if (player.side == side_right) {
        xPosition = [GameManager instance].sceneSize.width - xPosition;
    }
    
    // x
    lua_pushliteral(pl_lua_state, "x");
    lua_pushnumber(pl_lua_state, xPosition);
    lua_settable(pl_lua_state, -3);
    
    // y
    lua_pushliteral(pl_lua_state, "y");
    lua_pushnumber(pl_lua_state, ball.position.y);
    lua_settable(pl_lua_state, -3);
    
    // radius
    lua_pushliteral(pl_lua_state, "radius");
    lua_pushnumber(pl_lua_state, ball.radius);
    lua_settable(pl_lua_state, -3);
}

-(void)pushPlayerTableToLua:(Player*)pl
{
    lua_newtable(pl_lua_state);

    // Name
    lua_pushliteral(pl_lua_state, "name");
    lua_pushstring(pl_lua_state, [pl.name cStringUsingEncoding:NSASCIIStringEncoding]);
    lua_settable(pl_lua_state, -3);
    
    // Later make this support multiple paddles?
    if ([pl.paddles count] > 0) {
        Paddle *paddle = [pl.paddles objectAtIndex:0];
        
        // Fix x positions if we are on the right
        float xPosition = paddle.position.x;
        if (player.side == side_right) {
            xPosition = [GameManager instance].sceneSize.width - xPosition;
        }
        
        // x
        lua_pushliteral(pl_lua_state, "x");
        lua_pushnumber(pl_lua_state, xPosition);
        lua_settable(pl_lua_state, -3);
        
        // y
        lua_pushliteral(pl_lua_state, "y");
        lua_pushnumber(pl_lua_state, paddle.position.y);
        lua_settable(pl_lua_state, -3);
        
        // width
        lua_pushliteral(pl_lua_state, "width");
        lua_pushnumber(pl_lua_state, paddle.width);
        lua_settable(pl_lua_state, -3);
        
        // height
        lua_pushliteral(pl_lua_state, "height");
        lua_pushnumber(pl_lua_state, paddle.height);
        lua_settable(pl_lua_state, -3);
        
        // speed
        lua_pushliteral(pl_lua_state, "speed");
        lua_pushnumber(pl_lua_state, paddle.speed);
        lua_settable(pl_lua_state, -3);
    }

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

static int setSpeed (lua_State *lua)
{
    //assert lua_isnumber(lua, 1);
    
    const float newSpeed = lua_tonumber(lua, 1);
    
    float fixedSpeed = MAX(MIN(newSpeed, 1.0f), -1.0f);
    
    // debug output
    //NSLog(@"Set new speed to: %.1f, sanitized to: %.1f", newSpeed, fixedSpeed);
    
    [[GameManager instance] setSpeed:fixedSpeed forLuaState:lua];
    
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
    { "trace", printMessage },
    { "setspeed", setSpeed },
    { NULL, NULL }
};

LUAMOD_API int lua_pong (lua_State *L) {
    luaL_newlib(L, modfuncs);
    return 1;
}


@end
