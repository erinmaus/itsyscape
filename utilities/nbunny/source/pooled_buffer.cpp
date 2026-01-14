////////////////////////////////////////////////////////////////////////////////
// source/game_manager.cpp
//
// This file is a part of ItsyScape.
//
// This Source Co Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <algorithm>
#include "modules/data/DataModule.h"
#include "nbunny/lua_runtime.hpp"
#include "nbunny/game_manager.hpp"
#include "nbunny/pooled_buffer.hpp"
#include <iostream>

static const std::uint8_t TYPE_NIL = 0;
static const std::uint8_t TYPE_NUMBER = 1;
static const std::uint8_t TYPE_BOOLEAN = 2;
static const std::uint8_t TYPE_STRING = 3;
static const std::uint8_t TYPE_TABLE = 4;
static const std::uint8_t TYPE_OBJECT = 5;
static const std::uint8_t TYPE_PROXY = 6;
static const std::uint8_t TYPE_ARGS = 7;

// so we want, for encoding:
// - input object metatables table<metatable, int>
// - input proxy metatables table<metatable, interface>

// and for decoding:
// - table pool (weak keys)
// - input object metatables table<int, metatable>
// - input proxy metatables table<interface, metatable>
// - input proxies table<interface, table<any, proxy>>
// - output table pool (weak keys)

static const int ENCODE_UPVALUE_OBJECT_METATABLES = 2;
static const int ENCODE_UPVALUE_PROXY_METATABLES = 3;
static const int ENCODE_UPVALUE_COUNT = 4;

static const int DECODE_UPVALUE_OBJECT_METATABLES = 4;
static const int DECODE_UPVALUE_PROXY_METATABLES = 5;
static const int DECODE_UPVALUE_PROXIES = 6;
static const int DECODE_UPVALUE_INPUT_TABLE_POOL = 7;
static const int DECODE_UPVALUE_OUTPUT_TABLE_POOL = 8;
static const int DECODE_UPVALUE_COUNT = 9;

static const int DECODE_CLEAR_TABLE_STACK_INDEX = 1;

static const std::uint8_t TOKEN_BEGIN = 1;
static const std::uint8_t TOKEN_END = 2;

static const int PROXY_ID_SYMBOL = 0;

static void nbunny_buffer_encode(lua_State* L, nbunny::PooledBuffer& p, int index, int current_depth);
static void nbunny_buffer_decode(lua_State* L, nbunny::PooledBuffer& p);

static void nbunny_buffer_encode_raw_table_array(lua_State* L, nbunny::PooledBuffer& p, int index, int current_depth, std::size_t& length)
{
	length = 0;

	auto length_offset = p.buffer.tell();
	p.buffer.append(length);

	lua_rawgeti(L, index, length + 1);
	while (!lua_isnil(L, -1))
	{
		++length;

		nbunny_buffer_encode(L, p, -1, current_depth);

		lua_pop(L, 1);
		lua_rawgeti(L, index, length + 1);
	}
	lua_pop(L, 1);

	std::memcpy((std::uint8_t*)p.buffer.get_pointer() + length_offset, &length, sizeof(std::size_t));
}

static void nbunny_buffer_encode_raw_table_dict(lua_State* L, nbunny::PooledBuffer& p, int index, int current_depth, std::size_t array_length)
{
	std::size_t length = 0;

	auto length_offset = p.buffer.tell();
	p.buffer.append(length);

	lua_pushnil(L);
	while (lua_next(L, index))
	{
		if (lua_type(L, -2) == LUA_TNUMBER)
		{
			auto value = lua_tointeger(L, -2);
			if (value >= 1 and value <= array_length)
			{
				lua_pop(L, 1);
				continue;
			}
		}

		++length;
		nbunny_buffer_encode(L, p, -2, current_depth);
		nbunny_buffer_encode(L, p, -1, current_depth);

		lua_pop(L, 1);
	}

	std::memcpy((std::uint8_t*)p.buffer.get_pointer() + length_offset, &length, sizeof(std::size_t));
}

static void nbunny_buffer_encode_raw_table(lua_State* L, nbunny::PooledBuffer& p, int index, int current_depth)
{
	std::size_t array_length = 0;
	nbunny_buffer_encode_raw_table_array(L, p, index, current_depth, array_length);
	nbunny_buffer_encode_raw_table_dict(L, p, index, current_depth, array_length);
}

static void nbunny_buffer_encode_table(lua_State* L, nbunny::PooledBuffer& p, int index, int current_depth)
{
	if (lua_getmetatable(L, index))
	{
		lua_pushvalue(L, -1);
		lua_rawget(L, lua_upvalueindex(ENCODE_UPVALUE_OBJECT_METATABLES));

		if (!lua_isnil(L, -1))
		{
			p.buffer.append(TYPE_OBJECT);

			int metatable_index = luaL_checkinteger(L, -1);
			p.buffer.append(metatable_index);

			lua_pop(L, 2);

			nbunny_buffer_encode_raw_table(L, p, index, current_depth);
		}
		else
		{
			lua_pop(L, 1);

			lua_rawget(L, lua_upvalueindex(ENCODE_UPVALUE_PROXY_METATABLES));
			if (!lua_isnil(L, -1))
			{
				p.buffer.append(TYPE_PROXY);
				nbunny_buffer_encode(L, p, -1, current_depth);
				lua_pop(L, 1);

				lua_pushlightuserdata(L, (void*)&PROXY_ID_SYMBOL);
				lua_rawget(L, index);

				if (lua_isnil(L, -1))
				{
					luaL_error(L, "expected value at proxy buffer ID symbol field, got nil");
				}
				else
				{
					nbunny_buffer_encode(L, p, -1, current_depth);
					lua_pop(L, 1);
				}
			}
			else
			{
				luaL_error(L, "cannot serialize table with metatable; unrecognized metatable");
			}
		}
	}
	else
	{
		p.buffer.append(TYPE_TABLE);
		nbunny_buffer_encode_raw_table(L, p, index, current_depth);
	}
}

static inline void nbunny_buffer_encode_nil(lua_State* L, nbunny::PooledBuffer& p, int index)
{
	p.buffer.append(TYPE_NIL);
}

static inline void nbunny_buffer_encode_number(lua_State* L, nbunny::PooledBuffer& p, int index)
{
	p.buffer.append(TYPE_NUMBER);

	auto value = (float)lua_tonumber(L, index);
	p.buffer.append(value);
}

static inline void nbunny_buffer_encode_string(lua_State* L, nbunny::PooledBuffer& p, int index)
{
	p.buffer.append(TYPE_STRING);

	std::size_t length = 0;
	auto value = lua_tolstring(L, index, &length);

	p.buffer.append(length);
	p.buffer.append((const std::uint8_t*)value, length);
}

static inline void nbunny_buffer_encode_boolean(lua_State* L, nbunny::PooledBuffer& p, int index)
{
	p.buffer.append(TYPE_BOOLEAN);

	int value = lua_toboolean(L, index);
	p.buffer.append(value);
}

static void nbunny_buffer_encode(lua_State* L, nbunny::PooledBuffer& p, int index, int current_depth)
{
	++current_depth;
	if (current_depth > p.max_depth)
	{
		luaL_error(L, "stack depth (%d) exceeded", p.max_depth);
		return;
	}

	if (index < 0)
	{
		index += lua_gettop(L) + 1;
	}

	switch (lua_type(L, index))
	{
		case LUA_TNIL:
			nbunny_buffer_encode_nil(L, p, index);
			break;
		case LUA_TNUMBER:
			nbunny_buffer_encode_number(L, p, index);
			break;
		case LUA_TSTRING:
			nbunny_buffer_encode_string(L, p, index);
			break;
		case LUA_TBOOLEAN:
			nbunny_buffer_encode_boolean(L, p, index);
			break;
		case LUA_TTABLE:
			nbunny_buffer_encode_table(L, p, index, current_depth);
			break;
		default:
			luaL_error(L, "expected nil, number, string, boolean, or table; got '%s' at index '%d'", lua_typename(L, lua_type(L, index)), index);
			break;
	}

	p.pointer = p.buffer.tell();
}

static inline void nbunny_buffer_decode_nil(lua_State* L, nbunny::PooledBuffer& p)
{
	lua_pushnil(L);
}

static inline void nbunny_buffer_decode_number(lua_State* L, nbunny::PooledBuffer& p)
{
	float value = 0.0f;
	p.buffer.read(value);

	lua_pushnumber(L, value);
}


static inline void nbunny_buffer_decode_string(lua_State* L, nbunny::PooledBuffer& p)
{
	std::size_t length = 0;
	p.buffer.read(length);

	p.string.resize(length);
	p.buffer.read(&p.string[0], length);

	lua_pushlstring(L, (const char*)&p.string[0], length);
}

static inline void nbunny_buffer_decode_boolean(lua_State* L, nbunny::PooledBuffer& p)
{
	int value;
	p.buffer.read(value);

	lua_pushboolean(L, value);
}

static inline void nbunny_buffer_clear_table(lua_State* L, nbunny::PooledBuffer& p, int index)
{
	if (!p.table_clear_func)
	{
		luaL_error(L, "table.clear not provided");
	}

	lua_pushvalue(L, index);
	lua_replace(L, DECODE_CLEAR_TABLE_STACK_INDEX);

	p.table_clear_func(L);
}

static inline void nbunny_buffer_decode_new_table(lua_State* L, nbunny::PooledBuffer& p)
{
	int length = lua_objlen(L, DECODE_UPVALUE_INPUT_TABLE_POOL);
	if (length == 0)
	{
		lua_newtable(L);
	}
	else
	{
		lua_rawgeti(L, DECODE_UPVALUE_INPUT_TABLE_POOL, length);

		lua_pushnil(L);
		lua_rawseti(L, DECODE_UPVALUE_INPUT_TABLE_POOL, length);
	}

	lua_pushnil(L);
	lua_setmetatable(L, -2);

	lua_pushvalue(L, -1);
	nbunny_buffer_clear_table(L, p, -1);

	int other_length = lua_objlen(L, DECODE_UPVALUE_OUTPUT_TABLE_POOL);
	lua_rawseti(L, DECODE_UPVALUE_OUTPUT_TABLE_POOL, other_length + 1);
}

static inline void nbunny_buffer_decode_table_array(lua_State* L, nbunny::PooledBuffer& p)
{
	int index = lua_gettop(L);

	std::size_t length = 0;
	p.buffer.read(length);

	for (std::size_t i = 1; i <= length; ++i)
	{
		nbunny_buffer_decode(L, p);
		lua_rawseti(L, index, i);
	}
}

static inline void nbunny_buffer_decode_table_dict(lua_State* L, nbunny::PooledBuffer& p)
{
	int index = lua_gettop(L);

	std::size_t length = 0;
	p.buffer.read(length);

	for (std::size_t i = 1; i <= length; ++i)
	{
		nbunny_buffer_decode(L, p);
		nbunny_buffer_decode(L, p);
		lua_rawset(L, index);
	}
}

static inline void nbunny_buffer_decode_table(lua_State* L, nbunny::PooledBuffer& p)
{
	nbunny_buffer_decode_new_table(L, p);

	nbunny_buffer_decode_table_array(L, p);
	nbunny_buffer_decode_table_dict(L, p);
}

static inline void nbunny_buffer_decode_object(lua_State* L, nbunny::PooledBuffer& p)
{
	int metatable_index = 0;
	p.buffer.read(metatable_index);

	nbunny_buffer_decode_new_table(L, p);

	nbunny_buffer_decode_table_array(L, p);
	nbunny_buffer_decode_table_dict(L, p);

	lua_rawgeti(L, DECODE_UPVALUE_OBJECT_METATABLES, metatable_index);
	if (lua_isnil(L, -1))
	{
		luaL_error(L, "expected metatable at index '%d'; encode/decode metatable list mismatch?", metatable_index);
	}

	lua_setmetatable(L, -2);
}

static inline void nbunny_buffer_decode_proxy(lua_State* L, nbunny::PooledBuffer& p)
{
	nbunny_buffer_decode(L, p);
	lua_gettable(L, DECODE_UPVALUE_PROXIES);

	if (lua_isnil(L, -1))
	{
		luaL_error(L, "missing interface");	
		return;
	}

	nbunny_buffer_decode(L, p);
	lua_gettable(L, -2);

	if (lua_isnil(L, -1))
	{
		luaL_error(L, "missing proxy");
		return;
	}

	lua_remove(L, -2);
}

static void nbunny_buffer_decode(lua_State* L, nbunny::PooledBuffer& p)
{
	std::uint8_t type = LUA_TNIL;
	p.buffer.read(type);

	switch (type)
	{
		case TYPE_NIL:
			nbunny_buffer_decode_nil(L, p);
			break;

		case TYPE_NUMBER:
			nbunny_buffer_decode_number(L, p);
			break;

		case TYPE_STRING:
			nbunny_buffer_decode_string(L, p);
			break;

		case TYPE_BOOLEAN:
			nbunny_buffer_decode_boolean(L, p);
			break;

		case TYPE_TABLE:
			nbunny_buffer_decode_table(L, p);
			break;

		case TYPE_OBJECT:
			nbunny_buffer_decode_object(L, p);
			break;

		case TYPE_PROXY:
			nbunny_buffer_decode_proxy(L, p);
			break;

		default:
			luaL_error(L, "unknown type '%d' during decode", L, (int)type);
			break;
	}
}

static void nbunny_pooled_buffer_encode_impl_init_metatable_upvalue(lua_State* L, nbunny::PooledBuffer& p)
{
	nbunny_buffer_clear_table(L, p, lua_upvalueindex(ENCODE_UPVALUE_OBJECT_METATABLES));

	lua_getfield(L, 3, "metatable");
	if (lua_isnil(L, -1))
	{
		lua_pop(L, 1);
		return;
	}

	std::size_t metatable_length = lua_objlen(L, -1);
	for (std::size_t i = 1; i <= metatable_length; ++i)
	{
		lua_rawgeti(L, -1, i);
		lua_pushinteger(L, i);

		lua_rawset(L, lua_upvalueindex(ENCODE_UPVALUE_OBJECT_METATABLES));
	}

	lua_pop(L, 1);
}

static void nbunny_pooled_buffer_encode_impl_init_proxy_upvalue(lua_State* L, nbunny::PooledBuffer& p)
{
	nbunny_buffer_clear_table(L, p, lua_upvalueindex(ENCODE_UPVALUE_PROXY_METATABLES));

	lua_getfield(L, 3, "proxy");
	if (lua_isnil(L, -1))
	{
		lua_pop(L, 1);
		return;
	}

	lua_pushnil(L);
	while (lua_next(L, -2))
	{
		lua_pushvalue(L, -2);
		lua_pushvalue(L, -2);

		lua_rawset(L, lua_upvalueindex(ENCODE_UPVALUE_PROXY_METATABLES));
		lua_pop(L, 1);
	}

	lua_pop(L, 1);
}

static int nbunny_pooled_buffer_encode_impl(lua_State* L)
{
	lua_pushnil(L);
	lua_insert(L, 1);

	auto pooled_buffer = (nbunny::PooledBuffer*)lua_touserdata(L, 2);

	nbunny_pooled_buffer_encode_impl_init_metatable_upvalue(L, *pooled_buffer);
	nbunny_pooled_buffer_encode_impl_init_proxy_upvalue(L, *pooled_buffer);

	int length = std::max(lua_gettop(L) - 3, 0);
	pooled_buffer->buffer.append(length);

	for (auto i = 4; i <= lua_gettop(L); ++i)
	{
		nbunny_buffer_encode(L, *pooled_buffer, i, -1);
	}

	lua_pushvalue(L, 2);
	return 1;
}

static void nbunny_pooled_buffer_decode_impl_init_metatable_upvalue(lua_State* L, nbunny::PooledBuffer& p)
{
	nbunny_buffer_clear_table(L, p, lua_upvalueindex(DECODE_UPVALUE_OBJECT_METATABLES));

	lua_getfield(L, 3, "metatable");
	if (lua_isnil(L, -1))
	{
		lua_pop(L, 1);
		return;
	}

	lua_pushvalue(L, lua_upvalueindex(DECODE_UPVALUE_OBJECT_METATABLES));
	lua_insert(L, DECODE_UPVALUE_OBJECT_METATABLES);

	std::size_t metatable_length = lua_objlen(L, -1);
	for (std::size_t i = 1; i <= metatable_length; ++i)
	{
		lua_rawgeti(L, -1, i);
		lua_rawseti(L, DECODE_UPVALUE_OBJECT_METATABLES, i);
	}

	lua_pop(L, 1);
}

static void nbunny_pooled_buffer_decode_impl_init_proxy_upvalue(lua_State* L, nbunny::PooledBuffer& p)
{
	nbunny_buffer_clear_table(L, p, lua_upvalueindex(DECODE_UPVALUE_PROXY_METATABLES));

	lua_getfield(L, 3, "proxy");
	if (lua_isnil(L, -1))
	{
		lua_pop(L, 1);
		return;
	}

	lua_pushvalue(L, lua_upvalueindex(DECODE_UPVALUE_PROXY_METATABLES));
	lua_insert(L, DECODE_UPVALUE_PROXY_METATABLES);

	lua_pushnil(L);
	while (lua_next(L, -2))
	{
		lua_pushvalue(L, -1);
		lua_pushvalue(L, -3);

		lua_rawset(L, DECODE_UPVALUE_PROXY_METATABLES);
		lua_pop(L, 1);
	}

	lua_pop(L, 1);
}

static void nbunny_pooled_buffer_decode_impl_init_table_pools(lua_State* L)
{
	lua_getfield(L, 3, "inputTablePool");
	if (lua_isnil(L, -1))
	{
		lua_pop(L, 1);
		lua_newtable(L);
	}
	lua_insert(L, DECODE_UPVALUE_INPUT_TABLE_POOL);

	lua_getfield(L, 3, "outputTablePool");
	if (lua_isnil(L, -1))
	{
		lua_pop(L, 1);
		lua_newtable(L);
	}
	lua_insert(L, DECODE_UPVALUE_OUTPUT_TABLE_POOL);
}

static void nbunny_pooled_buffer_decode_impl_init_proxies(lua_State* L)
{
	lua_getfield(L, 3, "proxyInstances");
	if (lua_isnil(L, -1))
	{
		lua_pop(L, 1);
		lua_newtable(L);
	}

	lua_insert(L, DECODE_UPVALUE_PROXIES);
}

static int nbunny_pooled_buffer_decode_impl(lua_State* L)
{
	lua_pushnil(L);
	lua_insert(L, 1);

	auto pooled_buffer = (nbunny::PooledBuffer*)lua_touserdata(L, 2);
	nbunny_pooled_buffer_decode_impl_init_metatable_upvalue(L, *pooled_buffer);
	nbunny_pooled_buffer_decode_impl_init_proxy_upvalue(L, *pooled_buffer);
	nbunny_pooled_buffer_decode_impl_init_proxies(L);
	nbunny_pooled_buffer_decode_impl_init_table_pools(L);

	int length = 0;
	pooled_buffer->buffer.read(length);

	for (int i = 0; i < length; ++i)
	{
		nbunny_buffer_decode(L, *pooled_buffer);
	}

	return length;
}

static int nbunny_pooled_buffer_new(lua_State* L)
{
	auto clear = lua_tocfunction(L, 1);
	auto max_depth = luaL_optinteger(L, 2, 100);

	auto pooled_buffer = new nbunny::PooledBuffer();
	pooled_buffer->table_clear_func = clear;
	pooled_buffer->max_depth = max_depth;

	lua_pushlightuserdata(L, pooled_buffer);

	return 1;
}

static int nbunny_pooled_buffer_restart(lua_State* L)
{
	auto pooled_buffer = (nbunny::PooledBuffer*)lua_touserdata(L, 1);
	pooled_buffer->buffer.seek(0);

	return 0;
}

static int nbunny_pooled_buffer_reset(lua_State* L)
{
	auto pooled_buffer = (nbunny::PooledBuffer*)lua_touserdata(L, 1);
	pooled_buffer->buffer.seek(0);
	pooled_buffer->pointer = 0;

	return 0;
}

static int nbunny_pooled_buffer_free(lua_State* L)
{
	auto pooled_buffer = (nbunny::PooledBuffer*)lua_touserdata(L, 1);
	delete pooled_buffer;

	return 0;
}

static int nbunny_pooled_buffer_copy(lua_State* L)
{
	auto from_buffer = (nbunny::PooledBuffer*)lua_touserdata(L, 1);
	auto to_buffer = (nbunny::PooledBuffer*)lua_touserdata(L, 2);

	if (to_buffer->table_clear_func != from_buffer->table_clear_func)
	{
		luaL_error(L, "pooled buffers incompatible");
		return 0;
	}

	to_buffer->buffer.seek(0);
	to_buffer->buffer.append((const std::uint8_t*)from_buffer->buffer.get_pointer(), from_buffer->pointer);
	to_buffer->string.resize(std::max(from_buffer->string.size(), to_buffer->string.size()));
	to_buffer->pointer = from_buffer->pointer;
	to_buffer->max_depth = from_buffer->max_depth;

	return 0;
}

static int nbunny_pooled_buffer_pending(lua_State* L)
{
	auto pooled_buffer = (nbunny::PooledBuffer*)lua_touserdata(L, 1);
	lua_pushboolean(L, pooled_buffer->buffer.tell() < pooled_buffer->pointer);
	return 1;
}

static int nbunny_pooled_buffer_append(lua_State* L)
{
	auto from_buffer = (nbunny::PooledBuffer*)lua_touserdata(L, 1);
	auto to_buffer = (nbunny::PooledBuffer*)lua_touserdata(L, 2);

	to_buffer->buffer.append((const std::uint8_t*)from_buffer->buffer.get_pointer(), from_buffer->pointer);
	to_buffer->pointer += from_buffer->pointer;

	return 0;
}

static int nbunny_pooled_buffer_clone(lua_State* L)
{
	auto buffer = (nbunny::PooledBuffer*)lua_touserdata(L, 1);
	auto new_buffer = new nbunny::PooledBuffer(*buffer);

	lua_pushlightuserdata(L, new_buffer);
	return 1;
}

static int nbunny_pooled_buffer_perform(lua_State* L)
{
	lua_call(L, lua_gettop(L) - 1, LUA_MULTRET);
	return lua_gettop(L);
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_pooledbuffer(lua_State* L)
{
	lua_newtable(L);

	nbunny::lua::push_function(L, &nbunny_pooled_buffer_new, "PooledBuffer.new");
	lua_setfield(L, -2, "new");

	nbunny::lua::push_function(L, &nbunny_pooled_buffer_restart, "PooledBuffer.reset");
	lua_setfield(L, -2, "reset");

	nbunny::lua::push_function(L, &nbunny_pooled_buffer_restart, "PooledBuffer.restart");
	lua_setfield(L, -2, "restart");

	nbunny::lua::push_function(L, &nbunny_pooled_buffer_free, "PooledBuffer.free");
	lua_setfield(L, -2, "free");

	nbunny::lua::push_function(L, &nbunny_pooled_buffer_copy, "PooledBuffer.copy");
	lua_setfield(L, -2, "copy");

	nbunny::lua::push_function(L, &nbunny_pooled_buffer_append, "PooledBuffer.copy");
	lua_setfield(L, -2, "append");

	nbunny::lua::push_function(L, &nbunny_pooled_buffer_clone, "PooledBuffer.clone");
	lua_setfield(L, -2, "clone");

	nbunny::lua::push_function(L, &nbunny_pooled_buffer_pending, "PooledBuffer.pending");
	lua_setfield(L, -2, "pending");

	nbunny::lua::push_function(L, &nbunny_pooled_buffer_perform, "PooledBuffer.perform");
	lua_setfield(L, -2, "perform");

	for (int i = 0; i < ENCODE_UPVALUE_COUNT; ++i)
	{
		lua_newtable(L);
	}
	lua_pushcclosure(L, &nbunny_pooled_buffer_encode_impl, ENCODE_UPVALUE_COUNT);
	lua_setfield(L, -2, "encode");

	for (int i = 0; i < DECODE_UPVALUE_COUNT; ++i)
	{
		lua_newtable(L);
	}
	lua_pushcclosure(L, &nbunny_pooled_buffer_decode_impl, DECODE_UPVALUE_COUNT);
	lua_setfield(L, -2, "decode");

	lua_pushlightuserdata(L, (void*)&PROXY_ID_SYMBOL);
	lua_setfield(L, -2, "ID");

	return 1;
}

