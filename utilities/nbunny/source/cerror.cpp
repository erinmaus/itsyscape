////////////////////////////////////////////////////////////////////////////////
// source/scene.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <cerrno>
#include <algorithm> 
#include <cctype>
#include <locale>
#include "nbunny/nbunny.hpp"

static int get_error(lua_State* L)
{
	lua_pushinteger(L, errno);
	lua_pushstring(L, std::strerror(errno));

	return 2;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_cerror(lua_State* L)
{
	sol::stack::push(L, get_error);

	return 1;
}
