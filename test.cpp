#include <stdio.h>
#include <iostream>
#include "luainc.h"

// list of functions in the module
static int printMessage (lua_State *lua)
{
   //assert (lua_isstring (lua,1));

   const char *msg = lua_tostring (lua, 1);

   // debug output
   std::cout << "script: " << msg << std::endl;
   return 0;
}

int main(int argc, char* argv[])
{
   // create new Lua state
    lua_State *lua_state;
    lua_state = luaL_newstate();
    
    // setup global printing (trace)
    //lua_pushcclosure (lua_state, printMessage, 0);
    //lua_setglobal (lua_state, "trace");
    
    //lua_register(lua_state, "trace", printMessage);
    static const luaL_reg modfuncs[] =
    {
        { "trace", printMessage},
        { "base", printMessage},
        { NULL, NULL }
    };

    lua_register(lua_state, "module", modfuncs);

    // load Lua libraries
    static const luaL_Reg lualibs[] =
    {
        { "base", luaopen_base },
        { NULL, NULL}
    };

    const luaL_Reg *lib = lualibs;
    for(; lib->func != NULL; lib++)
    {
        lib->func(lua_state);
        lua_settop(lua_state, 0);
    }

    // run the Lua script
    luaL_dofile(lua_state,"test.lua");
    
    printf("\nDone!\n");
    lua_close(lua_state);
    
    /*luaopen_io (lua);              // Load io library
    if ((iErr = luaL_loadfile (lua, "test.lua")) == 0)
    {
       // Call main...
       if ((iErr = lua_pcall (lua, 0, LUA_MULTRET, 0)) == 0)
       { 
          // Push the function name onto the stack
          lua_pushstring (lua, "helloWorld");
          // Function is located in the Global Table
          lua_getglobal (lua, "helloWorld");  
          lua_pcall (lua, 0, 0, 0);
       }
    }
    lua_close (lua);*/
    
    return 0;
}