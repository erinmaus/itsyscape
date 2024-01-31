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

static int GAME_MANAGER_REF = 0;

static int nbunny_game_manager_assign(lua_State* L)
{
	lua_pushlightuserdata(L, &GAME_MANAGER_REF);
	lua_pushvalue(L, 1);

	lua_rawset(L, LUA_REGISTRYINDEX);
}

static int nbunny_game_manager_fetch(lua_State* L)
{
	lua_pushlightuserdata(L, &GAME_MANAGER_REF);
	lua_rawget(L, LUA_REGISTRYINDEX);
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_gamemanager(lua_State* L)
{
	lua_newtable(L);

	lua_pushcfunction(&nbunny_game_manager_assign);
	lua_setfield(L, -2, "assign");

	lua_pushcfunction(&nbunny_game_manager_fetch);
	lua_setfield(L, -2, "fetch");

	return 1;
}

nbunny::GameManagerState* nbunny::GameManagerState::get(lua_State* L)
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

	return state;
}

nbunny::GameManagerBuffer::GameManagerBuffer()
{
	// Nothing;
}

nbunny::GameManagerBuffer::GameManagerBuffer(const std::vector<std::uint8_t>& buffer)
	: buffer(buffer)
{
	// Nothing.
}

void nbunny::GameManagerBuffer::read(std::uint8_t* data, std::size_t size)
{
	if (current_offset + size >= length())
	{
		throw std::runtime_error("out of buffer");
	}

	std::memcpy(data, &buffer[current_offset], size);
	current_offset += size;
}

void nbunny::GameManagerBuffer::append(const std::uint8_t* data, std::size_t size)
{
	if (current_offset + size >= length())
	{
		buffer.resize(current_offset + size);
	}

	std::memcpy(&buffer[current_offset], data, size);

	current_offset += size;
}

void nbunny::GameManagerBuffer::seek(std::size_t offset)
{
	if (offset < length())
	{
		current_offset = offset;
	}
}

std::size_t nbunny::GameManagerBuffer::length() const
{
	return buffer.size();
}

nbunny::GameManagerVariant::GameManagerVariant()
{
	// Nothing.
}

nbunny::GameManagerVariant::GameManagerVariant(double v) : type(TYPE_NUMBER)
{
	value.number = v;
}

nbunny::GameManagerVariant::GameManagerVariant(bool v) : type(TYPE_BOOLEAN)
{
	value.boolean = v;
}

nbunny::GameManagerVariant::GameManagerVariant(const std::string& v) : type(TYPE_STRING)
{
	value.string = new std::string(v);
}

nbunny::GameManagerVariant::GameManagerVariant(const GameManagerVariant& other)
{
	*this = other;
}

nbunny::GameManagerVariant::GameManagerVariant(GameManagerVariant&& other)
	: type(other.type)
{
	switch (other.type)
	{
	case TYPE_NIL:
	default:
		// Nothing.
		break;

	case TYPE_NUMBER:
		value.number = other.value.number;
		break;

	case TYPE_BOOLEAN:
		value.boolean = other.value.boolean;
		break;

	case TYPE_STRING:
		value.string = other.value.string;
		other.value.string = nullptr;
		break;

	case TYPE_TABLE:
		value.table = other.value.table;
		other.value.table = nullptr;
		break;

	case TYPE_ARGS:
		value.args = other.value.args;
		other.value.args = nullptr;
		break;
	}

	other.type = TYPE_NIL;
}

nbunny::GameManagerVariant::~GameManagerVariant()
{
	unset();
}

nbunny::GameManagerVariant& nbunny::GameManagerVariant::operator =(const GameManagerVariant& other)
{
	unset();

	type = other.type;
	switch (other.type)
	{
	case TYPE_NIL:
	default:
		// Nothing.
		break;

	case TYPE_NUMBER:
		value.number = other.value.number;
		break;

	case TYPE_BOOLEAN:
		value.boolean = other.value.boolean;
		break;

	case TYPE_STRING:
		value.string = new std::string(*other.value.string);
		break;

	case TYPE_TABLE:
		value.table = new Table();
		value.table->array_values = other.value.table->array_values;
		value.table->key_values = other.value.table->key_values;
		break;

	case TYPE_ARGS:
		value.args = new Args();
		value.args->parameter_values = other.value.args->parameter_values;
		break;
	}

	return *this;
}

void nbunny::GameManagerVariant::from_lua(lua_State* L, int index, int count)
{
	if (index < 0)
	{
		index += lua_gettop(L) + 1;
	}

	if (count >= 0)
	{
		to_args(count);

		for (int i = 0; i < count; ++i)
		{
			GameManagerVariant v;
			v.from_lua(L, index + i);

			value.args->parameter_values.emplace_back(std::move(v));
		}
	}
	else
	{
		std::set<const void*> e;
		from_lua(L, index, e);
	}
}

int nbunny::GameManagerVariant::to_lua(lua_State* L) const
{
	switch (type)
	{
		case TYPE_NIL:
		default:
			lua_pushnil(L);
			return 1;
		case TYPE_NUMBER:
			lua_pushnumber(L, value.number);
			return 1;
		case TYPE_BOOLEAN:
			lua_pushboolean(L, value.boolean);
			return 1;
		case TYPE_STRING:
			lua_pushlstring(L, value.string->data(), value.string->size());
			return 1;
		case TYPE_TABLE:
			// todo only fully deserialize __persist
			{
				if (get("__persist").type != TYPE_NIL)
				{
					auto state = GameManagerState::get(L);
					if (!state->to_lua(L, *this))
					{
						auto typeName = get("typeName");
						if (typeName.type == TYPE_STRING)
						{
							luaL_error(L, "could not marshal persisted type: %s", typeName.to_string().c_str());
						}
						else
						{
							luaL_error(L, "could not marshal malformed type");
						}
					}
				}
				else
				{
					lua_createtable(L, value.table->array_values.size(), value.table->key_values.size());

					for (std::size_t i = 0; i < value.table->array_values.size(); ++i)
					{
						value.table->array_values.at(i).to_lua(L);
						lua_rawseti(L, -2, i + 1);
					}

					for (auto& key_value: value.table->key_values)
					{
						key_value.first.to_lua(L);
						key_value.second.to_lua(L);

						lua_rawset(L, -3);
					}
				}
			}
			return 1;
	}
}

int nbunny::GameManagerVariant::get_type() const
{
	return type;
}

double nbunny::GameManagerVariant::as_number() const
{
	if (type != TYPE_NUMBER)
	{
		throw std::runtime_error("not a number");
	}

	return value.number;
}

bool nbunny::GameManagerVariant::as_boolean() const
{
	if (type != TYPE_BOOLEAN)
	{
		throw std::runtime_error("not a boolean");
	}

	return value.boolean;
}

std::string nbunny::GameManagerVariant::as_string() const
{
	if (type != TYPE_STRING)
	{
		throw std::runtime_error("not a string");
	}

	return *value.string;
}

nbunny::GameManagerVariant nbunny::GameManagerVariant::get(const GameManagerVariant& key) const
{
	if (type != TYPE_TABLE)
	{
		throw std::runtime_error("not a table");
	}

	if (key.type == TYPE_NUMBER && key.as_number() >= 1 and key.as_number() <= length())
	{
		return value.table->array_values.at(key.as_number() - 1);
	}

	auto result = std::find_if(
		value.table->key_values.begin(),
		value.table->key_values.end(),
		[&](auto& key_value) { return key_value.first == key; });

	if (result == value.table->key_values.end())
	{
		return GameManagerVariant();
	}

	return result->second;
}

nbunny::GameManagerVariant nbunny::GameManagerVariant::get(std::size_t index) const
{
	if (type != TYPE_TABLE || type != TYPE_ARGS)
	{
		throw std::runtime_error("not table or args");
	}

	if (type == TYPE_TABLE)
	{
		return get(GameManagerVariant((double)index + 1));
	}
	else
	{
		return value.args->parameter_values.at(index);
	}
}

void nbunny::GameManagerVariant::set(const GameManagerVariant& key, const GameManagerVariant& v)
{
	if (type != TYPE_TABLE)
	{
		throw std::runtime_error("not a table");
	}

	if (key.type == TYPE_NUMBER && key.as_number() >= 1 and key.as_number() <= length())
	{
		value.table->array_values.at(key.as_number() - 1) = v;
	}

	auto result = std::find_if(
		value.table->key_values.begin(),
		value.table->key_values.end(),
		[&](auto& key_value) { return key_value.first == key; });

	if (result == value.table->key_values.end())
	{
		value.table->key_values.emplace_back(key, v);
	}
	else
	{
		result->second = v;
	}
}

int nbunny::GameManagerVariant::length() const
{
	if (type == TYPE_TABLE)
	{
		return value.table->array_values.size();
	}
	else if (type == TYPE_ARGS)
	{
		return value.args->parameter_values.size();
	}

	return 0;
}

void nbunny::GameManagerVariant::to_nil()
{
	unset();
}

void nbunny::GameManagerVariant::to_number(double v)
{
	unset();

	type = TYPE_NUMBER;
	value.number = v;
}

void nbunny::GameManagerVariant::to_boolean(bool v)
{
	unset();

	type = TYPE_BOOLEAN;
	value.boolean = v;
}

void nbunny::GameManagerVariant::to_string(const std::string& v)
{
	unset();

	type = TYPE_STRING;
	value.string = new std::string(v);
}

void nbunny::GameManagerVariant::to_table()
{
	unset();

	type = TYPE_TABLE;
	value.table = new Table();
}

void nbunny::GameManagerVariant::to_args(std::size_t count)
{
	unset();

	type = TYPE_ARGS;
	value.args = new Args();
	value.args->parameter_values.resize(count);
}

bool nbunny::GameManagerVariant::operator ==(const GameManagerVariant& other) const
{
	if (type != other.type)
	{
		return false;
	}

	if (type == TYPE_NIL)
	{
		return true;
	}
	else if (type == TYPE_NUMBER)
	{
		return value.number == other.value.number;
	}
	else if (type == TYPE_BOOLEAN)
	{
		return value.boolean == other.value.boolean;
	}
	else if (type == TYPE_STRING)
	{
		return *value.string == *other.value.string;
	}
	else if (type == TYPE_TABLE)
	{
		return value.table->array_values == other.value.table->array_values &&
		       value.table->key_values == other.value.table->key_values;
	}
	else if (type == TYPE_TABLE)
	{
		return value.args->parameter_values == other.value.args->parameter_values;
	}

	return true;
}

bool nbunny::GameManagerVariant::operator !=(const GameManagerVariant& other) const
{
	return !(*this == other);
}

void nbunny::GameManagerVariant::serialize(GameManagerBuffer& buffer)
{
	buffer.seek(0);

	buffer.append(type);
	switch (type)
	{
	case TYPE_NIL:
	default:
		break;
	case TYPE_NUMBER:
		buffer.append(value.number);
		break;
	case TYPE_BOOLEAN:
		buffer.append(value.boolean);
		break;
	case TYPE_STRING:
		buffer.append(value.string->size());
		buffer.append((const std::uint8_t*)value.string->data(), value.string->size());
		break;
	case TYPE_TABLE:
		buffer.append(value.table->array_values.size());
		for (auto& i: value.table->array_values)
		{
			i.serialize(buffer);
		}

		buffer.append(value.table->key_values.size());
		for (auto& i: value.table->key_values)
		{
			i.first.serialize(buffer);
			i.second.serialize(buffer);
		}
		break;
	case TYPE_ARGS:
		buffer.append(value.args->parameter_values.size());
		for (auto& i: value.args->parameter_values)
		{
			i.serialize(buffer);
		}
		break;
	}
}

void nbunny::GameManagerVariant::deserialize(GameManagerBuffer& buffer)
{
	unset();

	buffer.read(type);
	switch(type)
	{
	case TYPE_NIL:
	default:
		break;
	case TYPE_NUMBER:
		buffer.read(value.number);
		break;
	case TYPE_BOOLEAN:
		buffer.read(value.boolean);
		break;
	case TYPE_STRING:
		{
			std::size_t size;
			buffer.read(size);

			value.string = new std::string(size, 0);
			buffer.read((std::uint8_t*)&value.string->front(), size);
		}
		break;
	case TYPE_TABLE:
		{
			to_table();

			std::size_t array_size;
			buffer.read(array_size);

			for (std::size_t i = 0; i < array_size; ++i)
			{
				GameManagerVariant v;
				v.deserialize(buffer);

				value.table->array_values.emplace_back(std::move(v));
			}

			std::size_t keys_size;
			buffer.read(keys_size);

			for (std::size_t i = 0; i < keys_size; ++i)
			{
				GameManagerVariant k;
				k.deserialize(buffer);

				GameManagerVariant v;
				v.deserialize(buffer);

				value.table->key_values.emplace_back(std::move(k), std::move(v));
			}
		}
		break;
	case TYPE_ARGS:
		{
			std::size_t size;
			buffer.read(size);

			to_args(size);

			for (std::size_t i = 0; i < size; ++i)
			{
				GameManagerVariant v;
				v.deserialize(buffer);

				value.args->parameter_values.emplace_back(std::move(v));
			}
		}
		break;
	}
}

void nbunny::GameManagerVariant::unset()
{
	switch (type)
	{
		case TYPE_NIL:
		case TYPE_NUMBER:
		case TYPE_BOOLEAN:
		default:
			// Nothing.
			break;

		case TYPE_STRING:
			if (value.string)
			{
				delete value.string;
				value.string = nullptr;
			}
			break;

		case TYPE_TABLE:
			if (value.table)
			{
				delete value.table;
				value.table = nullptr;
			}
			break;

		case TYPE_ARGS:
			if (value.args)
			{
				delete value.args;
				value.args = nullptr;
			}
			break;
	}

	type = TYPE_NIL;
}

void nbunny::GameManagerVariant::from_lua(lua_State* L, int index, std::set<const void*>& e)
{
	if (index < 0)
	{
		index += lua_gettop(L) + 1;
	}

	switch(lua_type(L, index))
	{
	case LUA_TNIL:
		to_nil();
		break;
	case LUA_TNUMBER:
		to_number(lua_tonumber(L, index));
		break;
	case LUA_TBOOLEAN:
		to_boolean(lua_toboolean(L, index));
		break;
	case LUA_TSTRING:
		to_string(lua_tostring(L, index));
		break;
	case LUA_TTABLE:
		{
			to_table();

			if (lua_getmetatable(L, index))
			{
				auto state = GameManagerState::get(L);
				state->from_lua(L, index, *this);
			}
			else
			{
				auto pointer = lua_topointer(L, index);
				auto has_table = e.insert(pointer);
				if (!has_table.second)
				{
					luaL_error(L, "cycle detected in table");
				}

				auto array_length = lua_objlen(L, index);
				value.table->array_values.reserve(array_length);

				for (std::size_t i = 1; i <= array_length; ++i)
				{
					lua_rawgeti(L, index, 1);

					GameManagerVariant v;
					v.from_lua(L, -1, e);

					value.table->array_values.emplace_back(std::move(v));
					lua_pop(L, 1);
				}

				lua_pushnil(L);
				while (lua_next(L, index))
				{
					if (lua_isnumber(L, index))
					{
						int i = lua_tonumber(L, index);
						if (i >= 1 && i <= value.table->array_values.size())
						{
							lua_pop(L, 1);
							continue;
						}
					}

					GameManagerVariant k;
					k.from_lua(L, -2, e);

					GameManagerVariant v;
					v.from_lua(L, -1, e);

					value.table->key_values.emplace_back(std::move(k), std::move(v));

					lua_pop(L, 1);
				}

				e.erase(pointer);
			}
		}
	default:
		luaL_error(L, "unexpected or unhandled type '%s' when serializing Lua data", lua_typename(L, lua_type(L, index)));
		break;
	}
}

void nbunny::TypeProvider::connect(GameManagerState& state, const sol::table& type)
{
	this->state = &state;
	this->type = type;
}

nbunny::GameManagerState& nbunny::TypeProvider::get_state() const
{
	if (!state)
	{
		throw std::runtime_error("not yet assigned");
	}

	return *state;
}

const sol::table& nbunny::TypeProvider::get_persisted_type_name() const
{
	if (!state)
	{
		throw std::runtime_error("not yet assigned");
	}

	return persisted_type_name;
}

const sol::table& nbunny::TypeProvider::get_type() const
{
	if (!state)
	{
		throw std::runtime_error("not yet assigned");
	}

	return type;
}

void nbunny::TypeProvider::push_type(lua_State* L)
{
	if (!state)
	{
		throw std::runtime_error("not yet assigned");
	}

	sol::stack::push(L, type);
}

void nbunny::QuaternionTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	lua_pushnumber(v.get("x").to_number());
	lua_pushnumber(v.get("y").to_number());
	lua_pushnumber(v.get("z").to_number());
	lua_pushnumber(v.get("w").to_number());

	if (lua_pcall(L, 4, 1, 0))
	{
		lua_error(L);
	}
}

void nbunny::QuaternionTypeProvider::serialize(lua_State* L, GameManagerVariant& value)
{
	lua_getfield(L, -1, "x");
	auto x = luaL_checknumber(L, -1);

	lua_getfield(L, -2, "y");
	auto y = luaL_checknumber(L, -1);

	lua_getfield(L, -3, "z");
	auto z = luaL_checknumber(L, -1);

	lua_getfield(L, -4, "w");
	auto w = luaL_checknumber(L, -1);

	value.set("x", x);
	value.set("y", y);
	value.set("z", z);
	value.set("w", w);
}

void nbunny::VectorTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	lua_pushnumber(v.get("x").to_number());
	lua_pushnumber(v.get("y").to_number());
	lua_pushnumber(v.get("z").to_number());

	if (lua_pcall(L, 4, 1, 0))
	{
		lua_error(L);
	}
}

void nbunny::VectorTypeProvider::serialize(lua_State* L, GameManagerVariant& value)
{
	lua_getfield(L, -1, "x");
	auto x = luaL_checknumber(L, -1);

	lua_getfield(L, -2, "y");
	auto y = luaL_checknumber(L, -1);

	lua_getfield(L, -3, "z");
	auto z = luaL_checknumber(L, -1);;

	lua_pop(L, 3);

	value.set("x", x);
	value.set("y", y);
	value.set("z", z);
}

void nbunny::RayTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	value.get("origin").to_lua(L);
	value.get("direction").to_lua(L);

	if (lua_pcall(L, 2, 1, 0))
	{
		lua_error(L);
	}
}

void nbunny::RayTypeProvider::serialize(lua_State* L, GameManagerVariant& value)
{
	lua_getfield(L, -1, "origin");

	GameManagerVariant origin;
	value.from_lua(L, -1);

	lua_getfield(L, -1, "direction");

	GameManagerVariant direction;
	direction.from_lua(L, -1);

	lua_pop(L, 2);

	value.set("origin", origin);
	value.set("direction", direction);
}

void nbunny::CacheRefTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	lua_pushstring(v.get("resourceTypeID").to_string().c_str());
	lua_pushstring(v.get("filename").to_string().c_str());

	if (lua_pcall(L, 4, 1, 0))
	{
		lua_error(L);
	}
}

void nbunny::CacheRefTypeProvider::serialize(lua_State* L, GameManagerVariant& value)
{
	lua_getfield(L, -1, "filename");
	std::string filename = luaL_checkstring(L, -1);

	lua_getfield(L, -2, "resourceTypeID");
	std::string type = luaL_checkstring(L, -1);

	lua_pop(L, 2);

	value.set("filename", filename);
	value.set("type", type);
}

void nbunny::PlayerStorageTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);
	if (lua_pcall(L, 0, 1, 0))
	{
		lua_error(L);
	}

	lua_pushvalue(L, -1);
	lua_pushstring(L, v.get("storage").to_string().c_str());
	lua_getfield(L, -3, "deserialize");

	if (lua_pcall(L, 2, 0, 0))
	{
		lua_error(L);
	}
}

void nbunny::PlayerStorageTypeProvider::serialize(lua_State* L, GameManagerVariant& value)
{
	lua_getfield(L, -1, "serialize");
	lua_pushvalue(L, -2);

	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	std::string type = luaL_checkstring(L, -1);

	lua_pop(L, 1);

	value.set("storage", storage);
}

void nbunny::ColorTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	lua_pushnumber(v.get("r").to_number());
	lua_pushnumber(v.get("g").to_number());
	lua_pushnumber(v.get("b").to_number());
	lua_pushnumber(v.get("a").to_number());

	if (lua_pcall(L, 4, 1, 0))
	{
		lua_error(L);
	}
}

void nbunny::ColorTypeProvider::serialize(lua_State* L, GameManagerVariant& value)
{
	lua_getfield(L, -1, "r");
	auto x = luaL_checknumber(L, -1);

	lua_getfield(L, -2, "g");
	auto y = luaL_checknumber(L, -1);

	lua_getfield(L, -3, "b");
	auto z = luaL_checknumber(L, -1);

	lua_getfield(L, -4, "a");
	auto w = luaL_checknumber(L, -1);

	value.set("r", x);
	value.set("g", y);
	value.set("b", z);
	value.set("a", w);
}

void nbunny::DecorationTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	lua_pushstring(L, v.get("decoration").to_string().c_str());

	push_type(L);
	if (lua_pcall(L, 0, 1, 0))
	{
		lua_error(L);
	}
}

void nbunny::DecorationTypeProvider::serialize(lua_State* L, GameManagerVariant& value)
{
	lua_getfield(L, -1, "serialize");
	lua_pushvalue(L, -2);

	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	std::string type = luaL_checkstring(L, -1);

	lua_pop(L, 1);

	value.set("decoration", decoration);
}

void nbunny::MapTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	lua_pushtype(L);

	value.get("map").to_lua(L);
	lua_getfield(L, -2, "loadFromTable");

	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	lua_remove(L, -2);
}

void nbunny::MapTypeProvider::serialize(lua_State* L, GameManagerVariant& value)
{
	lua_getfield(L, -1, "serialize");
	lua_pushvalue(L, -2);

	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	GameManagerVariant map;
	map.from_lua(L, -1);

	lua_pop(L, 1);

	value.set("map", map);
}

void nbunny::InstanceTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	nbunny_game_manager_fetch(L);
	lua_getfield(L, -1, "getInstance");

	lua_pushvalue(L, -2);

	lua_pushstring(L, get_persisted_type_name().c_str());
	lua_pushnumber(L, v.get("id").to_number());

	if (lua_pcall(L, 3, 1, 0))
	{
		lua_error(L);
	}

	lua_remove(L, -2);
}

void nbunny::InstanceTypeProvider::serialize(lua_State* L, GameManagerVariant& value)
{
	lua_getfield(L, -1, "id");
	auto id = luaL_optinteger(L, -1, 0);

	lua_pop(L, 1);

	value.set("id", id);
}

int nbunny::GameManagerState::REF = 0;

bool nbunny::GameManagerState::from_lua(lua_State* L, int index, GameManagerVariant& value)
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

	if (type_provider == type_providers.end())
	{
		return false;
	}

	value.to_table();
	type_provider->second->serialize(L, value);

	value.set("__persist", true);
	value.set("typeName", persisted_type_provider_names.find(type_provider->second.get())->second);

	return true;
}

bool nbunny::GameManagerState::to_lua(lua_State* L, const GameManagerVariant& value)
{
	auto type_name = value.get("typeName").to_string();

	auto type_provider = std::find_if(
		persisted_type_provider_names.begin(),
		persisted_type_provider_names.end(),
		[&](auto& pair) { return pair.second == type_name; }
	);

	if (type_provider == persisted_type_provider_names.end())
	{
		return false;
	}

	type_provider->first->deserialize(L, value);
	return true;
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
	connect<RayTypeProvider>(
		L,
		"ItsyScape.Common.Math.Ray",
		"ItsyScape.Common.Math.Ray");
	connect<CacheRefTypeProvider>(
		L,
		"ItsyScape.Game.CacheRef",
		"ItsyScape.Game.CacheRef");
	connect<PlayerStorageTypeProvider>(
		L,
		"ItsyScape.Game.PlayerStorage",
		"ItsyScape.Game.PlayerStorage");
	connect<ColorTypeProvider>(
		L,
		"ItsyScape.Graphics.Color",
		"ItsyScape.Graphics.Color");
	connect<DecorationTypeProvider>(
		L,
		"ItsyScape.Graphics.Decoration",
		"ItsyScape.Graphics.Decoration");
	connect<MapTypeProvider>(
		L,
		"ItsyScape.World.Map",
		"ItsyScape.World.Map");
	connect<TileTypeProvider>(
		L,
		"ItsyScape.World.Tile",
		"ItsyScape.World.Tile");
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

	alias("ItsyScape.Game.Model.Game", "ItsyScape.Game.RemoteModel.Game");
	alias("ItsyScape.Game.Model.Stage", "ItsyScape.Game.RemoteModel.Stage");
	alias("ItsyScape.Game.Model.Player", "ItsyScape.Game.RemoteModel.Player");
	alias("ItsyScape.Game.Model.Actor", "ItsyScape.Game.RemoteModel.Actor");
	alias("ItsyScape.Game.Model.Prop", "ItsyScape.Game.RemoteModel.Prop");
	alias("ItsyScape.Game.Model.UI", "ItsyScape.Game.RemoteModel.UI");
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

static int nbunny_game_manager_property_new(lua_State* L)
{
	auto property = std::make_shared<GameManagerProperty>(luaL_ref(L, 1));
	sol::stack::push(L, property);
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
	
	bool is_dirty = was_empty || !state.deep_equals(L, previous_value, current_value);
	return is_dirty;
}

nbunny::GameManagerState* nbunny::GameManagerState::get(lua_State* L)
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

	return state;
}

static int nbunny_game_manager_property_update(lua_State* L)
{
	auto state = nbunny::GameManagerState::get(L);
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

static int nbunny_game_manager_property_set_value(lua_State* L)
{

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
