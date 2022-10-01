////////////////////////////////////////////////////////////////////////////////
// source/init.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "nbunny/nbunny.hpp"

static int LUA_STATE_KEY = 0;

void nbunny::set_lua_state(lua_State* L)
{
	lua_getregistry(L);

	lua_pushlightuserdata(L, &LUA_STATE_KEY);
	lua_rawget(L, -2);
	if (!lua_isnil(L, -1)) {
		luaL_error(L, "NBunny already initialized.");
	}
	lua_pop(L, 1);

	lua_pushlightuserdata(L, &LUA_STATE_KEY);
	lua_pushthread(L);
	lua_rawset(L, -3);

	lua_pop(L, 1);
}

lua_State* nbunny::get_lua_state(lua_State* L)
{
	lua_getregistry(L);
	lua_pushlightuserdata(L, &LUA_STATE_KEY);
	lua_rawget(L, -2);

	lua_State* state = lua_tothread(L, -1);
	lua_pop(L, 2);

	return state;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_init(lua_State* L)
{
	nbunny::set_lua_state(L);
	lua_pushboolean(L, true);
	return 1;
}
