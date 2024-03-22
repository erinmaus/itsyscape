////////////////////////////////////////////////////////////////////////////////
// source/gl.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "nbunny/nbunny.hpp"
#include "modules/graphics/opengl/OpenGL.h"

static int nbunny_create_any_sample_query(lua_State* L)
{
	glad::GLuint id;
	glad::glGenQueries(1, &id);

	lua_pushnumber(L, id);
	return 1;
}

static int nbunny_begin_any_sample_query(lua_State* L)
{
	glad::GLuint id = (glad::GLuint)luaL_checknumber(L, 1);

	glad::glBeginQuery(GL_ANY_SAMPLES_PASSED, id);

	return 0;
}

static int nbunny_end_any_sample_query(lua_State* L)
{
	glad::glEndQuery(GL_ANY_SAMPLES_PASSED);

	return 0;
}

static int nbunny_use_sample_query(lua_State* L)
{
	glad::GLuint id = (glad::GLuint)luaL_checknumber(L, 1);

	glad::glBeginConditionalRender(id, GL_QUERY_WAIT);

	return 0;
}

static int nbunny_end_sample_query(lua_State* L)
{
	glad::glEndConditionalRender();

	return 0;
}

static int nbunny_get_error(lua_State* L)
{
	lua_pushnumber(L, glad::glGetError());

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_gl(lua_State* L)
{
	auto T = sol::table(nbunny::get_lua_state(L), sol::create);
	T["createAnySampleQuery"] = nbunny_create_any_sample_query;
	T["beginAnySampleQuery"] = nbunny_begin_any_sample_query;
	T["endAnySampleQuery"] = nbunny_end_any_sample_query;
	T["beginConditionalRender"] = nbunny_use_sample_query;
	T["endConditionalRender"] = nbunny_end_sample_query;
	T["getError"] = nbunny_get_error;

	sol::stack::push(L, T);

	return 1;
}
