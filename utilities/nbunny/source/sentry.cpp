////////////////////////////////////////////////////////////////////////////////
// source/sentry.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <sentry.h>
#include "nbunny/nbunny.hpp"

static int nbunny_sentry_error(lua_State* L)
{
	auto backtrace = luaL_checkstring(L, 1);

	auto event = sentry_value_new_event();
	auto exception = sentry_value_new_exception("Exception", backtrace);

	auto context = sentry_value_new_object();

	auto variables = sentry_value_new_list();
	for (std::size_t i = 1; i <= lua_objlen(L, 2); ++i)
	{
		lua_rawgeti(L, 2, i);

		auto variable = sentry_value_new_object();

		lua_getfield(L, -1, "name");
		sentry_value_set_by_key(variable, "name", sentry_value_new_string(luaL_optstring(L, -1, "<missing>")));
		lua_pop(L, 1);

		lua_getfield(L, -1, "type");
		sentry_value_set_by_key(variable, "type", sentry_value_new_string(luaL_optstring(L, -1, "<missing>")));
		lua_pop(L, 1);

		lua_getfield(L, -1, "storage");
		sentry_value_set_by_key(variable, "storage", sentry_value_new_string(luaL_optstring(L, -1, "<missing>")));
		lua_pop(L, 1);

		lua_getfield(L, -1, "value");
		sentry_value_set_by_key(variable, "value", sentry_value_new_string(luaL_optstring(L, -1, "<missing>")));
		lua_pop(L, 1);

		lua_pop(L, 1);

		sentry_value_append(variables, variable);
	}

	sentry_value_set_by_key(context, "variables", variables);

	sentry_set_context("variables", context);
	sentry_event_add_exception(event, exception);

	sentry_capture_event(event);

	return 0;
}

static int nbunny_sentry_init(lua_State* L)
{
	auto dsn = luaL_checkstring(L, 1);
	auto path = luaL_checkstring(L, 2);
	auto version = luaL_checkstring(L, 3);
	auto release = std::string("itsyrealm@") + version;

	sentry_options_t* options = sentry_options_new();
	sentry_options_set_dsn(options, dsn);

	sentry_options_set_database_path(options, path);
	sentry_options_set_release(options, release.c_str());
	sentry_options_set_debug(options, 1);
	sentry_init(options);

	return 0;
}

static int nbunny_sentry_close(lua_State* L)
{
	sentry_close();

	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_sentry(lua_State* L)
{
	auto T = sol::table(nbunny::get_lua_state(L), sol::create);
	T["error"] = nbunny_sentry_error;
	T["init"] = nbunny_sentry_init;
	T["close"] = nbunny_sentry_close;

	sol::stack::push(L, T);

	return 1;
}
