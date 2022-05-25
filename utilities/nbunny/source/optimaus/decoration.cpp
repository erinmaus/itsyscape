////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/decoration.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <algorithm>
#include "nbunny/optimaus/decoration.hpp"

static int nbunny_decoration_feature_set_tile_id(lua_State* L)
{
	auto& feature = sol::stack::get<nbunny::DecorationFeature&>(L, 1);
	feature.tile_id = luaL_checkstring(L, 2);
	return 0;
}

static int nbunny_decoration_feature_get_tile_id(lua_State* L)
{
	auto& feature = sol::stack::get<nbunny::DecorationFeature&>(L, 1);
	lua_pushlstring(L, feature.tile_id.data(), feature.tile_id.size());
	return 1;
}

static int nbunny_decoration_feature_set_position(lua_State* L)
{
	auto& feature = sol::stack::get<nbunny::DecorationFeature&>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	feature.position = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_decoration_feature_get_position(lua_State* L)
{
	auto& feature = sol::stack::get<nbunny::DecorationFeature&>(L, 1);
	lua_pushnumber(L, feature.position.x);
	lua_pushnumber(L, feature.position.y);
	lua_pushnumber(L, feature.position.z);
	return 3;
}

static int nbunny_decoration_feature_set_rotation(lua_State* L)
{
	auto& feature = sol::stack::get<nbunny::DecorationFeature&>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float w = (float)luaL_checknumber(L, 5);
	feature.rotation = glm::quat(w, x, y, z);
	return 0;
}

static int nbunny_decoration_feature_get_rotation(lua_State* L)
{
	auto& feature = sol::stack::get<nbunny::DecorationFeature&>(L, 1);
	lua_pushnumber(L, feature.rotation.x);
	lua_pushnumber(L, feature.rotation.y);
	lua_pushnumber(L, feature.rotation.z);
	lua_pushnumber(L, feature.rotation.w);
	return 4;
}

static int nbunny_decoration_feature_set_scale(lua_State* L)
{
	auto& feature = sol::stack::get<nbunny::DecorationFeature&>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	feature.scale = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_decoration_feature_get_scale(lua_State* L)
{
	auto& feature = sol::stack::get<nbunny::DecorationFeature&>(L, 1);
	lua_pushnumber(L, feature.scale.x);
	lua_pushnumber(L, feature.scale.y);
	lua_pushnumber(L, feature.scale.z);
	return 3;
}

static int nbunny_decoration_feature_set_color(lua_State* L)
{
	auto& feature = sol::stack::get<nbunny::DecorationFeature&>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float w = (float)luaL_checknumber(L, 5);
	feature.color = glm::vec4(x, y, z, w);
	return 0;
}

static int nbunny_decoration_feature_get_color(lua_State* L)
{
	auto& feature = sol::stack::get<nbunny::DecorationFeature&>(L, 1);
	lua_pushnumber(L, feature.color.x);
	lua_pushnumber(L, feature.color.y);
	lua_pushnumber(L, feature.color.z);
	lua_pushnumber(L, feature.color.w);
	return 4;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_decorationfeature(lua_State* L)
{
	sol::usertype<nbunny::DecorationFeature> T(
		sol::call_constructor, sol::constructors<nbunny::DecorationFeature()>(),
		"setID", &nbunny_decoration_feature_set_tile_id,
		"getID", &nbunny_decoration_feature_get_tile_id,
		"setPosition", &nbunny_decoration_feature_set_position,
		"getPosition", &nbunny_decoration_feature_get_position,
		"setRotation", &nbunny_decoration_feature_set_rotation,
 		"getRotation", &nbunny_decoration_feature_get_rotation,
		"setScale", &nbunny_decoration_feature_set_scale,
		"getScale", &nbunny_decoration_feature_get_scale,
		"setColor", &nbunny_decoration_feature_set_color,
		"getColor", &nbunny_decoration_feature_get_color);

	sol::stack::push(L, T);

	return 1;
}

nbunny::DecorationFeature* nbunny::Decoration::add_feature(const DecorationFeature& description)
{
	features.emplace_back(std::make_unique<DecorationFeature>(description));

	return features.back().get();
}

bool nbunny::Decoration::remove_feature(DecorationFeature* feature)
{
	auto i = std::find_if(features.begin(), features.end(), [feature](auto& f)
	{
		return f.get() == feature;
	});

	if (i != features.end())
	{
		features.erase(i);
		return true;
	}

	return false;
}

std::size_t nbunny::Decoration::get_num_features() const
{
	return features.size();
}

nbunny::DecorationFeature* nbunny::Decoration::get_feature_by_index(std::size_t index) const
{
	return features.at(index).get();
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_decoration(lua_State* L)
{
	sol::usertype<nbunny::Decoration> T(
		sol::call_constructor, sol::constructors<nbunny::Decoration()>(),
		"addFeature", &nbunny::Decoration::add_feature,
		"removeFeature", &nbunny::Decoration::remove_feature,
		"getNumFeatures", &nbunny::Decoration::get_num_features,
		"getFeatureByIndex", &nbunny::Decoration::get_feature_by_index);

	sol::stack::push(L, T);

	return 1;
}
