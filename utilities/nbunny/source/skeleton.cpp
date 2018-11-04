////////////////////////////////////////////////////////////////////////////////
// source/skeleton.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "nbunny/nbunny.hpp"
#include "nbunny/skeleton.hpp"

static int nbunny_keyframe_get_time(lua_State* L)
{
	auto& keyFrame = sol::stack::get<nbunny::KeyFrame>(L, 1);
	lua_pushnumber(L, keyFrame.time);
	return 1;
}

static int nbunny_keyframe_set_time(lua_State* L)
{
	auto& keyFrame = sol::stack::get<nbunny::KeyFrame>(L, 1);
	keyFrame.time = (float)luaL_checknumber(L, 2);
	return 0;
}

static int nbunny_keyframe_get_rotation(lua_State* L)
{
	auto& keyFrame = sol::stack::get<nbunny::KeyFrame>(L, 1);
	lua_pushnumber(L, keyFrame.rotation.x);
	lua_pushnumber(L, keyFrame.rotation.y);
	lua_pushnumber(L, keyFrame.rotation.z);
	lua_pushnumber(L, keyFrame.rotation.w);
	return 4;
}

static int nbunny_keyframe_set_rotation(lua_State* L)
{
	auto& keyFrame = sol::stack::get<nbunny::KeyFrame>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float w = (float)luaL_checknumber(L, 5);
	keyFrame.rotation = glm::quat(w, x, y, z);
	return 0;
}

static int nbunny_keyframe_get_scale(lua_State* L)
{
	auto& keyFrame = sol::stack::get<nbunny::KeyFrame>(L, 1);
	lua_pushnumber(L, keyFrame.scale.x);
	lua_pushnumber(L, keyFrame.scale.y);
	lua_pushnumber(L, keyFrame.scale.z);
	return 3;
}

static int nbunny_keyframe_set_scale(lua_State* L)
{
	auto& keyFrame = sol::stack::get<nbunny::KeyFrame>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	keyFrame.scale = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_keyframe_get_translation(lua_State* L)
{
	auto& keyFrame = sol::stack::get<nbunny::KeyFrame>(L, 1);
	lua_pushnumber(L, keyFrame.translation.x);
	lua_pushnumber(L, keyFrame.translation.y);
	lua_pushnumber(L, keyFrame.translation.z);
	return 0;
}

static int nbunny_keyframe_set_translation(lua_State* L)
{
	auto& keyFrame = sol::stack::get<nbunny::KeyFrame>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	keyFrame.translation = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_keyframe_interpolate(lua_State* L)
{
	auto& self = sol::stack::get<nbunny::KeyFrame>(L, 1);
	auto& other = sol::stack::get<nbunny::KeyFrame>(L, 2);
	float time = (float)luaL_checknumber(L, 3);
	auto result = glm::transpose(nbunny::KeyFrame::interpolate(self, other, time));
	auto pointer = glm::value_ptr(result);

	for (int i = 0; i < 16; ++i)
	{
		lua_pushnumber(L, pointer[i]);
	}

	return 16;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_skeletonkeyframe(lua_State* L)
{
	sol::usertype<nbunny::KeyFrame> T(
		sol::call_constructor, sol::constructors<nbunny::KeyFrame()>(),
		"getTime", &nbunny_keyframe_get_time,
		"setTime", &nbunny_keyframe_set_time,
		"getRotation", &nbunny_keyframe_get_rotation,
		"setRotation", &nbunny_keyframe_set_rotation,
		"getScale", &nbunny_keyframe_get_scale,
		"setScale", &nbunny_keyframe_set_scale,
		"getTranslation", &nbunny_keyframe_get_translation,
		"setTranslation", &nbunny_keyframe_set_translation,
		"interpolate", &nbunny_keyframe_interpolate);

	sol::stack::push(L, T);

	return 1;
}
