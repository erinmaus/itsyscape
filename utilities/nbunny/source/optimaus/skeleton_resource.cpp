////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/skeleton_resource.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include "common/Exception.h"
#include "common/runtime.h"
#include "modules/math/Transform.h"
#include "modules/math/MathModule.h"
#include "nbunny/nbunny.hpp"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/skeleton_resource.hpp"

std::shared_ptr<nbunny::ResourceInstance> nbunny::SkeletonResource::instantiate(lua_State *L)
{
	return std::make_shared<nbunny::SkeletonInstance>(allocate_id(), set_weak_reference(L));
}

static int nbunny_skeleton_resource_instantiate(lua_State* L)
{
	auto& resource = sol::stack::get<nbunny::SkeletonResource&>(L, 1);
	lua_pushvalue(L, 2);
	auto instance = resource.instantiate(L);
	sol::stack::push(L, std::reinterpret_pointer_cast<nbunny::SkeletonInstance>(instance));
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_skeletonresource(lua_State* L)
{
	sol::usertype<nbunny::SkeletonResource> T(
		sol::base_classes, sol::bases<nbunny::Resource>(),
		sol::call_constructor, sol::constructors<nbunny::SkeletonResource()>(),
		"instantiate", &nbunny_skeleton_resource_instantiate);

	sol::stack::push(L, T);

	return 1;
}

nbunny::SkeletonInstance::SkeletonInstance(int id, int reference) :
	ResourceInstance(id, reference)
{
	// Nothing.
}

nbunny::SkeletonBone nbunny::SkeletonInstance::add_bone(
	const std::string& name,
	const std::string& parent_name,
	const glm::mat4& inverse_bind_pose)
{
	if (has_bone(name))
	{
		throw love::Exception("already has bone '%s'", name.c_str());
	}

	if (parent_name != "" && !has_bone(parent_name))
	{
		throw love::Exception("does not have parent bone '%s'", parent_name.c_str());
	}

	SkeletonBone bone;
	bone.parent_index = has_bone(parent_name) ? get_bone_index(parent_name) : SkeletonBone::NO_PARENT;
	bone.parent_name = parent_name;
	bone.name = name;
	bone.index = (int)bones.size();
	bone.inverse_bind_pose = inverse_bind_pose;

	bone_to_index.emplace(name, (int)bones.size());
	bones.push_back(bone);

	return bone;
}

nbunny::SkeletonBone nbunny::SkeletonInstance::get_bone_by_index(int index) const
{
	return bones.at((int)index);
}

nbunny::SkeletonBone nbunny::SkeletonInstance::get_bone_by_name(const std::string& name) const
{
	return bones.at(bone_to_index.at(name));
}

int nbunny::SkeletonInstance::get_bone_index(const std::string& name)
{
	return bone_to_index.at(name);
}

std::size_t nbunny::SkeletonInstance::get_num_bones() const
{
	return bones.size();
}

bool nbunny::SkeletonInstance::has_bone(const std::string& name)
{
	return bone_to_index.find(name) != bone_to_index.end();
}

static int nbunny_skeleton_bone_get_name(lua_State* L)
{
	auto& bone = sol::stack::get<nbunny::SkeletonBone&>(L, 1);
	lua_pushlstring(L, bone.name.data(), bone.name.size());
	return 1;
}

static int nbunny_skeleton_bone_get_index(lua_State* L)
{
	auto& bone = sol::stack::get<nbunny::SkeletonBone&>(L, 1);
	lua_pushinteger(L, bone.index);
	return 1;
}

static int nbunny_skeleton_bone_get_parent_name(lua_State* L)
{
	auto& bone = sol::stack::get<nbunny::SkeletonBone&>(L, 1);
	lua_pushlstring(L, bone.parent_name.data(), bone.parent_name.size());
	return 1;
}

static int nbunny_skeleton_bone_get_parent_index(lua_State* L)
{
	auto& bone = sol::stack::get<nbunny::SkeletonBone&>(L, 1);
	lua_pushinteger(L, bone.parent_index);
	return 1;
}

static int nbunny_skeleton_bone_get_inverse_bind_pose(lua_State* L)
{
	auto& bone = sol::stack::get<nbunny::SkeletonBone&>(L, 1);
	auto pointer = glm::value_ptr(bone.inverse_bind_pose);
	auto transform = love::math::Math::instance.newTransform();
	transform->setMatrix(love::Matrix4(pointer));
	love::luax_pushtype(L, transform);
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_skeletonbone(lua_State* L)
{
	sol::usertype<nbunny::SkeletonBone> T(
		"getName", &nbunny_skeleton_bone_get_name,
		"getIndex", &nbunny_skeleton_bone_get_index,
		"getParentName", &nbunny_skeleton_bone_get_parent_name,
		"getParentIndex", &nbunny_skeleton_bone_get_parent_index,
		"getInverseBindPose", &nbunny_skeleton_bone_get_inverse_bind_pose);

	sol::stack::push(L, T);

	return 1;
}

static int nbunny_skeleton_instance_add_bone(lua_State* L)
{
	auto& skeleton = sol::stack::get<nbunny::SkeletonInstance&>(L, 1);
	auto transform = love::luax_checktype<love::math::Transform>(L, 4, love::math::Transform::type);
	auto inverse_bind_pose = glm::make_mat4(transform->getMatrix().getElements());
	auto bone = skeleton.add_bone(luaL_checkstring(L, 2), luaL_optstring(L, 3, ""), inverse_bind_pose);
	sol::stack::push(L, bone);
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_skeletonresourceinstance(lua_State* L)
{
	sol::usertype<nbunny::SkeletonInstance> T(
		sol::base_classes, sol::bases<nbunny::ResourceInstance>(),
		sol::call_constructor, sol::constructors<nbunny::SkeletonInstance()>(),
		"addBone", &nbunny_skeleton_instance_add_bone,
		"getBoneByName", &nbunny::SkeletonInstance::get_bone_by_name,
		"getBoneByIndex", &nbunny::SkeletonInstance::get_bone_by_index,
		"getBoneIndex", &nbunny::SkeletonInstance::get_bone_index,
		"getNumBones", &nbunny::SkeletonInstance::get_num_bones,
		"hasBone", &nbunny::SkeletonInstance::has_bone);

	sol::stack::push(L, T);

	return 1;
}
