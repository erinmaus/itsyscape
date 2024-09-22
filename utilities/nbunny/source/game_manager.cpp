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

static int GAME_MANAGER_REF = 0;

static int nbunny_game_manager_assign(lua_State* L)
{
	lua_pushlightuserdata(L, &GAME_MANAGER_REF);
	lua_pushvalue(L, 1);

	lua_rawset(L, LUA_REGISTRYINDEX);

	return 0;
}

static int nbunny_game_manager_fetch(lua_State* L)
{
	lua_pushlightuserdata(L, &GAME_MANAGER_REF);
	lua_rawget(L, LUA_REGISTRYINDEX);

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_gamemanager(lua_State* L)
{
	lua_newtable(L);

	lua_pushcfunction(L, &nbunny_game_manager_assign);
	lua_setfield(L, -2, "assign");

	lua_pushcfunction(L, &nbunny_game_manager_fetch);
	lua_setfield(L, -2, "fetch");

	return 1;
}

nbunny::GameManagerBuffer::GameManagerBuffer()
{
	buffer.reserve(4096);
}

nbunny::GameManagerBuffer::GameManagerBuffer(const std::vector<std::uint8_t>& buffer)
	: buffer(buffer)
{
	this->buffer.reserve(4096);
}

void nbunny::GameManagerBuffer::read(std::uint8_t* data, std::size_t size)
{
	if (current_offset + size > length())
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

std::size_t nbunny::GameManagerBuffer::tell() const
{
	return current_offset;
}

std::size_t nbunny::GameManagerBuffer::length() const
{
	return buffer.size();
}

void* nbunny::GameManagerBuffer::get_pointer()
{
	return &buffer[0];
}

void nbunny::GameManagerBuffer::compress()
{
	auto result = love::data::compress(love::data::Compressor::FORMAT_LZ4, (const char*)&buffer[0], buffer.size(), 9);

	current_offset = 0;
	buffer.resize(0);

	append((const std::uint8_t*)result->getData(), result->getSize());

	result->release();
}

void nbunny::GameManagerBuffer::decompress()
{
	std::size_t new_size;
	auto result = love::data::decompress(love::data::Compressor::FORMAT_LZ4, (const char*)&buffer[0], buffer.size(), new_size);

	current_offset = 0;
	buffer.resize(0);

	append((const std::uint8_t*)result, new_size);

	delete[] result;
}

static int nbunny_game_manager_buffer_create(lua_State* L)
{
	if (lua_isstring(L, 1))
	{
		std::size_t length;
		auto data = lua_tolstring(L, 1, &length);

		nbunny::GameManagerBuffer* buffer = new nbunny::GameManagerBuffer();
		buffer->append((const std::uint8_t*)data, length);

		lua_pushlightuserdata(L, buffer);
	}
	else
	{
		nbunny::GameManagerVariant* variant = nbunny::lua::get<nbunny::GameManagerVariant*>(L, 1);
		nbunny::GameManagerBuffer* buffer = new nbunny::GameManagerBuffer();

		variant->serialize(*buffer);

		lua_pushlightuserdata(L, buffer);
	}

	return 1;
}

static int nbunny_game_manager_buffer_compress(lua_State* L)
{
	if (lua_islightuserdata(L, 1))
	{
		auto buffer = (nbunny::GameManagerBuffer*)lua_touserdata(L, 1);
		buffer->compress();
	}

	return 0;
}

static int nbunny_game_manager_buffer_decompress(lua_State* L)
{
	if (lua_islightuserdata(L, 1))
	{
		auto buffer = (nbunny::GameManagerBuffer*)lua_touserdata(L, 1);
		buffer->decompress();
	}

	return 0;
}

static int nbunny_game_manager_buffer_free(lua_State* L)
{
	if (lua_islightuserdata(L, 1))
	{
		auto buffer = (nbunny::GameManagerBuffer*)lua_touserdata(L, 1);
		delete buffer;
	}

	return 0;
}

static int nbunny_game_manager_buffer_length(lua_State* L)
{
	if (lua_islightuserdata(L, 1))
	{
		auto buffer = (nbunny::GameManagerBuffer*)lua_touserdata(L, 1);

		lua_pushnumber(L, buffer->length());
		return 1;
	}

	return 0;
}

static int nbunny_game_manager_buffer_pointer(lua_State* L)
{
	if (lua_islightuserdata(L, 1))
	{
		auto buffer = (nbunny::GameManagerBuffer*)lua_touserdata(L, 1);

		lua_pushlightuserdata(L, buffer->get_pointer());
		return 1;
	}

	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_gamemanager_buffer(lua_State* L)
{
	lua_newtable(L);

	lua_pushcfunction(L, &nbunny_game_manager_buffer_create);
	lua_setfield(L, -2, "create");

	lua_pushcfunction(L, &nbunny_game_manager_buffer_free);
	lua_setfield(L, -2, "free");

	lua_pushcfunction(L, &nbunny_game_manager_buffer_length);
	lua_setfield(L, -2, "length");

	lua_pushcfunction(L, &nbunny_game_manager_buffer_pointer);
	lua_setfield(L, -2, "pointer");

	lua_pushcfunction(L, &nbunny_game_manager_buffer_compress);
	lua_setfield(L, -2, "compress");

	lua_pushcfunction(L, &nbunny_game_manager_buffer_decompress);
	lua_setfield(L, -2, "decompress");

	return 1;
}

nbunny::GameManagerVariant::GameManagerVariant()
{
	std::memset(&value, 0, sizeof(value));
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

nbunny::GameManagerVariant::GameManagerVariant(const char* v) : type(TYPE_STRING)
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

		for (int i = index; i <= count; ++i)
		{
			GameManagerVariant v;
			v.from_lua(L, i);

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
			{
				if (get("__persist").type != TYPE_NIL)
				{
					auto state = GameManagerState::get(L);
					if (!state->to_lua(L, *this))
					{
						auto typeName = get("typeName");
						if (typeName.type == TYPE_STRING)
						{
							luaL_error(L, "could not marshal persisted type: %s", typeName.as_string().c_str());
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
		case TYPE_ARGS:
			for (std::size_t i = 0; i < value.args->parameter_values.size(); ++i)
			{
				value.args->parameter_values.at(i).to_lua(L);
			}

			return value.args->parameter_values.size();
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
	if (type != TYPE_TABLE && type != TYPE_ARGS)
	{
		throw std::runtime_error("not a table or args");
	}

	if (type == TYPE_ARGS && key.type == TYPE_NUMBER)
	{
		if (key.as_number() >= 1 and key.as_number() <= length())
		{
			return value.args->parameter_values.at(key.as_number() - 1);
		}

		throw std::runtime_error("index into args out-of-bounds");
	}

	if (key.type == TYPE_NUMBER && key.as_number() >= 1 && key.as_number() <= length())
	{
		return value.table->array_values.at(key.as_number() - 1);
	}

	auto result = std::lower_bound(
		value.table->key_values.begin(),
		value.table->key_values.end(),
		key,
		[](auto& i, auto& search) { return less(search, i.first); }
	);

	if (result == value.table->key_values.end() || result->first != key)
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

	if (key.type == TYPE_NUMBER && key.as_number() >= 1 && key.as_number() <= length())
	{
		value.table->array_values.at(key.as_number() - 1) = v;
	}

	auto result = std::find_if(
		value.table->key_values.begin(),
		value.table->key_values.end(),
		[&](auto& key_value) { return key_value.first == key; });

	if (result == value.table->key_values.end())
	{
		auto upper_bound = std::upper_bound(
			value.table->key_values.begin(),
			value.table->key_values.end(),
			key,
			[](auto& search, auto& i) { return less(i.first, search); }
		);

		if (upper_bound != value.table->key_values.end())
		{
			value.table->key_values.insert(upper_bound, std::make_pair(key, v));
		}
		else
		{
			value.table->key_values.emplace_back(std::make_pair(key, v));
		}
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
	value.table->key_values.reserve(64);
	value.table->array_values.reserve(64);
}

void nbunny::GameManagerVariant::to_args(std::size_t count)
{
	unset();

	type = TYPE_ARGS;
	value.args = new Args();
	value.args->parameter_values.reserve(count);
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
	else if (type == TYPE_ARGS)
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

			value.table->array_values.reserve(array_size);
			for (std::size_t i = 0; i < array_size; ++i)
			{
				GameManagerVariant v;
				v.deserialize(buffer);

				value.table->array_values.emplace_back(std::move(v));
			}

			std::size_t keys_size;
			buffer.read(keys_size);

			value.table->key_values.reserve(keys_size);
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

bool nbunny::GameManagerVariant::less(const GameManagerVariant& search_key, const GameManagerVariant& current_key)
{
	if (search_key.type != current_key.type)
	{
		return search_key.type < current_key.type;
	}
	else
	{
		switch(search_key.type)
		{
		case TYPE_NIL:
		default:
			return false;
		case TYPE_NUMBER:
			return search_key.value.number < current_key.value.number;
		case TYPE_BOOLEAN:
			return search_key.value.boolean < current_key.value.boolean;
		case TYPE_STRING:
			return *search_key.value.string < *current_key.value.string;
		case TYPE_TABLE:
			if (search_key.value.table->array_values.size() != current_key.value.table->array_values.size())
			{
				return search_key.value.table->array_values.size() < current_key.value.table->array_values.size();
			}
			else if (search_key.value.table->key_values.size() != current_key.value.table->key_values.size())
			{
				return search_key.value.table->key_values.size() < current_key.value.table->key_values.size();
			}
			else
			{
				for (std::size_t i = 0; i < search_key.value.table->array_values.size(); ++i)
				{
					auto& array_left = search_key.value.table->array_values.at(i);
					auto& array_right = current_key.value.table->array_values.at(i);
					if (array_left != array_right)
					{
						return less(array_left, array_right);
					}
				}

				for (std::size_t i = 0; i < search_key.value.table->key_values.size(); ++i)
				{
					auto& key_left = search_key.value.table->key_values.at(i);
					auto& key_right = current_key.value.table->key_values.at(i);
					if (key_left != key_right)
					{
						return less(key_left.first, key_right.first);
					}
				}
			}

			return false;
		case TYPE_ARGS:
			if (search_key.value.args->parameter_values.size() != current_key.value.args->parameter_values.size())
			{
				return search_key.value.args->parameter_values.size() < current_key.value.args->parameter_values.size();
			}
			else
			{
				for (std::size_t i = 0; i < search_key.value.args->parameter_values.size(); ++i)
				{
					auto& parameter_left = search_key.value.args->parameter_values.at(i);
					auto& parameter_right = current_key.value.args->parameter_values.at(i);
					if (parameter_left != parameter_right)
					{
						return less(parameter_left, parameter_right);
					}
				}
			}

			return false;
		}
	}
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
					lua_rawgeti(L, index, i);

					GameManagerVariant v;
					v.from_lua(L, -1, e);

					value.table->array_values.emplace_back(std::move(v));
					lua_pop(L, 1);
				}

				lua_pushnil(L);
				while (lua_next(L, index))
				{
					if (lua_isnumber(L, -2))
					{
						int i = lua_tonumber(L, -2);
						if (i >= 1 && i <= value.table->array_values.size() && value.table->array_values.at(i - 1).type != TYPE_NIL)
						{
							lua_pop(L, 1);
							continue;
						}
					}

					GameManagerVariant k;
					k.from_lua(L, -2, e);

					GameManagerVariant v;
					v.from_lua(L, -1, e);

					set(k, v);

					lua_pop(L, 1);
				}

				e.erase(pointer);
			}
		}
		break;
	default:
		luaL_error(L, "unexpected or unhandled type '%s' when serializing Lua data", lua_typename(L, lua_type(L, index)));
		break;
	}
}

static int nbunny_game_manager_variant_create(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::GameManagerVariant>());
	return 1;
}

static int nbunny_game_manager_variant_rawget(lua_State* L)
{
	nbunny::GameManagerVariant* variant = nbunny::lua::get<nbunny::GameManagerVariant*>(L, 1);

	nbunny::GameManagerVariant key;
	key.from_lua(L, 2);

	nbunny::lua::push(L, std::make_shared<nbunny::GameManagerVariant>(variant->get(key)));

	return 1;
}

static int nbunny_game_manager_variant_index(lua_State* L)
{
	nbunny::GameManagerVariant* variant = nbunny::lua::get<nbunny::GameManagerVariant*>(L, 1);

	if (lua_gettop(L) == 1)
	{
		return variant->to_lua(L);
	}

	nbunny::GameManagerVariant key;
	key.from_lua(L, 2);

	lua_getmetatable(L, 1);
	lua_pushvalue(L, 2);
	lua_gettable(L, -2);

	lua_remove(L, -2);
	if (lua_isnil(L, -1))
	{
		lua_pop(L, 1);
		return variant->get(key).to_lua(L);
	}
	else
	{
		return 1;
	}
}

static int nbunny_game_manager_variant_newindex(lua_State* L)
{
	nbunny::GameManagerVariant* variant = nbunny::lua::get<nbunny::GameManagerVariant*>(L, 1);

	nbunny::GameManagerVariant key;
	key.from_lua(L, 2);

	nbunny::GameManagerVariant value;
	value.from_lua(L, 3);

	variant->set(key, value);

	return 0;
}

static int nbunny_game_manager_variant_from_args(lua_State* L)
{
	auto variant = nbunny::lua::get<nbunny::GameManagerVariant*>(L, 1);
	variant->from_lua(L, 2, lua_gettop(L));

	lua_pushvalue(L, 1);
	return 1;
}

static int nbunny_game_manager_variant_length(lua_State* L)
{
	auto variant = nbunny::lua::get<nbunny::GameManagerVariant*>(L, 1);
	nbunny::lua::push(L, variant->length());
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_gamemanager_variant(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "__index", &nbunny_game_manager_variant_index },
		{ "__newindex", &nbunny_game_manager_variant_newindex },
		{ "__len", &nbunny_game_manager_variant_length },
		{ "get", &nbunny_game_manager_variant_index },
		{ "rawget", &nbunny_game_manager_variant_rawget },
		{ "fromArguments", &nbunny_game_manager_variant_from_args },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_type<nbunny::GameManagerVariant>(L, &nbunny_game_manager_variant_create, metatable);

	return 1;
}

void nbunny::TypeProvider::connect(GameManagerState& state, const std::string& persisted_type_name, int type)
{
	this->state = &state;
	this->persisted_type_name = persisted_type_name;
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

const std::string& nbunny::TypeProvider::get_persisted_type_name() const
{
	if (!state)
	{
		throw std::runtime_error("not yet assigned");
	}

	return persisted_type_name;
}

int nbunny::TypeProvider::get_type() const
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

	get_weak_reference(L, type);
}

void nbunny::QuaternionTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	lua_pushnumber(L, value.get("x").as_number());
	lua_pushnumber(L, value.get("y").as_number());
	lua_pushnumber(L, value.get("z").as_number());
	lua_pushnumber(L, value.get("w").as_number());

	if (lua_pcall(L, 4, 1, 0))
	{
		lua_error(L);
	}

	lua_getfield(L, -1, "keep");
	lua_pushvalue(L, -2);
	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	lua_remove(L, -2);
}

void nbunny::QuaternionTypeProvider::serialize(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, index, "x");
	auto x = luaL_checknumber(L, -1);

	lua_getfield(L, index, "y");
	auto y = luaL_checknumber(L, -1);

	lua_getfield(L, index, "z");
	auto z = luaL_checknumber(L, -1);

	lua_getfield(L, index, "w");
	auto w = luaL_checknumber(L, -1);

	value.set("x", x);
	value.set("y", y);
	value.set("z", z);
	value.set("w", w);
}

void nbunny::VectorTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	lua_pushnumber(L, value.get("x").as_number());
	lua_pushnumber(L, value.get("y").as_number());
	lua_pushnumber(L, value.get("z").as_number());

	if (lua_pcall(L, 3, 1, 0))
	{
		lua_error(L);
	}

	lua_getfield(L, -1, "keep");
	lua_pushvalue(L, -2);
	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	lua_remove(L, -2);
}

void nbunny::VectorTypeProvider::serialize(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, index, "x");
	auto x = luaL_checknumber(L, -1);

	lua_getfield(L, index, "y");
	auto y = luaL_checknumber(L, -1);

	lua_getfield(L, index, "z");
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

	lua_getfield(L, -1, "keep");
	lua_pushvalue(L, -2);
	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	lua_remove(L, -2);
}

void nbunny::RayTypeProvider::serialize(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, index, "origin");

	GameManagerVariant origin;
	value.from_lua(L, -1);

	lua_getfield(L, index, "direction");

	GameManagerVariant direction;
	direction.from_lua(L, -1);

	lua_pop(L, 2);

	value.set("origin", origin);
	value.set("direction", direction);
}

void nbunny::CacheRefTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	lua_pushstring(L, value.get("resourceTypeID").as_string().c_str());
	lua_pushstring(L, value.get("filename").as_string().c_str());

	if (lua_pcall(L, 2, 1, 0))
	{
		lua_error(L);
	}
}

void nbunny::CacheRefTypeProvider::serialize(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, index, "filename");
	std::string filename = luaL_checkstring(L, -1);

	lua_getfield(L, index, "resourceTypeID");
	std::string type = luaL_checkstring(L, -1);

	lua_pop(L, 2);

	value.set("filename", filename);
	value.set("resourceTypeID", type);
}

void nbunny::PlayerStorageTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);
	if (lua_pcall(L, 0, 1, 0))
	{
		lua_error(L);
	}

	lua_getfield(L, -1, "deserialize");

	lua_pushvalue(L, -2);
	value.get("storage").to_lua(L);

	if (lua_pcall(L, 2, 0, 0))
	{
		lua_error(L);
	}
}

void nbunny::PlayerStorageTypeProvider::serialize(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, index, "serialize");
	lua_pushvalue(L, index);

	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	GameManagerVariant storage;
	storage.from_lua(L, -1);

	lua_pop(L, 1);

	value.set("storage", storage);
}

void nbunny::ColorTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	lua_pushnumber(L, value.get("r").as_number());
	lua_pushnumber(L, value.get("g").as_number());
	lua_pushnumber(L, value.get("b").as_number());
	lua_pushnumber(L, value.get("a").as_number());

	if (lua_pcall(L, 4, 1, 0))
	{
		lua_error(L);
	}
}

void nbunny::ColorTypeProvider::serialize(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, index, "r");
	auto r = luaL_checknumber(L, -1);

	lua_getfield(L, index, "g");
	auto g = luaL_checknumber(L, -1);

	lua_getfield(L, index, "b");
	auto b = luaL_checknumber(L, -1);

	lua_getfield(L, index, "a");
	auto a = luaL_checknumber(L, -1);

	value.set("r", r);
	value.set("g", g);
	value.set("b", b);
	value.set("a", a);
}

void nbunny::DecorationTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	value.get("decoration").to_lua(L);
	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}
}

void nbunny::DecorationTypeProvider::serialize(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, index, "serialize");
	lua_pushvalue(L, index);

	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	GameManagerVariant decoration;
	decoration.from_lua(L, -1);

	lua_pop(L, 1);

	value.set("decoration", decoration);
}

void nbunny::SplineTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	value.get("spline").to_lua(L);
	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}
}

void nbunny::SplineTypeProvider::serialize(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, index, "serialize");
	lua_pushvalue(L, index);

	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	GameManagerVariant spline;
	spline.from_lua(L, -1);

	lua_pop(L, 1);

	value.set("spline", spline);
}

void nbunny::MapTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	lua_getfield(L, -1, "loadFromTable");
	value.get("map").to_lua(L);

	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	lua_remove(L, -2);
}

void nbunny::MapTypeProvider::serialize(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, index, "serialize");
	lua_pushvalue(L, index);

	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	GameManagerVariant map;
	map.from_lua(L, -1);

	lua_pop(L, 1);

	value.set("map", map);
}

void nbunny::TileTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	push_type(L);

	value.get("tile").to_lua(L);
	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}
}

void nbunny::TileTypeProvider::serialize(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, index, "serialize");
	lua_pushvalue(L, index);

	if (lua_pcall(L, 1, 1, 0))
	{
		lua_error(L);
	}

	GameManagerVariant tile;
	tile.from_lua(L, -1);

	lua_pop(L, 1);

	value.set("tile", tile);
}

void nbunny::InstanceTypeProvider::deserialize(lua_State* L, const GameManagerVariant& value)
{
	nbunny_game_manager_fetch(L);

	lua_getfield(L, -1, "getInstance");

	lua_pushvalue(L, -2);
	lua_pushstring(L, get_persisted_type_name().c_str());
	lua_pushnumber(L, value.get("id").as_number());

	if (lua_pcall(L, 3, 1, 0))
	{
		lua_error(L);
	}

	if (!lua_isnil(L, -1))
	{
		lua_getfield(L, -1, "instance");
		lua_remove(L, -2);
	}

	lua_remove(L, -2);
}

void nbunny::InstanceTypeProvider::serialize(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, index, "id");
	auto id = luaL_optinteger(L, -1, 0);

	lua_pop(L, 1);

	value.set("id", (double)id);
}

int nbunny::GameManagerState::REF = 0;

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
	connect<SplineTypeProvider>(
		L,
		"ItsyScape.Graphics.Spline",
		"ItsyScape.Graphics.Spline");
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
	connect<InstanceTypeProvider>(
		L, 
		"ItsyScape.Game.RemoteModel.Game",
		"ItsyScape.Game.Model.Game");
	connect<InstanceTypeProvider>(
		L, 
		"ItsyScape.Game.RemoteModel.Stage",
		"ItsyScape.Game.Model.Stage");
	connect<InstanceTypeProvider>(
		L, 
		"ItsyScape.Game.RemoteModel.Player",
		"ItsyScape.Game.Model.Player");
	connect<InstanceTypeProvider>(
		L, 
		"ItsyScape.Game.RemoteModel.Actor",
		"ItsyScape.Game.Model.Actor");
	connect<InstanceTypeProvider>(
		L, 
		"ItsyScape.Game.RemoteModel.Prop",
		"ItsyScape.Game.Model.Prop");
	connect<InstanceTypeProvider>(
		L, 
		"ItsyScape.Game.RemoteModel.UI",
		"ItsyScape.Game.Model.UI");
}

bool nbunny::GameManagerState::from_lua(lua_State* L, int index, GameManagerVariant& value)
{
	lua_getfield(L, -1, "__type");

	auto type_provider = std::find_if(
		type_providers.begin(),
		type_providers.end(),
		[L](auto& pair) {
			get_weak_reference(L, pair.first);

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
	type_provider->second->serialize(L, index, value);

	value.set("__persist", true);
	value.set("typeName", persisted_type_provider_names.find(type_provider->second.get())->second);

	return true;
}

bool nbunny::GameManagerState::to_lua(lua_State* L, const GameManagerVariant& value)
{
	auto type_name = value.get("typeName").as_string();

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
		nbunny::lua::push(L, state_shared_pointer);
		lua_rawset(L, LUA_REGISTRYINDEX);
	}
	else
	{
		state = nbunny::lua::get<nbunny::GameManagerState*>(L, -1);
		lua_pop(L, 1);
	}

	return state;
}

bool nbunny::GameManagerProperty::update(lua_State* L)
{
	auto previous_value = current_value;

	current_value = GameManagerVariant();
	current_value.from_lua(L, 1, std::max(lua_gettop(L), 1));

	bool was_empty = is_empty;
	is_empty = false;
	
	bool is_dirty = was_empty || previous_value != current_value;
	return is_dirty;
}

static int nbunny_game_manager_property_update(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);

	lua_remove(L, 1);
	lua_pushboolean(L, property->update(L));

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

void nbunny::GameManagerProperty::set_value(const GameManagerVariant& value)
{
	current_value = value;
	is_empty = false;
}

static int nbunny_game_manager_property_set_value(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);

	if (nbunny::lua::is_userdata<nbunny::GameManagerVariant>(L, 2))
	{
		auto variant = nbunny::lua::get<nbunny::GameManagerVariant*>(L, 2);
		property->set_value(*variant);
	}
	else
	{
		nbunny::GameManagerVariant value;
		value.from_lua(L, 2, std::max(lua_gettop(L) - 1, 1));

		property->set_value(value);
	}

	return 0;
}

static int nbunny_game_manager_property_pull_value(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);

	nbunny::GameManagerVariant key;
	key.from_lua(L, 2);

	auto value = nbunny::lua::get<nbunny::GameManagerVariant*>(L, 3);
	property->set_value(value->get(key));

	return 0;
}

nbunny::GameManagerVariant& nbunny::GameManagerProperty::get_value()
{
	return current_value;
}

const nbunny::GameManagerVariant& nbunny::GameManagerProperty::get_value() const
{
	return current_value;
}

static int nbunny_game_manager_property_constructor(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::GameManagerProperty>());
	return 1;
}

static int nbunny_game_manager_property_get_value(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);
	if (property->has_value())
	{
		return property->get_value().to_lua(L);
	}

	return 0;
}

static int nbunny_game_manager_property_rawget_value(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);
	if (property->has_value())
	{
		nbunny::lua::push(L, &property->get_value());
		return 1;
	}

	return 0;
}

static int nbunny_game_manager_property_has_value(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);
	nbunny::lua::push(L, property->has_value());
	return 1;
}

static int nbunny_game_manager_property_set_field(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);
	property->set_field(nbunny::lua::get<std::string>(L, 2));
	return 0;
}

static int nbunny_game_manager_property_get_field(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);
	nbunny::lua::push(L, property->get_field());
	return 1;
}

static int nbunny_game_manager_property_set_instance_interface(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);
	property->set_instance_interface(nbunny::lua::get<std::string>(L, 2));
	return 0;
}

static int nbunny_game_manager_property_get_instance_interface(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);
	nbunny::lua::push(L, property->get_instance_interface());
	return 1;
}

static int nbunny_game_manager_property_set_instance_id(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);
	property->set_instance_id(nbunny::lua::get<int>(L, 2));
	return 0;
}

static int nbunny_game_manager_property_get_instance_id(lua_State* L)
{
	auto property = nbunny::lua::get<nbunny::GameManagerProperty*>(L, 1);
	nbunny::lua::push(L, property->get_instance_id());
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_gamemanager_property(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "update", &nbunny_game_manager_property_update },
		{ "hasValue", &nbunny_game_manager_property_has_value },
		{ "setField", &nbunny_game_manager_property_set_field },
		{ "getField", &nbunny_game_manager_property_get_field },
		{ "setInstanceInterface", &nbunny_game_manager_property_set_instance_interface },
		{ "getInstanceInterface", &nbunny_game_manager_property_get_instance_interface },
		{ "setInstanceID", &nbunny_game_manager_property_set_instance_id },
		{ "getInstanceID", &nbunny_game_manager_property_get_instance_id },
		{ "setValue", &nbunny_game_manager_property_set_value },
		{ "pullValue", &nbunny_game_manager_property_pull_value },
		{ "getValue", &nbunny_game_manager_property_get_value },
		{ "rawgetValue", &nbunny_game_manager_property_rawget_value },
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_type<nbunny::GameManagerProperty>(L, &nbunny_game_manager_property_constructor, metatable);

	return 1;
}

void nbunny::GameManagerEventQueue::clear(std::size_t count)
{
	if (count == 0)
	{
		events.clear();
	}
	else
	{
		auto max = std::max(count, events.size());
		events.erase(events.begin(), events.begin() + max);
	}
}

void nbunny::GameManagerEventQueue::from_buffer(GameManagerBuffer& buffer)
{
	buffer.seek(0);

	while (buffer.tell() < buffer.length())
	{
		GameManagerVariant variant;
		variant.deserialize(buffer);

		events.emplace_back(std::move(variant));
	}
}

void nbunny::GameManagerEventQueue::to_buffer(GameManagerBuffer& buffer)
{
	for (auto& event: events)
	{
		event.serialize(buffer);
	}
}

void nbunny::GameManagerEventQueue::push(GameManagerVariant&& value)
{
	events.emplace_back(std::move(value));
}

void nbunny::GameManagerEventQueue::pull(const GameManagerVariant& value)
{
	events.push_back(value);
}

void nbunny::GameManagerEventQueue::pop(GameManagerVariant& value)
{
	value = events.front();
	events.pop_front();
}

void nbunny::GameManagerEventQueue::sort(const GameManagerVariant& key)
{
	std::sort(
		events.begin(),
		events.end(),
		[&](auto& a, auto& b)
		{
			return GameManagerVariant::less(a.get(key), b.get(key));
		});
}

std::size_t nbunny::GameManagerEventQueue::length() const
{
	return events.size();
}

void nbunny::GameManagerEventQueue::get(std::size_t index, GameManagerVariant& event) const
{
	event = events.at(index);
}

static int nbunny_game_manager_event_queue_constructor(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::GameManagerEventQueue>());
	return 1;
}

static int nbunny_game_manager_event_queue_clear(lua_State* L)
{
	auto queue = nbunny::lua::get<nbunny::GameManagerEventQueue*>(L, 1);
	queue->clear();
	return 0;
}

static int nbunny_game_manager_event_queue_pull(lua_State* L)
{
	auto queue = nbunny::lua::get<nbunny::GameManagerEventQueue*>(L, 1);
	auto variant = nbunny::lua::get<nbunny::GameManagerVariant*>(L, 2);
	queue->pull(*variant);
	return 0;
}

static int nbunny_game_manager_event_queue_pop(lua_State* L)
{
	auto queue = nbunny::lua::get<nbunny::GameManagerEventQueue*>(L, 1);
	auto variant = nbunny::lua::get<nbunny::GameManagerVariant*>(L, 2);
	queue->pop(*variant);
	return 0;
}

static int nbunny_game_manager_event_queue_push(lua_State* L)
{
	auto queue = nbunny::lua::get<nbunny::GameManagerEventQueue*>(L, 1);

	nbunny::GameManagerVariant event;
	event.to_table();

	for (int index = 2; index <= lua_gettop(L); index += 2)
	{
		nbunny::GameManagerVariant key;
		if (nbunny::lua::is_userdata<nbunny::GameManagerVariant>(L, index))
		{
			key = *nbunny::lua::get<nbunny::GameManagerVariant>(L, index);
		}
		else
		{
			key.from_lua(L, index);
		}

		nbunny::GameManagerVariant value;
		if (nbunny::lua::is_userdata<nbunny::GameManagerVariant>(L, index + 1))
		{
			value = *nbunny::lua::get<nbunny::GameManagerVariant>(L, index + 1);
		}
		else
		{
			value.from_lua(L, index + 1);
		}

		event.set(key, value);
	}

	queue->push(std::move(event));

	return 0;
}

static int nbunny_game_manager_event_queue_sort(lua_State* L)
{
	auto queue = nbunny::lua::get<nbunny::GameManagerEventQueue*>(L, 1);

	nbunny::GameManagerVariant key;
	if (nbunny::lua::is_userdata<nbunny::GameManagerVariant>(L, 2))
	{
		key = *nbunny::lua::get<nbunny::GameManagerVariant*>(L, 2);
	}
	else
	{
		key.from_lua(L, 2);
	}

	queue->sort(key);

	return 0;
}

static int nbunny_game_manager_event_queue_from_buffer(lua_State* L)
{
	auto queue = nbunny::lua::get<nbunny::GameManagerEventQueue*>(L, 1);

	if (lua_islightuserdata(L, 2))
	{
		auto buffer = (nbunny::GameManagerBuffer*)lua_touserdata(L, 2);
		queue->from_buffer(*buffer);
	}

	return 0;
}

static int nbunny_game_manager_event_queue_to_buffer(lua_State* L)
{
	auto queue = nbunny::lua::get<nbunny::GameManagerEventQueue*>(L, 1);

	nbunny::GameManagerBuffer* buffer = new nbunny::GameManagerBuffer();
	queue->to_buffer(*buffer);

	lua_pushlightuserdata(L, buffer);
	return 1;
}

static int nbunny_game_manager_event_queue_length(lua_State* L)
{
	auto queue = nbunny::lua::get<nbunny::GameManagerEventQueue*>(L, 1);
	nbunny::lua::push(L, queue->length());
	return 1;
}

static int nbunny_game_manager_event_queue_get(lua_State* L)
{
	auto queue = nbunny::lua::get<nbunny::GameManagerEventQueue*>(L, 1);
	auto index = nbunny::lua::get<std::size_t>(L, 2);
	auto variant = nbunny::lua::get<nbunny::GameManagerVariant*>(L, 3);
	queue->get(index, *variant);
	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_gamemanager_eventqueue(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "clear", &nbunny_game_manager_event_queue_clear },
		{ "push", &nbunny_game_manager_event_queue_push },
		{ "pull", &nbunny_game_manager_event_queue_pull },
		{ "pop", &nbunny_game_manager_event_queue_pop },
		{ "length", &nbunny_game_manager_event_queue_length },
		{ "get", &nbunny_game_manager_event_queue_get },
		{ "sort", &nbunny_game_manager_event_queue_sort },
		{ "fromBuffer", &nbunny_game_manager_event_queue_from_buffer },
		{ "toBuffer", &nbunny_game_manager_event_queue_to_buffer },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_type<nbunny::GameManagerEventQueue>(L, &nbunny_game_manager_event_queue_constructor, metatable);

	return 1;
}
