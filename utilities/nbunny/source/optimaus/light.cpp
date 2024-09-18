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
#include "nbunny/lua_runtime.hpp"

const nbunny::Type<nbunny::LightSceneNode> nbunny::LightSceneNode::type_pointer;

const nbunny::BaseType& nbunny::LightSceneNode::get_type() const
{
	return type_pointer;
}

nbunny::LightSceneNode::LightSceneNode(int reference) :
	SceneNode(reference)
{
	get_material().set_is_cull_disabled(true);
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

void nbunny::LightSceneNode::set_casts_shadows(bool value)
{
	casts_shadows = value;
}

bool nbunny::LightSceneNode::get_casts_shadows() const
{
	return casts_shadows;
}

void nbunny::LightSceneNode::to_light(Light& light, float delta) const
{
	light.color = glm::mix(
		get_ticked() ? previous_color : current_color,
		current_color,
		delta);
}

void nbunny::LightSceneNode::tick(float delta)
{
	SceneNode::tick(delta);

	previous_color = glm::mix(
		get_ticked() ? previous_color : current_color,
		current_color,
		delta);
}

static int nbunny_light_scene_node_set_current_color(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::LightSceneNode*>(L, 1);
	float r = (float)luaL_checknumber(L, 2);
	float g = (float)luaL_checknumber(L, 3);
	float b = (float)luaL_checknumber(L, 4);
	node->set_current_color(glm::vec3(r, g, b));
	return 0;
}

static int nbunny_light_scene_node_get_current_color(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::LightSceneNode*>(L, 1);
	const auto& color = node->get_current_color();
	lua_pushnumber(L, color.x);
	lua_pushnumber(L, color.y);
	lua_pushnumber(L, color.z);
	return 3;
}

static int nbunny_light_scene_node_set_previous_color(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::LightSceneNode*>(L, 1);
	float r = (float)luaL_checknumber(L, 2);
	float g = (float)luaL_checknumber(L, 3);
	float b = (float)luaL_checknumber(L, 4);
	node->set_previous_color(glm::vec3(r, g, b));
	return 0;
}

static int nbunny_light_scene_node_get_previous_color(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::LightSceneNode*>(L, 1);
	const auto& color = node->get_previous_color();
	lua_pushnumber(L, color.x);
	lua_pushnumber(L, color.y);
	lua_pushnumber(L, color.z);
	return 3;
}

static int nbunny_light_scene_node_set_is_global(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::LightSceneNode*>(L, 1);
	auto value = nbunny::lua::get<bool>(L, 2);
	node->set_is_global(value);
	return 0;
}

static int nbunny_light_scene_node_get_is_global(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::LightSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_is_global());
	return 1;
}

static int nbunny_light_scene_node_set_casts_shadows(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::LightSceneNode*>(L, 1);
	auto value = nbunny::lua::get<bool>(L, 2);
	node->set_casts_shadows(value);
	return 0;
}

static int nbunny_light_scene_node_get_casts_shadows(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::LightSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_casts_shadows());
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_lightscenenode(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "setCurrentColor", &nbunny_light_scene_node_set_current_color },
		{ "getCurrentColor", &nbunny_light_scene_node_get_current_color },
		{ "setPreviousColor", &nbunny_light_scene_node_set_previous_color },
		{ "getPreviousColor", &nbunny_light_scene_node_get_previous_color },
		{ "setIsGlobal", &nbunny_light_scene_node_set_is_global },
		{ "getIsGlobal", &nbunny_light_scene_node_get_is_global },
		{ "setCastsShadows", &nbunny_light_scene_node_set_casts_shadows },
		{ "getCastsShadows", &nbunny_light_scene_node_get_casts_shadows },
	};

	nbunny::lua::register_child_type<nbunny::LightSceneNode, nbunny::SceneNode>(L, &nbunny_scene_node_constructor<nbunny::LightSceneNode>, metatable);

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
		get_ticked() ? previous_ambience : current_ambience,
		current_ambience,
		delta);
	light.diffuse_coefficient = 0.0f;
}

void nbunny::AmbientLightSceneNode::tick(float delta)
{
	LightSceneNode::tick(delta);
	previous_ambience = glm::mix(
		get_ticked() ? previous_ambience : current_ambience,
		current_ambience,
		delta);;
}

static int nbunny_ambient_light_scene_node_set_current_ambience(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::AmbientLightSceneNode*>(L, 1);
	auto value = nbunny::lua::get<lua_Number>(L, 2);
	node->set_current_ambience(value);
	return 0;
}

static int nbunny_ambient_light_scene_node_get_current_ambience(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::AmbientLightSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_current_ambience());
	return 1;
}

static int nbunny_ambient_light_scene_node_set_previous_ambience(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::AmbientLightSceneNode*>(L, 1);
	auto value = nbunny::lua::get<lua_Number>(L, 2);
	node->set_previous_ambience(value);
	return 0;
}

static int nbunny_ambient_light_scene_node_get_previous_ambience(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::AmbientLightSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_previous_ambience());
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_ambientlightscenenode(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "setCurrentAmbience", &nbunny_ambient_light_scene_node_set_current_ambience },
		{ "getCurrentAmbience", &nbunny_ambient_light_scene_node_get_current_ambience },
		{ "setPreviousAmbience", &nbunny_ambient_light_scene_node_set_previous_ambience },
		{ "getPreviousAmbience", &nbunny_ambient_light_scene_node_get_previous_ambience },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_child_type<nbunny::AmbientLightSceneNode, nbunny::LightSceneNode>(L, &nbunny_scene_node_constructor<nbunny::AmbientLightSceneNode>, metatable);

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
			get_ticked() ? previous_direction : current_direction,
			current_direction,
			delta),
		1.0f);
}

void nbunny::DirectionalLightSceneNode::tick(float delta)
{
	LightSceneNode::tick(delta);
	previous_direction = glm::mix(
		get_ticked() ? previous_direction : current_direction,
		current_direction,
		delta);
}

static int nbunny_directional_light_scene_node_set_current_direction(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::DirectionalLightSceneNode*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	node->set_current_direction(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_directional_light_scene_node_get_current_direction(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::DirectionalLightSceneNode*>(L, 1);
	const auto& direction = node->get_current_direction();
	lua_pushnumber(L, direction.x);
	lua_pushnumber(L, direction.y);
	lua_pushnumber(L, direction.z);
	return 3;
}

static int nbunny_directional_light_scene_node_set_previous_direction(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::DirectionalLightSceneNode*>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	node->set_previous_direction(glm::vec3(x, y, z));
	return 0;
}

static int nbunny_directional_light_scene_node_get_previous_direction(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::DirectionalLightSceneNode*>(L, 1);
	const auto& direction = node->get_previous_direction();
	lua_pushnumber(L, direction.x);
	lua_pushnumber(L, direction.y);
	lua_pushnumber(L, direction.z);
	return 3;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_directionallightscenenode(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "setCurrentDirection", &nbunny_directional_light_scene_node_set_current_direction },
		{ "getCurrentDirection", &nbunny_directional_light_scene_node_get_current_direction },
		{ "setPreviousDirection", &nbunny_directional_light_scene_node_set_previous_direction },
		{ "getPreviousDirection", &nbunny_directional_light_scene_node_get_previous_direction },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_child_type<nbunny::DirectionalLightSceneNode, nbunny::LightSceneNode>(L, &nbunny_scene_node_constructor<nbunny::DirectionalLightSceneNode>, metatable);

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
	auto world = get_transform().get_global(delta);
	auto position = world * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f);

	LightSceneNode::to_light(light, delta);
	light.position = glm::vec4(glm::vec3(position), 0.0f);
	light.attenuation = glm::mix(
		get_ticked() ? previous_attenuation : current_attenuation,
		current_attenuation,
		delta);
}

void nbunny::PointLightSceneNode::tick(float delta)
{
	LightSceneNode::tick(delta);
	previous_attenuation = glm::mix(
		get_ticked() ? previous_attenuation : current_attenuation,
		current_attenuation,
		delta);;
}

static int nbunny_point_light_scene_node_set_current_attenuation(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::PointLightSceneNode*>(L, 1);
	auto value = nbunny::lua::get<lua_Number>(L, 2);
	node->set_current_attenuation(value);
	return 0;
}

static int nbunny_point_light_scene_node_get_current_attenuation(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::PointLightSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_current_attenuation());
	return 1;
}

static int nbunny_point_light_scene_node_set_previous_attenuation(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::PointLightSceneNode*>(L, 1);
	auto value = nbunny::lua::get<lua_Number>(L, 2);
	node->set_previous_attenuation(value);
	return 0;
}

static int nbunny_point_light_scene_node_get_previous_attenuation(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::PointLightSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_previous_attenuation());
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_pointlightscenenode(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "setCurrentAttenuation", &nbunny_point_light_scene_node_set_current_attenuation },
		{ "getCurrentAttenuation", &nbunny_point_light_scene_node_get_current_attenuation },
		{ "setPreviousAttenuation", &nbunny_point_light_scene_node_set_previous_attenuation },
		{ "getPreviousAttenuation", &nbunny_point_light_scene_node_get_previous_attenuation },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_child_type<nbunny::PointLightSceneNode, nbunny::LightSceneNode>(L, &nbunny_scene_node_constructor<nbunny::PointLightSceneNode>, metatable);

	return 1;
}

const nbunny::Type<nbunny::FogSceneNode> nbunny::FogSceneNode::type_pointer;

const nbunny::BaseType& nbunny::FogSceneNode::get_type() const
{
	return type_pointer;
}

nbunny::FogSceneNode::FogSceneNode(int reference) :
	LightSceneNode(reference)
{
	set_is_global(true);
}

void nbunny::FogSceneNode::set_current_near_distance(float value)
{
	current_near_distance = value;
}

float nbunny::FogSceneNode::get_current_near_distance() const
{
	return current_near_distance;
}

void nbunny::FogSceneNode::set_previous_near_distance(float value)
{
	previous_near_distance = value;
}

float nbunny::FogSceneNode::get_previous_near_distance() const
{
	return previous_near_distance;
}

void nbunny::FogSceneNode::set_current_far_distance(float value)
{
	current_far_distance = value;
}

float nbunny::FogSceneNode::get_current_far_distance() const
{
	return current_far_distance;
}

void nbunny::FogSceneNode::set_previous_far_distance(float value)
{
	previous_far_distance = value;
}

float nbunny::FogSceneNode::get_previous_far_distance() const
{
	return previous_far_distance;
}

void nbunny::FogSceneNode::set_follow_mode(FollowMode value)
{
	follow_mode = value;
}

nbunny::FogSceneNode::FollowMode nbunny::FogSceneNode::get_follow_mode() const
{
	return follow_mode;
}

void nbunny::FogSceneNode::to_light(Light& light, float delta) const
{
	LightSceneNode::to_light(light, delta);

	auto transform = get_transform().get_global(delta);
	auto position = transform * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f);

	light.position = glm::vec4(glm::vec3(position), 1.0f);

	light.near_distance = glm::mix(
		get_ticked() ? previous_near_distance : current_near_distance,
		current_near_distance,
		delta);

	light.far_distance = glm::mix(
		get_ticked() ? previous_far_distance : current_far_distance,
		current_far_distance,
		delta);
}

void nbunny::FogSceneNode::tick(float delta)
{
	LightSceneNode::tick(delta);

	previous_near_distance = glm::mix(
		get_ticked() ? previous_near_distance : current_near_distance,
		current_near_distance,
		delta);;
	previous_far_distance = glm::mix(
		get_ticked() ? previous_far_distance : current_far_distance,
		current_far_distance,
		delta);;
}

static int nbunny_fog_scene_node_set_current_near_distance(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::FogSceneNode*>(L, 1);
	auto value = nbunny::lua::get<lua_Number>(L, 2);
	node->set_current_near_distance(value);
	return 0;
}

static int nbunny_fog_scene_node_get_current_near_distance(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::FogSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_current_near_distance());
	return 1;
}

static int nbunny_fog_scene_node_set_previous_near_distance(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::FogSceneNode*>(L, 1);
	auto value = nbunny::lua::get<lua_Number>(L, 2);
	node->set_previous_near_distance(value);
	return 0;
}

static int nbunny_fog_scene_node_get_previous_near_distance(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::FogSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_previous_near_distance());
	return 1;
}

static int nbunny_fog_scene_node_set_current_far_distance(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::FogSceneNode*>(L, 1);
	auto value = nbunny::lua::get<lua_Number>(L, 2);
	node->set_current_far_distance(value);
	return 0;
}

static int nbunny_fog_scene_node_get_current_far_distance(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::FogSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_current_far_distance());
	return 1;
}

static int nbunny_fog_scene_node_set_previous_far_distance(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::FogSceneNode*>(L, 1);
	auto value = nbunny::lua::get<lua_Number>(L, 2);
	node->set_previous_far_distance(value);
	return 0;
}

static int nbunny_fog_scene_node_get_previous_far_distance(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::FogSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_previous_far_distance());
	return 1;
}

static int nbunny_fog_scene_node_set_follow_mode(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::FogSceneNode*>(L, 1);
	auto value = nbunny::lua::get<lua_Integer>(L, 2);
	node->set_follow_mode((nbunny::FogSceneNode::FollowMode)value);
	return 0;
}

static int nbunny_fog_scene_node_get_follow_mode(lua_State* L)
{
	auto node = nbunny::lua::get<nbunny::FogSceneNode*>(L, 1);
	nbunny::lua::push(L, node->get_follow_mode());
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_scenenode_fogscenenode(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "setCurrentNearDistance", &nbunny_fog_scene_node_set_current_near_distance },
		{ "getCurrentNearDistance", &nbunny_fog_scene_node_get_current_near_distance },
		{ "setPreviousNearDistance", &nbunny_fog_scene_node_set_previous_near_distance },
		{ "getPreviousNearDistance", &nbunny_fog_scene_node_get_previous_near_distance },
		{ "setCurrentFarDistance", &nbunny_fog_scene_node_set_current_far_distance },
		{ "getCurrentFarDistance", &nbunny_fog_scene_node_get_current_far_distance },
		{ "setPreviousFarDistance", &nbunny_fog_scene_node_set_previous_far_distance },
		{ "getPreviousFarDistance", &nbunny_fog_scene_node_get_previous_far_distance },
		{ "setFollowMode", &nbunny_fog_scene_node_set_follow_mode },
		{ "getFollowMode", &nbunny_fog_scene_node_get_follow_mode },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_child_type<nbunny::FogSceneNode, nbunny::LightSceneNode>(L, &nbunny_scene_node_constructor<nbunny::FogSceneNode>, metatable);

	return 1;
}
