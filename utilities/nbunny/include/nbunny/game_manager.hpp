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

#include <unordered_map>
#include <vector>
#include <string>

#include "nbunny.hpp"

namespace nbunny
{
	class TypeProvider
	{
	public:
		virtual ~TypeProvider()
		{
			// Nothing.
		}

		virtual void serialize(lua_State* L) = 0;
	};

	class QuaternionTypeProvider : public TypeProvider
	{
	public:
		void serialize(lua_State* L) override;
	};

	class VectorTypeProvider : public TypeProvider
	{
	public:
		void serialize(lua_State* L) override;
	};

	class CacheRefTypeProvider : public TypeProvider
	{
	public:
		void serialize(lua_State* L) override;
	};

	class InstanceTypeProvider : public TypeProvider
	{
	public:
		void serialize(lua_State* L) override;
	};

	class GameManagerState
	{
	private:
		std::vector<std::pair<sol::table, std::unique_ptr<TypeProvider>>> type_providers;
		std::unordered_map<TypeProvider*, std::string> type_provider_names;
		std::unordered_map<TypeProvider*, std::string> persisted_type_provider_names;

		bool serialize_type(lua_State* L, int index);
		void serialize_table(lua_State* L, int index);
		void serialize_arg(lua_State* L, int state_index, int table_index, int stack_index);

	public:
		static int REF;

		GameManagerState(lua_State* L);

		void serialize(lua_State* L, int count);
		bool deep_equals(lua_State* L, const sol::object& left, const sol::object& right);

		template <typename T>
		void connect(lua_State* L, const std::string& type_name, const std::string& persisted_type_name)
		{
			lua_getfield(L, LUA_GLOBALSINDEX, "require");
			lua_pushstring(L, type_name.c_str());
			lua_call(L, 1, 1);

			auto key = sol::stack::get<sol::table>(L, -1);
			auto type_provider = std::make_unique<T>();
			auto type_provider_pointer = type_provider.get();

			type_providers.emplace_back(key, std::move(type_provider));
			type_provider_names.emplace(std::make_pair(type_provider_pointer, type_name));
			persisted_type_provider_names.emplace(std::make_pair(type_provider_pointer, persisted_type_name));

			lua_pop(L, 1);
		}
	};

	class GameManagerProperty
	{
	private:
		std::string instance_interface;
		int instance_id;

		std::string field;
		sol::object current_value;
		bool is_empty = true;

	public:
		bool update(lua_State* L, GameManagerState& state);

		void set_instance_interface(const std::string& value);
		const std::string& get_instance_interface() const;

		void set_instance_id(int value);
		int get_instance_id() const;

		void set_field(const std::string& value);
		const std::string& get_field() const;

		bool has_value() const;

		void set_value(const sol::object& object);
		sol::object get_value() const;
	};
}

#endif
