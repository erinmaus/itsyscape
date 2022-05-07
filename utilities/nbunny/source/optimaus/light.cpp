////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/light.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "nbunny/optimaus/light.hpp"

const nbunny::Type<nbunny::LightSceneNode> nbunny::LightSceneNode::type_pointer;

const nbunny::BaseType& nbunny::LightSceneNode::get_type() const
{
	return type_pointer;
}

nbunny::LightSceneNode::LightSceneNode(int reference) :
	SceneNode(reference)
{
	// Nothing.
}

const bool nbunny::LightSceneNode::is_base_light_type() const
{
	return get_type() == type_pointer;
}

void nbunny::LightSceneNode::set_current_color(const glm::vec3& value)
{
	current_color = value;
}

const glm::vec3& nbunny::LightSceneNode::get_current_color() const
{
	return current_color;
}

void nbunny::LightSceneNode::set_previous_color(const glm::vec3& value)
{
	previous_color = value;
}

const glm::vec3& nbunny::LightSceneNode::get_previous_color() const
{
	return previous_color;
}

void nbunny::LightSceneNode::set_is_global(bool value)
{
	is_global = value;
}

bool nbunny::LightSceneNode::get_is_global() const
{
	return is_global;
}

void nbunny::LightSceneNode::to_light(Light& light, float delta) const
{
	light.color = glm::mix(
		current_color,
		get_ticked() ? previous_color : current_color,
		delta);
}

void nbunny::LightSceneNode::tick()
{
	SceneNode::tick();

	previous_color = current_color;
}

static int nbunny_light_scene_node_set_current_color(lua_State* L)
{
	auto node = sol::stack::get<nbunny::LightSceneNode*>(L, 1);
	float r = (float)luaL_checknumber(L, 2);
	float g = (float)luaL_checknumber(L, 3);
	float b = (float)luaL_checknumber(L, 4);
	node->set_current_color(glm::vec3(r, g, b));
	return 0;
}

static int nbunny_light_scene_node_get_current_color(lua_State* L)
{
	auto node = sol::stack::get<nbunny::LightSceneNode*>(L, 1);
	const auto& color = node->get_current_color();
	lua_pushnumber(L, color.x);
	lua_pushnumber(L, color.y);
	lua_pushnumber(L, color.z);
	return 3;
}

static int nbunny_light_scene_node_set_previous_color(lua_State* L)
{
	auto node = sol::stack::get<nbunny::LightSceneNode*>(L, 1);
	float r = (float)luaL_checknumber(L, 2);
	float g = (float)luaL_checknumber(L, 3);
	float b = (float)luaL_checknumber(L, 4);
	node->set_previous_color(glm::vec3(r, g, b));
	return 0;
}

static int nbunny_light_scene_node_get_previous_color(lua_State* L)
{
	auto node = sol::stack::get<nbunny::LightSceneNode*>(L, 1);
	const auto& color = node->get_previous_color();
	lua_pushnumber(L, color.x);
	lua_pushnumber(L, color.y);
	lua_pushnumber(L, color.z);
	return 3;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_lightscenenode(lua_State* L)
{
	sol::usertype<nbunny::LightSceneNode> T(
		sol::base_classes, sol::bases<nbunny::SceneNode>(),
		sol::call_constructor, sol::factories(&nbunny_scene_node_create<nbunny::LightSceneNode>),
		"setCurrentColor", &nbunny_light_scene_node_set_current_color,
		"getCurrentColor", &nbunny_light_scene_node_get_current_color,
		"setPreviousColor", &nbunny_light_scene_node_set_previous_color,
		"getPreviousColor", &nbunny_light_scene_node_get_previous_color,
		"setIsGlobal", &nbunny::LightSceneNode::set_is_global,
		"getIsGlobal", &nbunny::LightSceneNode::get_is_global,
		"tick", &nbunny::LightSceneNode::tick);

	sol::stack::push(L, T);

	return 1;
}

const nbunny::Type<nbunny::AmbientLightSceneNode> nbunny::AmbientLightSceneNode::type_pointer;

const nbunny::BaseType& nbunny::AmbientLightSceneNode::get_type() const
{
	return type_pointer;
}

nbunny::AmbientLightSceneNode::AmbientLightSceneNode(int reference) :
	LightSceneNode(reference)
{
	// Nothing.
}

void nbunny::AmbientLightSceneNode::set_current_ambience(float value)
{
	current_ambience = value;
}

float nbunny::AmbientLightSceneNode::get_current_ambience() const
{
	return current_ambience;
}

void nbunny::AmbientLightSceneNode::set_previous_ambience(float value)
{
	previous_ambience = value;
}

float nbunny::AmbientLightSceneNode::get_previous_ambience() const
{
	return previous_ambience;
}

void nbunny::AmbientLightSceneNode::to_light(Light& light, float delta) const
{
	LightSceneNode::to_light(light, delta);
	light.ambient_coefficient = glm::mix(
		current_ambience,
		get_ticked() ? previous_ambience : current_ambience,
		delta);
}

void nbunny::AmbientLightSceneNode::tick()
{
	LightSceneNode::tick();
	previous_ambience = current_ambience;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_ambientlightscenenode(lua_State* L)
{
	sol::usertype<nbunny::AmbientLightSceneNode> T(
		sol::base_classes, sol::bases<nbunny::LightSceneNode, nbunny::SceneNode>(),
		sol::call_constructor, sol::factories(&nbunny_scene_node_create<nbunny::AmbientLightSceneNode>),
		"setCurrentAmbience", &nbunny::AmbientLightSceneNode::set_current_ambience,
		"getCurrentAmbience", &nbunny::AmbientLightSceneNode::get_current_ambience,
		"setPreviousAmbience", &nbunny::AmbientLightSceneNode::set_previous_ambience,
		"getPreviousAmbience", &nbunny::AmbientLightSceneNode::get_previous_ambience,
		"tick", &nbunny::AmbientLightSceneNode::tick);

	sol::stack::push(L, T);

	return 1;
}

const nbunny::Type<nbunny::DirectionalLightSceneNode> nbunny::DirectionalLightSceneNode::type_pointer;

const nbunny::BaseType& nbunny::DirectionalLightSceneNode::get_type() const
{
	return type_pointer;
}

nbunny::DirectionalLightSceneNode::DirectionalLightSceneNode(int reference) :
	LightSceneNode(reference)
{
	// Nothing.
}

void nbunny::DirectionalLightSceneNode::set_current_direction(const glm::vec3& value)
{
	current_direction = value;
}

const glm::vec3& nbunny::DirectionalLightSceneNode::get_current_direction() const
{
	return current_direction;
}

void nbunny::DirectionalLightSceneNode::set_previous_direction(const glm::vec3& value)
{
	previous_direction = value;
}

const glm::vec3& nbunny::DirectionalLightSceneNode::get_previous_direction() const
{
	return previous_direction;
}

void nbunny::DirectionalLightSceneNode::to_light(Light& light, float delta) const
{
	LightSceneNode::to_light(light, delta);
	light.position = glm::vec4(
		glm::mix(
			current_direction,
			get_ticked() ? previous_direction : current_direction,
			delta),
		1.0f);
}

void nbunny::DirectionalLightSceneNode::tick()
{
	LightSceneNode::tick();
	previous_direction = current_direction;
}

static int nbunny_directional_light_scene_node_set_current_direction(lua_State* L)
{
	auto node = sol::stack::get<nbunny::DirectionalLightSceneNode*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	node->set_current_direction(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_directional_light_scene_node_get_current_direction(lua_State* L)
{
	auto node = sol::stack::get<nbunny::DirectionalLightSceneNode*>(L, 1);
	const auto& direction = node->get_current_direction();
	lua_pushnumber(L, direction.x);
	lua_pushnumber(L, direction.y);
	lua_pushnumber(L, direction.z);
	return 3;
}

static int nbunny_directional_light_scene_node_set_previous_direction(lua_State* L)
{
	auto node = sol::stack::get<nbunny::DirectionalLightSceneNode*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	node->set_previous_direction(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_directional_light_scene_node_get_previous_direction(lua_State* L)
{
	auto node = sol::stack::get<nbunny::DirectionalLightSceneNode*>(L, 1);
	const auto& direction = node->get_previous_direction();
	lua_pushnumber(L, direction.x);
	lua_pushnumber(L, direction.y);
	lua_pushnumber(L, direction.z);
	return 3;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_directionallightscenenode(lua_State* L)
{
	sol::usertype<nbunny::DirectionalLightSceneNode> T(
		sol::base_classes, sol::bases<nbunny::LightSceneNode, nbunny::SceneNode>(),
		sol::call_constructor, sol::factories(&nbunny_scene_node_create<nbunny::DirectionalLightSceneNode>),
		"setCurrentDirection", &nbunny_directional_light_scene_node_set_current_direction,
		"getCurrentDirection", &nbunny_directional_light_scene_node_get_current_direction,
		"setPreviousDirection", &nbunny_directional_light_scene_node_set_previous_direction,
		"getPreviousDirection", &nbunny_directional_light_scene_node_get_previous_direction,
		"tick", &nbunny::LightSceneNode::tick);

	sol::stack::push(L, T);

	return 1;
}

const nbunny::Type<nbunny::PointLightSceneNode> nbunny::PointLightSceneNode::type_pointer;

const nbunny::BaseType& nbunny::PointLightSceneNode::get_type() const
{
	return type_pointer;
}

nbunny::PointLightSceneNode::PointLightSceneNode(int reference) :
	LightSceneNode(reference)
{
	// Nothing.
}

void nbunny::PointLightSceneNode::set_current_attenuation(float value)
{
	current_attenuation = value;
}

float nbunny::PointLightSceneNode::get_current_attenuation() const
{
	return current_attenuation;
}

void nbunny::PointLightSceneNode::set_previous_attenuation(float value)
{
	previous_attenuation = value;
}

float nbunny::PointLightSceneNode::get_previous_attenuation() const
{
	return previous_attenuation;
}

void nbunny::PointLightSceneNode::to_light(Light& light, float delta) const
{
	LightSceneNode::to_light(light, delta);
	light.attenuation = glm::mix(
		current_attenuation,
		get_ticked() ? previous_attenuation : current_attenuation,
		delta);
}

void nbunny::PointLightSceneNode::tick()
{
	LightSceneNode::tick();
	previous_attenuation = current_attenuation;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_pointlightscenenode(lua_State* L)
{
	sol::usertype<nbunny::PointLightSceneNode> T(
		sol::base_classes, sol::bases<nbunny::LightSceneNode, nbunny::SceneNode>(),
		sol::call_constructor, sol::factories(&nbunny_scene_node_create<nbunny::PointLightSceneNode>),
		"setCurrentAttenuation", &nbunny::PointLightSceneNode::set_current_attenuation,
		"getCurrentAttenuation", &nbunny::PointLightSceneNode::get_current_attenuation,
		"setPreviousAttenuation", &nbunny::PointLightSceneNode::set_previous_attenuation,
		"getPreviousAttenuation", &nbunny::PointLightSceneNode::get_previous_attenuation,
		"tick", &nbunny::PointLightSceneNode::tick);

	sol::stack::push(L, T);

	return 1;
}
