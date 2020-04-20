////////////////////////////////////////////////////////////////////////////////
// source/scene.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <limits>
#include <unordered_map>
#include <glm/gtc/matrix_transform.hpp>
#include "nbunny/nbunny.hpp"
#include "nbunny/scene.hpp"

void nbunny::SceneNodeTransform::tick()
{
	previousScale = currentScale;
	previousRotation = currentRotation;
	previousTranslation = currentTranslation;
	previousOffset = currentOffset;
	ticked = true;
}

glm::mat4 nbunny::SceneNodeTransform::get_local(float delta)
{
	auto pS = ticked ? previousScale : currentScale;
	auto pR = ticked ? previousRotation : currentRotation;
	auto pT = ticked ? previousTranslation : currentTranslation;
	auto pO = ticked ? previousOffset : currentOffset;
	auto cS = currentScale;
	auto cR = currentRotation;
	auto cT = currentTranslation;
	auto cO = currentOffset;

	auto rotation = glm::slerp(pR, cR, delta);
	auto scale = glm::mix(pS, cS, delta);
	auto translation = glm::mix(pT, cT, delta);
	auto offset = glm::mix(pO, cO, delta);

	auto r = glm::toMat4(rotation);
	auto s = glm::scale(glm::mat4(1), scale);
	auto t = glm::translate(glm::mat4(1), translation);
	auto oF = glm::translate(glm::mat4(1), -offset);
	auto oT = glm::translate(glm::mat4(1), offset);

	auto result = oT * t * s * r * oF;
	return result;
}

glm::mat4 nbunny::SceneNodeTransform::get_global(float delta)
{
	auto localTransform = get_local(delta);

	auto p = parent.lock();
	if (p)
	{
		auto parentTransform = p->get_global(delta);

		return parentTransform * localTransform;
	}

	return localTransform;
}

bool nbunny::SceneNodeMaterial::operator <(const SceneNodeMaterial& other) const
{
	if (shader < other.shader)
	{
		return true;
	}
	else if (shader == other.shader)
	{
		if (textures.size() < other.textures.size())
		{
			return true;
		}
		else if (textures.size() > other.textures.size())
		{
			return false;
		}

		for (auto i = 0; i < textures.size(); ++i)
		{
			if (textures[i] < other.textures[i])
			{
				return true;
			}
			else if (textures[i] > other.textures[i])
			{
				return false;
			}
		}
	}

	return false;
}

void nbunny::SceneNode::walk_by_material(
	const std::shared_ptr<SceneNode>& node,
	const Camera& camera,
	float delta,
	std::vector<std::shared_ptr<SceneNode>>& result)
{
	if (!camera.enable_cull || camera.inside(*node.get(), delta))
	{
		result.push_back(node);
	}

	for (auto& child: node->children)
	{
		auto c = child.lock();
		c->walk_by_material(c, camera, delta, result);
	}

	auto parent = node->parent.lock();
	if (!parent)
	{
		std::stable_sort(
			result.begin(),
			result.end(),
			[&](const auto& a, const auto& b)
			{
				return a->material < b->material;
			}
		);
	}
}

void nbunny::SceneNode::walk_by_position(
	const std::shared_ptr<SceneNode>& node,
	const Camera& camera,
	float delta,
	std::vector<std::shared_ptr<SceneNode>>& result)
{
	if (!camera.enable_cull || camera.inside(*node.get(), delta))
	{
		result.push_back(node);
	}

	for (auto& child : node->children)
	{
		auto c = child.lock();
		c->walk_by_position(c, camera, delta, result);
	}

	auto parent = node->parent.lock();
	if (!parent)
	{
		std::unordered_map<SceneNode*, glm::vec3> screen_positions;
		std::stable_sort(
			result.begin(),
			result.end(),
			[&](const auto& a, const auto& b)
			{
				auto aScreenPosition = screen_positions.find(a.get());
				if (aScreenPosition == screen_positions.end())
				{
					auto world = glm::vec3(b->transform->get_global(delta) * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f));
					auto p = glm::project(
						world,
						camera.view,
						camera.projection,
						glm::vec4(0.0f, 0.0f, 1.0f, 1.0f)
					);
					aScreenPosition = screen_positions.insert(std::make_pair(a.get(), p)).first;
				}

				auto bScreenPosition = screen_positions.find(b.get());
				if (bScreenPosition == screen_positions.end())
				{
					auto world = glm::vec3(a->transform->get_global(delta) * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f));
					auto p = glm::project(
						world,
						camera.view,
						camera.projection,
						glm::vec4(0.0f, 0.0f, 1.0f, 1.0f)
					);
					bScreenPosition = screen_positions.insert(std::make_pair(b.get(), p)).first;
				}

				return glm::floor(aScreenPosition->second.z * 1000) < glm::floor(bScreenPosition->second.z);
			}
		);
	}
}

static glm::vec3 get_positive_vertex(
	const glm::vec3& min,
	const glm::vec3& max,
	const glm::vec3& normal)
{
	glm::vec3 result = max;

	if (normal.x >= 0)
	{
		result.x = max.x;
	}

	if (normal.y >= 0)
	{
		result.y = max.y;
	}

	if (normal.z >= 0)
	{
		result.z = max.z;
	}

	return result;
}

static glm::vec3 get_negative_vertex(
	const glm::vec3& min,
	const glm::vec3& max,
	const glm::vec3& normal)
{
	glm::vec3 result = max;

	if (normal.x <= 0)
	{
		result.x = min.x;
	}

	if (normal.y <= 0)
	{
		result.y = min.y;
	}

	if (normal.z <= 0)
	{
		result.z = min.z;
	}

	return result;
}

bool nbunny::Camera::inside(const SceneNode& node, float delta) const
{
	auto transform = node.transform->get_global(delta);

	auto min = node.min;
	auto max = node.max;

	const int NUM_CORNERS = 8;
	glm::vec3 corners[NUM_CORNERS] =
	{
		glm::vec3(min.x, min.y, min.z),
		glm::vec3(max.x, min.y, min.z),
		glm::vec3(min.x, max.y, min.z),
		glm::vec3(min.x, min.y, max.z),
		glm::vec3(max.x, max.y, min.z),
		glm::vec3(max.x, min.y, max.z),
		glm::vec3(min.x, max.y, max.z),
		glm::vec3(max.x, max.y, max.z)
	};

	min = glm::vec3(std::numeric_limits<float>::infinity());
	max = glm::vec3(-std::numeric_limits<float>::infinity());
	for (int i = 0; i < NUM_CORNERS; ++i)
	{
		auto p = glm::vec3(transform * glm::vec4(corners[i], 1.0f));
		min = glm::min(min, p);
		max = glm::max(max, p);
	}

	compute_planes();

#if 0
	if ((min.x <= maxFrustum.x && max.x >= minFrustum.x) &&
		(min.y <= maxFrustum.y && max.y >= minFrustum.y) &&
		(min.z <= maxFrustum.z && max.z >= minFrustum.z))
	{
		return true;
	}

	return false;
#else
	for (int i = 0; i < NUM_PLANES; ++i)
	{
		auto plane = planes[i];
		auto normal = glm::vec3(plane);

		auto vertex = get_negative_vertex(min, max, normal);

		float dot = glm::dot(vertex, normal) + plane.w;
		if (dot < 0.0f)
		{
			return false;
		}
	}

	return true;
#endif
}

void nbunny::Camera::compute_planes() const
{
	if (!is_dirty)
	{
		return;
	}

	auto projectionView = projection * view;
	auto m = glm::value_ptr(projectionView);

#define M(i, j) m[(j - 1) * 4 + (i - 1)]
	// left
	planes[0].x = M(1, 1) + M(4, 1);
	planes[0].y = M(1, 2) + M(4, 2);
	planes[0].z = M(1, 3) + M(4, 3);
	planes[0].w = M(1, 4) + M(4, 4);
	float leftLengthInverse = 1.0f / glm::length(glm::vec3(planes[0]));
	planes[0] *= leftLengthInverse;

	// right
	planes[1].x = -M(1, 1) + M(4, 1);
	planes[1].y = -M(1, 2) + M(4, 2);
	planes[1].z = -M(1, 3) + M(4, 3);
	planes[1].w = -M(1, 4) + M(4, 4);
	float rightLengthInverse = 1.0f / glm::length(glm::vec3(planes[1]));
	planes[1] *= rightLengthInverse;

	// top
	planes[2].x = -M(2, 1) + M(4, 1);
	planes[2].y = -M(2, 2) + M(4, 2);
	planes[2].z = -M(2, 3) + M(4, 3);
	planes[2].w = -M(2, 4) + M(4, 4);
	float topLengthInverse = 1.0f / glm::length(glm::vec3(planes[2]));
	planes[2] *= topLengthInverse;

	// bottom
	planes[3].x = M(2, 1) + M(4, 1);
	planes[3].y = M(2, 2) + M(4, 2);
	planes[3].z = M(2, 3) + M(4, 3);
	planes[3].w = M(2, 4) + M(4, 4);
	float bottomLengthInverse = 1.0f / glm::length(glm::vec3(planes[3]));
	planes[3] *= bottomLengthInverse;

	// near
	planes[4].x = M(3, 1) + M(4, 1);
	planes[4].y = M(3, 2) + M(4, 2);
	planes[4].z = M(3, 3) + M(4, 3);
	planes[4].w = M(3, 4) + M(4, 4);
	float nearLengthInverse = 1.0f / glm::length(glm::vec3(planes[4]));
	planes[4] *= nearLengthInverse;

	// far
	planes[5].x = -M(3, 1) + M(4, 1);
	planes[5].y = -M(3, 2) + M(4, 2);
	planes[5].z = -M(3, 3) + M(4, 3);
	planes[5].w = -M(3, 4) + M(4, 4);
	float farLengthInverse = 1.0f / glm::length(glm::vec3(planes[5]));
	planes[5] *= farLengthInverse;
#undef M

	auto inverseViewProjection = glm::inverse(projectionView);

	glm::vec4 corners[NUM_POINTS] =
	{
		inverseViewProjection * glm::vec4(-1, -1, -1, 1),
		inverseViewProjection * glm::vec4( 1, -1, -1, 1),
		inverseViewProjection * glm::vec4(-1,  1, -1, 1),
		inverseViewProjection * glm::vec4(-1, -1,  1, 1),
		inverseViewProjection * glm::vec4( 1,  1, -1, 1),
		inverseViewProjection * glm::vec4( 1, -1,  1, 1),
		inverseViewProjection * glm::vec4(-1,  1,  1, 1),
		inverseViewProjection * glm::vec4( 1,  1,  1, 1)
	};

	auto min = glm::vec3(std::numeric_limits<float>::infinity());
	auto max = glm::vec3(-std::numeric_limits<float>::infinity());
	for (int i = 0; i < NUM_POINTS; ++i)
	{
		auto p = glm::vec3(corners[i]) / corners[i].w;
		min = glm::min(min, p);
		max = glm::max(max, p);
	}

	minFrustum = min;
	maxFrustum = max;

	is_dirty = false;
}

typedef std::shared_ptr<nbunny::SceneNode> SceneNodePointer;

const static int SCENE_NODE_REFERENCE_KEY = 0;
static void get_scene_node_reference_table(lua_State* L)
{
	lua_pushlightuserdata(L, const_cast<int*>(&SCENE_NODE_REFERENCE_KEY));
	lua_rawget(L, LUA_REGISTRYINDEX);

	if (lua_isnil(L, -1)) {
		lua_pop(L, 1);
		lua_pushlightuserdata(L, const_cast<int*>(&SCENE_NODE_REFERENCE_KEY));
		lua_newtable(L);

		// Create metatable with 'weak values'.
		lua_newtable(L);
		lua_pushstring(L, "__mode");
		lua_pushstring(L, "v");
		lua_rawset(L, -3);

		// Assign metatable.
		lua_setmetatable(L, -2);

		// Assign table to registory.
		lua_rawset(L, LUA_REGISTRYINDEX);

		// Retrieve table again.
		lua_pushlightuserdata(L, const_cast<int*>(&SCENE_NODE_REFERENCE_KEY));
		lua_rawget(L, LUA_REGISTRYINDEX);
	}
}

static void get_scene_node_reference(lua_State* L, int key)
{
	get_scene_node_reference_table(L);
	lua_rawgeti(L, -1, key);
	lua_remove(L, -2);
}

static int set_scene_node_reference(lua_State* L)
{
	get_scene_node_reference_table(L);
	lua_pushvalue(L, -2);
	return luaL_ref(L, -2);
}

static SceneNodePointer nbunny_scene_node_create(sol::object reference, sol::this_state S)
{
	auto result = std::make_shared<nbunny::SceneNode>();

	lua_State* L = S;
	result->reference = set_scene_node_reference(L);

	return result;
}

static int nbunny_scene_node_set_parent(lua_State* L)
{
	auto& node = sol::stack::get<SceneNodePointer>(L, 1);
	auto oldParent = node->parent.lock();
	if (oldParent)
	{
		oldParent->children.erase(
			std::remove_if(
				oldParent->children.begin(),
				oldParent->children.end(),
				[&node](auto& a)
				{
					return !(node.owner_before(a) || a.owner_before(node));
				}
			),
			oldParent->children.end()
		);

		node->parent.reset();
		node->transform->parent.reset();
	}

	if (!lua_isnil(L, 2) && (lua_isboolean(L, 2) || lua_toboolean(L, 2)))
	{
		auto parent = sol::stack::get<SceneNodePointer>(L, 2);
		node->parent = parent;
		parent->children.push_back(node);

		node->transform->parent = parent->transform;
	}

	return 0;
}

static int nbunny_scene_node_get_parent(lua_State* L)
{
	auto& self = sol::stack::get<SceneNodePointer>(L, 1);
	auto parent = self->parent.lock();
	if (!parent)
	{
		lua_pushnil(L);
	}
	else
	{
		sol::stack::push(L, parent);
	}

	return 1;
}

std::shared_ptr<nbunny::SceneNodeTransform> nbunny_scene_node_get_transform(nbunny::SceneNode& self)
{
	return self.transform;
}

nbunny::SceneNodeMaterial& nbunny_scene_node_get_material(nbunny::SceneNode& self)
{
	return self.material;
}

static sol::object nbunny_scene_node_get_reference(nbunny::SceneNode& self, sol::this_state S)
{
	lua_State* L = S;
	get_scene_node_reference(L, self.reference);
	return sol::stack::pop<sol::object>(L);
}

static int nbunny_scene_node_get_min(lua_State* L)
{
	auto& self = sol::stack::get<SceneNodePointer>(L, 1);
	lua_pushnumber(L, self->min.x);
	lua_pushnumber(L, self->min.y);
	lua_pushnumber(L, self->min.z);
	return 3;
}

static int nbunny_scene_node_set_min(lua_State* L)
{
	auto& self = sol::stack::get<SceneNodePointer>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	self->min = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_scene_node_get_max(lua_State* L)
{
	auto& self = sol::stack::get<SceneNodePointer>(L, 1);
	lua_pushnumber(L, self->max.x);
	lua_pushnumber(L, self->max.y);
	lua_pushnumber(L, self->max.z);
	return 3;
}

static int nbunny_scene_node_set_max(lua_State* L)
{
	auto& self = sol::stack::get<SceneNodePointer>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	self->max = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_scene_node_walk_by_material(lua_State* L)
{
	auto& self = sol::stack::get<SceneNodePointer>(L, 1);
	auto& camera = sol::stack::get<nbunny::Camera>(L, 2);
	float delta = (float)luaL_checknumber(L, 3);

	std::vector<SceneNodePointer> result;
	nbunny::SceneNode::walk_by_material(self, camera, delta, result);

	lua_createtable(L, (int)result.size(), 0);

	int index = 1;
	for (std::size_t i = 0; i < result.size(); ++i)
	{
		lua_pushinteger(L, index);

		get_scene_node_reference(L, result[i]->reference);
		if (!lua_isnil(L, -1))
		{
			++index;
		}

		lua_rawset(L, -3);
	}

	return 1;
}

static int nbunny_scene_node_walk_by_position(lua_State* L)
{
	auto& self = sol::stack::get<SceneNodePointer>(L, 1);
	auto& camera = sol::stack::get<nbunny::Camera>(L, 2);
	float delta = (float)luaL_checknumber(L, 3);

	std::vector<SceneNodePointer> result;
	nbunny::SceneNode::walk_by_position(self, camera, delta, result);

	lua_createtable(L, (int)result.size(), 0);

	int index = 1;
	for (std::size_t i = 0; i < result.size(); ++i)
	{
		lua_pushinteger(L, index);

		get_scene_node_reference(L, result[i]->reference);
		if (!lua_isnil(L, -1))
		{
			++index;
		}

		lua_rawset(L, -3);
	}

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_scenenode(lua_State* L)
{
	sol::usertype<nbunny::SceneNode> T(
		sol::call_constructor, sol::factories(&nbunny_scene_node_create),
		"getParent", &nbunny_scene_node_get_parent,
		"setParent", &nbunny_scene_node_set_parent,
		"getTransform", &nbunny_scene_node_get_transform,
		"getMaterial", &nbunny_scene_node_get_material,
		"getReference", &nbunny_scene_node_get_reference,
		"getMin", &nbunny_scene_node_get_min,
		"setMin", &nbunny_scene_node_set_min,
		"getMax", &nbunny_scene_node_get_max,
		"setMax", &nbunny_scene_node_set_max,
		"walkByMaterial", &nbunny_scene_node_walk_by_material,
		"walkByPosition", &nbunny_scene_node_walk_by_position);

	sol::stack::push(L, T);

	return 1;
}

typedef std::shared_ptr<nbunny::SceneNodeTransform> SceneNodeTransformPointer;

static SceneNodeTransformPointer nbunny_scene_node_transform_create()
{
	return std::make_shared<nbunny::SceneNodeTransform>();
}

static int nbunny_scene_node_transform_get_parent(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	sol::stack::push(L, transform->parent);

	return 1;	
}

static int nbunny_scene_node_transform_get_current_rotation(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	lua_pushnumber(L, transform->currentRotation.x);
	lua_pushnumber(L, transform->currentRotation.y);
	lua_pushnumber(L, transform->currentRotation.z);
	lua_pushnumber(L, transform->currentRotation.w);
	return 4;
}

static int nbunny_scene_node_transform_set_current_rotation(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float w = (float)luaL_checknumber(L, 5);
	transform->currentRotation = glm::quat(w, x, y, z);
	return 0;
}

static int nbunny_scene_node_transform_get_current_scale(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	lua_pushnumber(L, transform->currentScale.x);
	lua_pushnumber(L, transform->currentScale.y);
	lua_pushnumber(L, transform->currentScale.z);
	return 3;
}

static int nbunny_scene_node_transform_set_current_scale(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->currentScale = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_scene_node_transform_get_current_offset(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	lua_pushnumber(L, transform->currentOffset.x);
	lua_pushnumber(L, transform->currentOffset.y);
	lua_pushnumber(L, transform->currentOffset.z);
	return 3;
}

static int nbunny_scene_node_transform_set_current_offset(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->currentOffset = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_scene_node_transform_get_current_translation(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	lua_pushnumber(L, transform->currentTranslation.x);
	lua_pushnumber(L, transform->currentTranslation.y);
	lua_pushnumber(L, transform->currentTranslation.z);
	return 3;
}

static int nbunny_scene_node_transform_set_current_translation(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->currentTranslation = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_scene_node_transform_get_previous_rotation(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	lua_pushnumber(L, transform->previousRotation.x);
	lua_pushnumber(L, transform->previousRotation.y);
	lua_pushnumber(L, transform->previousRotation.z);
	lua_pushnumber(L, transform->previousRotation.w);
	return 4;
}

static int nbunny_scene_node_transform_set_previous_rotation(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	float w = (float)luaL_checknumber(L, 5);
	transform->previousRotation = glm::quat(w, x, y, z);
	return 0;
}

static int nbunny_scene_node_transform_get_previous_scale(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	lua_pushnumber(L, transform->previousScale.x);
	lua_pushnumber(L, transform->previousScale.y);
	lua_pushnumber(L, transform->previousScale.z);
	return 3;
}

static int nbunny_scene_node_transform_set_previous_scale(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->previousScale = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_scene_node_transform_get_previous_translation(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	lua_pushnumber(L, transform->previousTranslation.x);
	lua_pushnumber(L, transform->previousTranslation.y);
	lua_pushnumber(L, transform->previousTranslation.z);
	return 3;
}

static int nbunny_scene_node_transform_set_previous_translation(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->previousTranslation = glm::vec3(x, y, z);
	return 0;
}
static int nbunny_scene_node_transform_get_previous_offset(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	lua_pushnumber(L, transform->previousOffset.x);
	lua_pushnumber(L, transform->previousOffset.y);
	lua_pushnumber(L, transform->previousOffset.z);
	return 3;
}

static int nbunny_scene_node_transform_set_previous_offset(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	float x = (float)luaL_checknumber(L, 2);
	float y = (float)luaL_checknumber(L, 3);
	float z = (float)luaL_checknumber(L, 4);
	transform->previousOffset = glm::vec3(x, y, z);
	return 0;
}

static int nbunny_scene_node_transform_get_global_delta_transform(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	float delta = (float)luaL_checknumber(L, 2);

	auto result = glm::transpose(transform->get_global(delta));
	auto pointer = glm::value_ptr(result);

	for (int i = 0; i < 16; ++i)
	{
		lua_pushnumber(L, pointer[i]);
	}

	return 16;
}

static int nbunny_scene_node_transform_get_local_delta_transform(lua_State* L)
{
	auto& transform = sol::stack::get<SceneNodeTransformPointer>(L, 1);
	float delta = (float)luaL_checknumber(L, 2);

	auto result = glm::transpose(transform->get_local(delta));
	auto pointer = glm::value_ptr(result);

	for (int i = 0; i < 16; ++i)
	{
		lua_pushnumber(L, pointer[i]);
	}

	return 16;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_scenenodetransform(lua_State* L)
{
	sol::usertype<nbunny::SceneNodeTransform> T(
		sol::call_constructor, sol::factories(&nbunny_scene_node_transform_create),
		"getParent", &nbunny_scene_node_transform_get_parent,
		"getCurrentRotation", &nbunny_scene_node_transform_get_current_rotation,
		"setCurrentRotation", &nbunny_scene_node_transform_set_current_rotation,
		"getCurrentScale", &nbunny_scene_node_transform_get_current_scale,
		"setCurrentScale", &nbunny_scene_node_transform_set_current_scale,
		"getCurrentTranslation", &nbunny_scene_node_transform_get_current_translation,
		"setCurrentTranslation", &nbunny_scene_node_transform_set_current_translation,
		"getCurrentOffset", &nbunny_scene_node_transform_get_current_offset,
		"setCurrentOffset", &nbunny_scene_node_transform_set_current_offset,
		"getPreviousRotation", &nbunny_scene_node_transform_get_previous_rotation,
		"setPreviousRotation", &nbunny_scene_node_transform_set_previous_rotation,
		"getPreviousScale", &nbunny_scene_node_transform_get_previous_scale,
		"setPreviousScale", &nbunny_scene_node_transform_set_previous_scale,
		"getPreviousTranslation", &nbunny_scene_node_transform_get_previous_translation,
		"setPreviousTranslation", &nbunny_scene_node_transform_set_previous_translation,
		"getPreviousOffset", &nbunny_scene_node_transform_get_previous_offset,
		"setPreviousOffset", &nbunny_scene_node_transform_set_previous_offset,
		"getGlobalDeltaTransform", &nbunny_scene_node_transform_get_global_delta_transform,
		"getLocalDeltaTransform", &nbunny_scene_node_transform_get_local_delta_transform,
		"tick", &nbunny::SceneNodeTransform::tick);

	sol::stack::push(L, T);

	return 1;
}

static int nbunny_scene_node_material_get_shader(const nbunny::SceneNodeMaterial& material)
{
	return material.shader;
}

static void nbunny_scene_node_material_set_shader(nbunny::SceneNodeMaterial& material, int shader)
{
	material.shader = shader;
}

static int nbunny_scene_node_material_set_textures(lua_State* L)
{
	auto& material = sol::stack::get<nbunny::SceneNodeMaterial>(L, 1);

	material.textures.clear();
	for (int i = 2; i <= lua_gettop(L); ++i)
	{
		material.textures.push_back(luaL_checkint(L, i));
	}

	std::sort(material.textures.begin(), material.textures.end());

	return 0;
}

static int nbunny_scene_node_material_get_textures(lua_State* L)
{
	auto& material = sol::stack::get<nbunny::SceneNodeMaterial>(L, 1);
	
	for (std::size_t i = 0; i < material.textures.size(); ++i)
	{
		lua_pushinteger(L, material.textures[i]);
	}

	return (int)material.textures.size();
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_scenenodematerial(lua_State* L)
{
	sol::usertype<nbunny::SceneNodeMaterial> T(
		"getShader", &nbunny_scene_node_material_get_shader,
		"setShader", &nbunny_scene_node_material_set_shader,
		"getTextures", &nbunny_scene_node_material_get_textures,
		"setTextures", &nbunny_scene_node_material_set_textures,
		"getMaterial", &nbunny_scene_node_material_set_textures);

	sol::stack::push(L, T);

	return 1;
}

static int nbunny_camera_set_view(lua_State* L)
{
	auto& camera = sol::stack::get<nbunny::Camera&>(L, 1);

	auto m = glm::value_ptr(camera.view);
	for (int i = 0; i < 16; ++i)
	{
		m[i] = (float)luaL_checknumber(L, i + 2);
	}

	camera.view = glm::transpose(camera.view);

	camera.is_dirty = true;

	return 0;
}

static int nbunny_camera_set_projection(lua_State* L)
{
	auto& camera = sol::stack::get<nbunny::Camera&>(L, 1);

	auto m = glm::value_ptr(camera.projection);
	for (int i = 0; i < 16; ++i)
	{
		m[i] = (float)luaL_checknumber(L, i + 2);
	}

	camera.projection = glm::transpose(camera.projection);

	camera.is_dirty = true;

	return 0;
}

static int nbunny_camera_enable_cull(lua_State* L)
{
	auto& camera = sol::stack::get<nbunny::Camera&>(L, 1);
	camera.enable_cull = true;

	return 0;
}

static int nbunny_camera_disable_cull(lua_State* L)
{
	auto& camera = sol::stack::get<nbunny::Camera&>(L, 1);
	camera.enable_cull = false;

	return 0;
}

static int nbunny_camera_get_cull_enabled(lua_State* L)
{
	auto& camera = sol::stack::get<nbunny::Camera&>(L, 1);
	lua_pushboolean(L, camera.enable_cull);

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_camera(lua_State* L)
{
	sol::usertype<nbunny::Camera> T(
		sol::call_constructor, sol::constructors<nbunny::Camera()>(),
		"enableCull", &nbunny_camera_enable_cull,
		"disableCull", &nbunny_camera_disable_cull,
		"getCullEnabled", &nbunny_camera_get_cull_enabled,
		"setView", &nbunny_camera_set_view,
		"setProjection", &nbunny_camera_set_projection);

	sol::stack::push(L, T);

	return 1;
}
