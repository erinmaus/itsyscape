////////////////////////////////////////////////////////////////////////////////
// nbunny/game_manager.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_GAME_MANAGER_HPP
#define NBUNNY_GAME_MANAGER_HPP

#include <deque>
#include <map>
#include <set>
#include <string>
#include <unordered_map>
#include <vector>

#include "nbunny/nbunny.hpp"
#include "nbunny/optimaus/common.hpp"

namespace nbunny
{
	class GameManagerBuffer
	{
	public:
		GameManagerBuffer();
		GameManagerBuffer(const std::vector<std::uint8_t>& data);

		template <typename T>
		void read(T& value)
		{
			auto size = sizeof(T);
			read((std::uint8_t*)&value, size);
		}

		template <typename T>
		void append(const T& value)
		{
			auto size = sizeof(T);
			append((const std::uint8_t*)&value, size);
		}

		void read(std::uint8_t* data, std::size_t size);
		void append(const std::uint8_t*, std::size_t size);

		void seek(std::size_t offset);
		std::size_t tell() const;

		std::size_t length() const;
		void* get_pointer();

		void compress();
		void decompress();

	private:
		std::vector<std::uint8_t> buffer;
		std::size_t current_offset = 0;
	};

	class GameManagerVariant
	{
	public:
		enum Type
		{
			TYPE_NIL = 0,
			TYPE_NUMBER,
			TYPE_BOOLEAN,
			TYPE_STRING,
			TYPE_TABLE,
			TYPE_ARGS
		};

		GameManagerVariant();
		GameManagerVariant(double value);
		GameManagerVariant(bool value);
		GameManagerVariant(const std::string& value);
		GameManagerVariant(const char* value);
		GameManagerVariant(const GameManagerVariant& other);
		GameManagerVariant(GameManagerVariant&& other);
		~GameManagerVariant();

		GameManagerVariant& operator =(const GameManagerVariant& other);
		GameManagerVariant& operator =(GameManagerVariant&& other);

		void from_lua(lua_State* L, int index, int count = -1, bool simple_marshal = false);
		int to_lua(lua_State* L, bool simple_marshal = false) const;

		int get_type() const;

		double as_number() const;
		bool as_boolean() const;
		std::string as_string() const;

		GameManagerVariant get(const GameManagerVariant& key) const;
		GameManagerVariant get(std::size_t index) const;

		void set(const GameManagerVariant& key, const GameManagerVariant& value);

		int length() const;

		void to_nil();
		void to_number(double value);
		void to_boolean(bool value);
		void to_string(const std::string& value);
		void to_table();
		void to_args(std::size_t count);

		bool operator ==(const GameManagerVariant& other) const;
		bool operator !=(const GameManagerVariant& other) const;
		bool operator <(const GameManagerVariant& other) const;
		static bool less(const GameManagerVariant& search_key, const GameManagerVariant& current_key);

		void unset();

		void serialize(GameManagerBuffer& buffer);
		void deserialize(GameManagerBuffer& buffer);

	private:
		int type = TYPE_NIL;

		struct Table
		{
			std::vector<GameManagerVariant> array_values;
			std::vector<std::pair<GameManagerVariant, GameManagerVariant>> key_values;
			std::map<std::string, GameManagerVariant> string_key_values;
		};

		struct Args
		{
			std::vector<GameManagerVariant> parameter_values;
		};

		union
		{
			double number;
			uint8_t boolean;
			std::string* string;
			Table* table;
			Args* args;
		} value;

		void from_lua(lua_State* L, int index, std::set<const void*>& e, bool simple_marshal);
	};

	class GameManagerState;

	class TypeProvider
	{
	private:
		GameManagerState* state = nullptr;
		std::string persisted_type_name;
		int type;

	public:
		virtual ~TypeProvider() = default;

		void connect(GameManagerState& state, const std::string& persisted_type_name, int type);
		GameManagerState& get_state() const;
		const std::string& get_persisted_type_name() const;
		int get_type() const;

		void push_type(lua_State* L);

		virtual void deserialize(lua_State* L, const GameManagerVariant& value) = 0;
		virtual void serialize(lua_State* L, int index, GameManagerVariant& value) = 0;
	};

	class QuaternionTypeProvider : public TypeProvider
	{
	public:
		void deserialize(lua_State* L, const GameManagerVariant& value) override;
		void serialize(lua_State* L, int index, GameManagerVariant& value) override;
	};

	class VectorTypeProvider : public TypeProvider
	{
	public:
		void deserialize(lua_State* L, const GameManagerVariant& value) override;
		void serialize(lua_State* L, int index, GameManagerVariant& value) override;
	};

	class RayTypeProvider : public TypeProvider
	{
	public:
		void deserialize(lua_State* L, const GameManagerVariant& value) override;
		void serialize(lua_State* L, int index, GameManagerVariant& value) override;
	};

	class CacheRefTypeProvider : public TypeProvider
	{
	public:
		void deserialize(lua_State* L, const GameManagerVariant& value) override;
		void serialize(lua_State* L, int index, GameManagerVariant& value) override;
	};

	class PlayerStorageTypeProvider : public TypeProvider
	{
	public:
		void deserialize(lua_State* L, const GameManagerVariant& value) override;
		void serialize(lua_State* L, int index, GameManagerVariant& value) override;
	};

	class ColorTypeProvider : public TypeProvider
	{
	public:
		void deserialize(lua_State* L, const GameManagerVariant& value) override;
		void serialize(lua_State* L, int index, GameManagerVariant& value) override;
	};

	class DecorationTypeProvider : public TypeProvider
	{
	public:
		void deserialize(lua_State* L, const GameManagerVariant& value) override;
		void serialize(lua_State* L, int index, GameManagerVariant& value) override;
	};

	class SplineTypeProvider : public TypeProvider
	{
	public:
		void deserialize(lua_State* L, const GameManagerVariant& value) override;
		void serialize(lua_State* L, int index, GameManagerVariant& value) override;
	};

	class MapTypeProvider : public TypeProvider
	{
	public:
		void deserialize(lua_State* L, const GameManagerVariant& value) override;
		void serialize(lua_State* L, int index, GameManagerVariant& value) override;
	};

	class TileTypeProvider : public TypeProvider
	{
	public:
		void deserialize(lua_State* L, const GameManagerVariant& value) override;
		void serialize(lua_State* L, int index, GameManagerVariant& value) override;
	};

	class InstanceTypeProvider : public TypeProvider
	{
	public:
		void deserialize(lua_State* L, const GameManagerVariant& value) override;
		void serialize(lua_State* L, int index, GameManagerVariant& value) override;
	};

	class GameManagerState
	{
	private:
		std::vector<std::pair<int, std::unique_ptr<TypeProvider>>> type_providers;
		std::unordered_map<TypeProvider*, std::string> type_provider_names;
		std::unordered_map<TypeProvider*, std::string> persisted_type_provider_names;

	public:
		static int REF;

		GameManagerState(lua_State* L);

		bool from_lua(lua_State* L, int index, GameManagerVariant& value);
		bool to_lua(lua_State* L, const GameManagerVariant& value);

		template <typename T>
		void connect(lua_State* L, const std::string& type_name, const std::string& persisted_type_name)
		{
			lua_getfield(L, LUA_GLOBALSINDEX, "require");
			lua_pushstring(L, type_name.c_str());
			lua_call(L, 1, 1);

			auto key = set_weak_reference(L);
			auto type_provider = std::make_unique<T>();
			type_provider->connect(*this, persisted_type_name, key);

			auto type_provider_pointer = type_provider.get();

			type_providers.emplace_back(key, std::move(type_provider));
			type_provider_names.emplace(std::make_pair(type_provider_pointer, type_name));
			persisted_type_provider_names.emplace(std::make_pair(type_provider_pointer, persisted_type_name));

			lua_pop(L, 1);
		}

		static GameManagerState* get(lua_State* L);
	};

	class GameManagerProperty
	{
	private:
		std::string instance_interface;
		int instance_id;

		std::string field;
		GameManagerVariant current_value;

		bool is_empty = true;

	public:
		GameManagerProperty() = default;

		bool update(lua_State* L);

		void set_instance_interface(const std::string& value);
		const std::string& get_instance_interface() const;

		void set_instance_id(int value);
		int get_instance_id() const;

		void set_field(const std::string& value);
		const std::string& get_field() const;

		bool has_value() const;

		void set_value(const GameManagerVariant& current_value);
		GameManagerVariant& get_value();
		const GameManagerVariant& get_value() const;

		void push_value(lua_State* L, GameManagerState& state);
	};

	class GameManagerInstance
	{
	private:
		std::vector<std::shared_ptr<GameManagerProperty>> properties;

	public:
		GameManagerInstance();
		~GameManagerInstance() = default;
	};

	class GameManagerEventQueue
	{
	private:
		std::deque<GameManagerVariant> events;

	public:
		GameManagerEventQueue() = default;

		void clear(std::size_t count = 0);

		void from_buffer(GameManagerBuffer& buffer);
		void to_buffer(GameManagerBuffer& buffer);

		void push(GameManagerVariant&& value);
		void pull(const GameManagerVariant& value);
		void pop(GameManagerVariant& value);

		void sort(const GameManagerVariant& key);

		std::size_t length() const;
		void get(std::size_t index, GameManagerVariant& event) const;
	};
}

#endif
