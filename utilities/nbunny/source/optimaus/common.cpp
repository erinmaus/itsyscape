////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/common.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "nbunny/optimaus/common.hpp"

const static int WEAK_REFERENCE_KEY = 0;
void nbunny::get_weak_reference_table(lua_State* L)
{
	lua_pushlightuserdata(L, const_cast<int*>(&WEAK_REFERENCE_KEY));
	lua_rawget(L, LUA_REGISTRYINDEX);

	if (lua_isnil(L, -1)) {
		lua_pop(L, 1);
		lua_pushlightuserdata(L, const_cast<int*>(&WEAK_REFERENCE_KEY));
		lua_newtable(L);

		// Create metatable with 'weak values'.
		lua_newtable(L);
		lua_pushstring(L, "__mode");
		lua_pushstring(L, "v");
		lua_rawset(L, -3);

		// Assign metatable.
		lua_setmetatable(L, -2);

		// Assign table to registory.
		lua_rawset(L, LUA_REGISTRYINDEX);

		// Retrieve table again.
		lua_pushlightuserdata(L, const_cast<int*>(&WEAK_REFERENCE_KEY));
		lua_rawget(L, LUA_REGISTRYINDEX);
	}
}

void nbunny::get_weak_reference(lua_State* L, int key)
{
	get_weak_reference_table(L);
	lua_rawgeti(L, -1, key);
	lua_remove(L, -2);
}

int nbunny::set_weak_reference(lua_State* L)
{
	get_weak_reference_table(L);
	lua_pushvalue(L, -2);
	return luaL_ref(L, -2);
}

bool nbunny::BaseType::operator ==(const BaseType& other)
{
	return get_type_pointer() == other.get_type_pointer();
}

bool nbunny::BaseType::operator !=(const BaseType& other)
{
	return !(*this == other);
}
