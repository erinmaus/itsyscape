////////////////////////////////////////////////////////////////////////////////
// source/scene.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/runtime.h"
#include "modules/math/Transform.h"
#include "nbunny/lua_runtime.hpp"
#include "nbunny/nbunny.hpp"

static int nbunny_inverse_transform(lua_State* L)
{
	auto input_transform = love::luax_checktype<love::math::Transform>(L, 1);
	auto output_transform = love::luax_checktype<love::math::Transform>(L, 2);

	auto inverse = input_transform->inverse();
	output_transform->setMatrix(inverse->getMatrix());

	inverse->release();

	return 0;
}

static int nbunny_transform_point(lua_State* L)
{
	auto transform = love::luax_checktype<love::math::Transform>(L, 1);
	auto x = luaL_optnumber(L, 2, 0.0f);
	auto y = luaL_optnumber(L, 3, 0.0f);
	auto z = luaL_optnumber(L, 4, 0.0f);
	auto w = luaL_optnumber(L, 5, 1.0f);

	auto matrix = glm::make_mat4(transform->getMatrix().getElements());
	auto point = glm::vec4(x, y, z, w);
	auto result = matrix * point;

	lua_pushnumber(L, result.x);
	lua_pushnumber(L, result.y);
	lua_pushnumber(L, result.z);
	lua_pushnumber(L, result.w);

	return 4;
}

static int nbunny_inverse_transform_point(lua_State* L)
{
	auto transform = love::luax_checktype<love::math::Transform>(L, 1);
	auto x = luaL_optnumber(L, 2, 0.0f);
	auto y = luaL_optnumber(L, 3, 0.0f);
	auto z = luaL_optnumber(L, 4, 0.0f);
	auto w = luaL_optnumber(L, 5, 1.0f);

	auto matrix = glm::inverse(glm::make_mat4(transform->getMatrix().getElements()));
	auto point = glm::vec4(x, y, z, w);
	auto result = matrix * point;

	lua_pushnumber(L, result.x);
	lua_pushnumber(L, result.y);
	lua_pushnumber(L, result.z);
	lua_pushnumber(L, result.w);

	return 4;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_transform(lua_State* L)
{
	lua_newtable(L);

	nbunny::lua::push_function(L, &nbunny_inverse_transform, "Transform::inverse");
	lua_setfield(L, -2, "inverse");

	nbunny::lua::push_function(L, &nbunny_transform_point, "Transform::transformPoint");
	lua_setfield(L, -2, "transformPoint");

	nbunny::lua::push_function(L, &nbunny_inverse_transform_point, "Transform::inverseTransformPoint");
	lua_setfield(L, -2, "inverseTransformPoint");

	return 1;
}
