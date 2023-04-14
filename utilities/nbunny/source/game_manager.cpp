////////////////////////////////////////////////////////////////////////////////
// source/game_manager.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "nbunny/game_manager.hpp"

void nbunny::QuaternionTypeProvider::serialize(lua_State* L)
{
	lua_getfield(L, -1, "x");
	auto x = luaL_checknumber(L, -1);

	lua_getfield(L, -2, "y");
	auto y = luaL_checknumber(L, -1);

	lua_getfield(L, -3, "z");
	auto z = luaL_checknumber(L, -1);

	lua_getfield(L, -4, "w");
	auto w = luaL_checknumber(L, -1);

	lua_pop(L, 4);

	lua_createtable(L, 0, 4);

	lua_pushnumber(L, x);
	lua_setfield(L, -2, "x");
	lua_pushnumber(L, y);
	lua_setfield(L, -2, "y");
	lua_pushnumber(L, z);
	lua_setfield(L, -2, "z");
	lua_pushnumber(L, w);
	lua_setfield(L, -2, "w");
}

void nbunny::VectorTypeProvider::serialize(lua_State* L)
{
	lua_getfield(L, -1, "x");
	auto x = luaL_checknumber(L, -1);

	lua_getfield(L, -2, "y");
	auto y = luaL_checknumber(L, -1);

	lua_getfield(L, -3, "z");
	auto z = luaL_checknumber(L, -1);;

	lua_pop(L, 3);

	lua_createtable(L, 0, 3);

	lua_pushnumber(L, x);
	lua_setfield(L, -2, "x");
	lua_pushnumber(L, y);
	lua_setfield(L, -2, "y");
	lua_pushnumber(L, z);
	lua_setfield(L, -2, "z");
}

void nbunny::CacheRefTypeProvider::serialize(lua_State* L)
{
	lua_getfield(L, -1, "filename");
	std::string filename = luaL_checkstring(L, -1);

	lua_getfield(L, -2, "resourceTypeID");
	std::string type = luaL_checkstring(L, -1);

	lua_pop(L, 2);

	lua_createtable(L, 0, 2);

	lua_pushstring(L, filename.c_str());
	lua_setfield(L, -2, "filename");
	lua_pushstring(L, type.c_str());
	lua_setfield(L, -2, "resourceTypeID");
}

void nbunny::InstanceTypeProvider::serialize(lua_State* L)
{
	lua_getfield(L, -1, "id");
	auto id = luaL_optinteger(L, -1, 0);

	lua_pop(L, 1);

	lua_createtable(L, 0, 1);
	lua_pushinteger(L, id);
	lua_setfield(L, -2, "id");
}

int nbunny::GameManagerState::REF = 0;

bool nbunny::GameManagerState::serialize_type(lua_State* L, int index)
{
	lua_getfield(L, -1, "__type");

	auto type_provider = std::find_if(
		type_providers.begin(),
		type_providers.end(),
		[L](auto& pair) {
			sol::stack::push(L, pair.first);

			auto result = lua_rawequal(L, -1, -2);
			lua_pop(L, 1);

			return result;
		}
	);

	lua_pop(L, 2);

	if (type_provider != type_providers.end())
	{
		lua_pushvalue(L, index);
		type_provider->second->serialize(L);

		lua_pushboolean(L, true);
		lua_setfield(L, -2, "__persist");

		lua_pushstring(L, persisted_type_provider_names.find(type_provider->second.get())->second.c_str());
		lua_setfield(L, -2, "typeName");

		lua_remove(L, -2);

		return true;
	}

	return false;
}

void nbunny::GameManagerState::serialize_table(lua_State* L, int table_index)
{
	lua_newtable(L);
	int state_index = lua_gettop(L);

	lua_pushnil(L);
	while (lua_next(L, table_index))
	{
		switch (lua_type(L, -2))
		{
			case LUA_TNUMBER:
			case LUA_TBOOLEAN:
			case LUA_TSTRING:
				switch (lua_type(L, -1))
				{
					case LUA_TNIL:
					case LUA_TNUMBER:
					case LUA_TBOOLEAN:
					case LUA_TSTRING:
						lua_pushvalue(L, -2); // key is at -2, value is at -1
						lua_pushvalue(L, -2); // now key is at -3, and value is at -2
						lua_rawset(L, state_index);
						break;
					case LUA_TTABLE:
						if (!lua_getmetatable(L, -1))
						{
							serialize_table(L, lua_gettop(L));
							lua_pushvalue(L, -3);
							lua_pushvalue(L, -2);

							lua_rawset(L, state_index);

							lua_pop(L, 1);
						}
						else
						{
							serialize_type(L, state_index);
						}
					default:
						// Nothing.
						break;
				}
				break;
			default:
				// Nothing.
				break;
		}

		lua_pop(L, 1);
	}
}

void nbunny::GameManagerState::serialize_arg(lua_State* L, int state_index, int table_index, int stack_index)
{
	switch (lua_type(L, stack_index))
	{
	case LUA_TNIL:
	case LUA_TNUMBER:
	case LUA_TBOOLEAN:
	case LUA_TSTRING:
		lua_pushvalue(L, stack_index);
		lua_rawseti(L, state_index, table_index);
		break;
	case LUA_TTABLE:
		if (!lua_getmetatable(L, stack_index))
		{
			serialize_table(L, stack_index);
			lua_rawseti(L, state_index, table_index);
		}
		else if (serialize_type(L, stack_index))
		{
			lua_rawseti(L, state_index, table_index);
		}
		break;
	case LUA_TFUNCTION:
	case LUA_TUSERDATA:
	case LUA_TTHREAD:
	case LUA_TLIGHTUSERDATA:
	default:
		// Nothing.
		break;
	}
}

nbunny::GameManagerState::GameManagerState(lua_State* L)
{
	connect<QuaternionTypeProvider>(
		L,
		"ItsyScape.Common.Math.Quaternion",
		"ItsyScape.Common.Math.Quaternion");
	connect<VectorTypeProvider>(
		L,
		"ItsyScape.Common.Math.Vector",
		"ItsyScape.Common.Math.Vector");
	connect<CacheRefTypeProvider>(
		L,
		"ItsyScape.Game.CacheRef",
		"ItsyScape.Game.CacheRef");
	connect<InstanceTypeProvider>(
		L,
		"ItsyScape.Game.LocalModel.Game",
		"ItsyScape.Game.Model.Game");
	connect<InstanceTypeProvider>(
		L,
		"ItsyScape.Game.LocalModel.Stage",
		"ItsyScape.Game.Model.Game");
	connect<InstanceTypeProvider>(
		L,
		"ItsyScape.Game.LocalModel.Player",
		"ItsyScape.Game.Model.Player");
	connect<InstanceTypeProvider>(
		L,
		"ItsyScape.Game.LocalModel.Actor",
		"ItsyScape.Game.Model.Actor");
	connect<InstanceTypeProvider>(
		L,
		"ItsyScape.Game.LocalModel.Prop",
		"ItsyScape.Game.Model.Prop");
	connect<InstanceTypeProvider>(
		L,
		"ItsyScape.Game.LocalModel.UI",
		"ItsyScape.Game.Model.UI");
}

void nbunny::GameManagerState::serialize(lua_State* L, int count)
{
	lua_createtable(L, count, 0);
	for (int i = 1; i <= count; ++i)
	{
		serialize_arg(L, lua_gettop(L), count - i + 1, lua_gettop(L) - i);
	}
}

bool nbunny::GameManagerState::deep_equals(lua_State* L, const sol::object& left, const sol::object& right)
{
	if (left.is<sol::table>() && right.is<sol::table>())
	{
		auto left_as_table = left.as<sol::table>();
		auto right_as_table = right.as<sol::table>();

		for (auto& kv: left_as_table)
		{
			sol::stack::push(L, kv.second);
			sol::stack::push(L, right_as_table[kv.first]);

			bool is_equal = true;
			if (lua_type(L, -1) == LUA_TTABLE && lua_type(L, -2) == LUA_TTABLE)
			{
				is_equal = deep_equals(L, right_as_table[kv.first], kv.second);
			}
			else
			{
				is_equal = lua_rawequal(L, -1, -2);
			}
            
            lua_pop(L, 2);

			if (!is_equal)
			{
				return false;
			}
		}

		for (auto& kv: right_as_table)
		{
			if (left_as_table[kv.first] == sol::lua_nil)
			{
				return false;
			}
		}

		return true;
	}

	sol::stack::push(L, left);
	sol::stack::push(L, right);

	bool is_equal = lua_rawequal(L, -1, -2);

	lua_pop(L, 2);

	return is_equal;
}

bool nbunny::GameManagerProperty::update(lua_State* L, GameManagerState& state)
{
	int before = lua_gettop(L);

	lua_getfield(L, -1, field.c_str());
	lua_pushvalue(L, -2);

	lua_call(L, 1, LUA_MULTRET);

	int after = lua_gettop(L);

	state.serialize(L, after - before);

	auto previous_value = current_value;
	current_value = sol::stack::get<sol::object>(L, -1);

	bool was_empty = is_empty;
	is_empty = false;
	
	if (field == "getState" && !was_empty)
	{
		bool result = state.deep_equals(L, previous_value, current_value);
		return was_empty || !result;
	}
	
	bool is_dirty = was_empty || !state.deep_equals(L, previous_value, current_value);

	return is_dirty;
}

int nbunny_game_manager_property_update(lua_State* L)
{
	lua_pushlightuserdata(L, &nbunny::GameManagerState::REF);
	lua_rawget(L, LUA_REGISTRYINDEX);

	nbunny::GameManagerState* state = nullptr;
	if (lua_isnil(L, -1))
	{
		lua_pop(L, 1);

		auto state_shared_pointer = std::make_shared<nbunny::GameManagerState>(L);
		state = state_shared_pointer.get();

		lua_pushlightuserdata(L, &nbunny::GameManagerState::REF);
		sol::stack::push(L, state_shared_pointer);
		lua_rawset(L, LUA_REGISTRYINDEX);
	}
	else
	{
		state = sol::stack::get<nbunny::GameManagerState*>(L, -1);
		lua_pop(L, 1);
	}

	auto property = sol::stack::get<nbunny::GameManagerProperty*>(L, 1);
	lua_pushboolean(L, property->update(L, *state));

	return 1;
}

void nbunny::GameManagerProperty::set_field(const std::string& value)
{
	field = value;
}

const std::string& nbunny::GameManagerProperty::get_field() const
{
	return field;
}

void nbunny::GameManagerProperty::set_instance_interface(const std::string& value)
{
	instance_interface = value;
}

const std::string& nbunny::GameManagerProperty::get_instance_interface() const
{
	return instance_interface;
}

void nbunny::GameManagerProperty::set_instance_id(int value)
{
	instance_id = value;
}

int nbunny::GameManagerProperty::get_instance_id() const
{
	return instance_id;
}

bool nbunny::GameManagerProperty::has_value() const
{
	return !is_empty;
}

void nbunny::GameManagerProperty::set_value(const sol::object& value)
{
	current_value = value;
	is_empty = false;
}

sol::object nbunny::GameManagerProperty::get_value() const
{
	return current_value;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_gamemanager_property(lua_State* L)
{
	auto T = (sol::table(nbunny::get_lua_state(L), sol::create)).new_usertype<nbunny::GameManagerProperty>("NProperty",
		sol::call_constructor, sol::constructors<nbunny::GameManagerProperty()>(),
		"update", &nbunny_game_manager_property_update,
		"hasValue", &nbunny::GameManagerProperty::has_value,
		"setField", &nbunny::GameManagerProperty::set_field,
		"getField", &nbunny::GameManagerProperty::get_field,
		"setInstanceInterface", &nbunny::GameManagerProperty::set_instance_interface,
		"getInstanceInterface", &nbunny::GameManagerProperty::get_instance_interface,
		"setInstanceID", &nbunny::GameManagerProperty::set_instance_id,
		"getInstanceID", &nbunny::GameManagerProperty::get_instance_id,
		"setValue", &nbunny::GameManagerProperty::set_value,
		"getValue", &nbunny::GameManagerProperty::get_value);
	sol::stack::push(L, T);

	return 1;
}
