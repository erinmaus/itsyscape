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
#include "nbunny/lua_runtime.hpp"
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/skeleton_resource.hpp"

std::shared_ptr<nbunny::ResourceInstance> nbunny::SkeletonResource::instantiate(lua_State *L)
{
	return std::make_shared<nbunny::SkeletonInstance>(allocate_id(), set_weak_reference(L));
}

static int nbunny_skeleton_resource_constructor(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::SkeletonResource>());
	return 1;
}

static int nbunny_skeleton_resource_instantiate(lua_State* L)
{
	auto resource = nbunny::lua::get<nbunny::SkeletonResource*>(L, 1);
	lua_pushvalue(L, 2);
	auto instance = resource->instantiate(L);
	nbunny::lua::push(L, std::reinterpret_pointer_cast<nbunny::SkeletonInstance>(instance));
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_skeletonresource(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "instantiate", &nbunny_skeleton_resource_instantiate },
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_child_type<nbunny::SkeletonResource, nbunny::Resource>(L, &nbunny_skeleton_resource_constructor, metatable);

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

void nbunny::SkeletonInstance::apply_transforms(SkeletonTransforms& transforms) const
{
	for (auto& bone: bones)
	{
		auto parent_index = bone.parent_index;
		if (parent_index == SkeletonBone::NO_PARENT)
		{
			continue;
		}

		auto parent_transform = transforms.get_transform(parent_index);
		auto bone_transform = transforms.get_transform(bone.index);
		transforms.set_transform(bone.index, parent_transform * bone_transform);
	}
}

void nbunny::SkeletonInstance::apply_bind_pose(SkeletonTransforms& transforms) const
{
	for (auto& bone: bones)
	{
		transforms.apply_transform(bone.index, bone.inverse_bind_pose);
	}
}

static int nbunny_skeleton_bone_constructor(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::SkeletonBone>());
	return 1;
}

static int nbunny_skeleton_bone_get_name(lua_State* L)
{
	auto bone = nbunny::lua::get<nbunny::SkeletonBone*>(L, 1);
	lua_pushlstring(L, bone->name.data(), bone->name.size());
	return 1;
}

static int nbunny_skeleton_bone_get_index(lua_State* L)
{
	auto bone = nbunny::lua::get<nbunny::SkeletonBone*>(L, 1);
	lua_pushinteger(L, bone->index);
	return 1;
}

static int nbunny_skeleton_bone_get_parent_name(lua_State* L)
{
	auto bone = nbunny::lua::get<nbunny::SkeletonBone*>(L, 1);
	lua_pushlstring(L, bone->parent_name.data(), bone->parent_name.size());
	return 1;
}

static int nbunny_skeleton_bone_get_parent_index(lua_State* L)
{
	auto bone = nbunny::lua::get<nbunny::SkeletonBone*>(L, 1);
	lua_pushinteger(L, bone->parent_index);
	return 1;
}

static int nbunny_skeleton_bone_get_inverse_bind_pose(lua_State* L)
{
	auto bone = nbunny::lua::get<nbunny::SkeletonBone*>(L, 1);
	auto pointer = glm::value_ptr(bone->inverse_bind_pose);
	auto transform = love::math::Math::instance.newTransform();
	transform->setMatrix(love::Matrix4(pointer));
	love::luax_pushtype(L, transform);
	transform->release();
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_skeletonbone(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "getName", &nbunny_skeleton_bone_get_name },
		{ "getIndex", &nbunny_skeleton_bone_get_index },
		{ "getParentName", &nbunny_skeleton_bone_get_parent_name },
		{ "getParentIndex", &nbunny_skeleton_bone_get_parent_index },
		{ "getInverseBindPose", &nbunny_skeleton_bone_get_inverse_bind_pose },
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_type<nbunny::SkeletonBone>(L, &nbunny_skeleton_bone_constructor, metatable);

	return 1;
}

static int nbunny_skeleton_instance_add_bone(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonInstance*>(L, 1);
	auto transform = love::luax_checktype<love::math::Transform>(L, 4, love::math::Transform::type);
	auto inverse_bind_pose = glm::make_mat4(transform->getMatrix().getElements());
	auto bone = skeleton->add_bone(luaL_checkstring(L, 2), luaL_optstring(L, 3, ""), inverse_bind_pose);
	nbunny::lua::push(L, std::make_shared<nbunny::SkeletonBone>(bone));
	return 1;
}

static int nbunny_skeleton_instance_get_bone_by_name(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonInstance*>(L, 1);
	auto name = nbunny::lua::get<std::string>(L, 2);
	auto bone = skeleton->get_bone_by_name(name);
	nbunny::lua::push(L, std::make_shared<nbunny::SkeletonBone>(bone));
	return 1;
}

static int nbunny_skeleton_instance_get_bone_by_index(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonInstance*>(L, 1);
	auto index = nbunny::lua::get<int>(L, 2);
	auto bone = skeleton->get_bone_by_index(index);
	nbunny::lua::push(L, std::make_shared<nbunny::SkeletonBone>(bone));
	return 1;
}

static int nbunny_skeleton_instance_get_bone_index(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonInstance*>(L, 1);
	auto name = nbunny::lua::get<std::string>(L, 2);
	nbunny::lua::push(L, skeleton->get_bone_index(name));
	return 1;
}

static int nbunny_skeleton_instance_has_bone(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonInstance*>(L, 1);
	auto name = nbunny::lua::get<std::string>(L, 2);
	nbunny::lua::push(L, skeleton->has_bone(name));
	return 1;
}

static int nbunny_skeleton_instance_get_num_bones(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonInstance*>(L, 1);
	nbunny::lua::push(L, skeleton->get_num_bones());
	return 1;
}

static int nbunny_skeleton_instance_apply_transforms(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonInstance*>(L, 1);
	auto transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 2);
	skeleton->apply_transforms(*transforms);
	return 0;
}

static int nbunny_skeleton_instance_apply_bind_pose(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonInstance*>(L, 1);
	auto transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 2);
	skeleton->apply_bind_pose(*transforms);
	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_skeletonresourceinstance(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "addBone", &nbunny_skeleton_instance_add_bone },
		{ "getBoneByName", &nbunny_skeleton_instance_get_bone_by_name },
		{ "getBoneByIndex", &nbunny_skeleton_instance_get_bone_by_index },
		{ "getBoneIndex", &nbunny_skeleton_instance_get_bone_index },
		{ "getNumBones", &nbunny_skeleton_instance_get_num_bones },
		{ "hasBone", &nbunny_skeleton_instance_has_bone },
		{ "applyTransforms", &nbunny_skeleton_instance_apply_transforms },
		{ "applyBindPose", &nbunny_skeleton_instance_apply_bind_pose },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_child_type<nbunny::SkeletonInstance, nbunny::ResourceInstance>(L, &nbunny_resource_constructor<nbunny::SkeletonInstance>, metatable);

	return 1;
}

std::shared_ptr<nbunny::ResourceInstance> nbunny::SkeletonAnimationResource::instantiate(lua_State *L)
{
	return std::make_shared<nbunny::SkeletonAnimationInstance>(allocate_id(), set_weak_reference(L));
}

static int nbunny_skeleton_animation_resource_constructor(lua_State* L)
{
	nbunny::lua::push(L, std::make_shared<nbunny::SkeletonAnimationResource>());
	return 1;
}

static int nbunny_skeleton_animation_resource_instantiate(lua_State* L)
{
	auto resource = nbunny::lua::get<nbunny::SkeletonAnimationResource*>(L, 1);
	lua_pushvalue(L, 2);
	auto instance = resource->instantiate(L);
	nbunny::lua::push(L, std::reinterpret_pointer_cast<nbunny::SkeletonAnimationInstance>(instance));
	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_skeletonanimationresource(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "instantiate", &nbunny_skeleton_animation_resource_instantiate },
		{ nullptr, nullptr }
	};
	
	nbunny::lua::register_child_type<nbunny::SkeletonAnimationResource, nbunny::Resource>(L, &nbunny_skeleton_animation_resource_constructor, metatable);

	return 1;
}

nbunny::SkeletonAnimationInstance::SkeletonAnimationInstance(int id, int reference) :
	ResourceInstance(id, reference)
{
	// Nothing.
}

float nbunny::SkeletonAnimationInstance::get_duration() const
{
	return duration;
}

void nbunny::SkeletonAnimationInstance::set_key_frames(int bone, const std::vector<KeyFrame>& key_frames)
{
	auto i = bones.find(bone);
	if (i != bones.end())
	{
		i->second = key_frames;
	}
	else
	{
		bones.emplace(bone, key_frames);
	}

	duration = std::max(key_frames.back().time, duration);
}

void nbunny::SkeletonAnimationInstance::compute_local_transforms(float time, SkeletonTransforms& transforms) const
{
	for (auto& i: bones)
	{
		compute_local_transform(time, i.first, transforms);
	}
}

void nbunny::SkeletonAnimationInstance::compute_local_transforms(
	float time,
	SkeletonTransforms& transforms,
	SkeletonTransformsFilter& filter) const
{
	for (auto& i: bones)
	{
		if (filter.is_enabled(i.first))
		{
			compute_local_transform(time, i.first, transforms);
		}
	}
}

void nbunny::SkeletonAnimationInstance::compute_local_transform(
	float time,
	int bone_index,
	SkeletonTransforms& transforms) const
{
	auto wrapped_time = time > duration ? std::fmod(time, duration) : time;

	auto& key_frames = bones.at(bone_index);

	std::size_t current_index = 0;
	for (std::size_t i = 0; i < key_frames.size(); ++i)
	{
		if (wrapped_time > key_frames[i].time)
		{
			current_index = i;
		}
		else
		{
			break;
		}
	}

	std::size_t next_index = (current_index + 1) % key_frames.size();

	auto& current_frame = key_frames[current_index];
	auto& next_frame = key_frames[next_index];

	auto transform = KeyFrame::interpolate(current_frame, next_frame, wrapped_time);
	transforms.set_transform(bone_index, transform);
}

static int nbunny_skeleton_animation_instance_set_key_frames(lua_State* L)
{
	auto animation = nbunny::lua::get<nbunny::SkeletonAnimationInstance*>(L, 1);
	int bone = luaL_checkinteger(L, 2);

	std::vector<nbunny::KeyFrame> key_frames;
	std::size_t length = lua_objlen(L, 3);
	for (std::size_t i = 1; i <= length; ++i)
	{
		lua_rawgeti(L, 3, i);
		key_frames.push_back(*nbunny::lua::get<nbunny::KeyFrame*>(L, -1));
		lua_pop(L, 1);
	}

	animation->set_key_frames(bone, key_frames);

	return 0;
}

static int nbunny_skeleton_animation_instance_get_duration(lua_State* L)
{
	auto animation = nbunny::lua::get<nbunny::SkeletonAnimationInstance*>(L, 1);
	lua_pushnumber(L, animation->get_duration());
	return 1;
}

static int nbunny_skeleton_animation_instance_compute_local_transforms(lua_State* L)
{
	auto animation = nbunny::lua::get<nbunny::SkeletonAnimationInstance*>(L, 1);
	auto delta = nbunny::lua::get<float>(L, 2);
	auto transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 3);
	if (nbunny::lua::is_userdata<nbunny::SkeletonTransformsFilter>(L, 4))
	{
		auto filter = nbunny::lua::get<nbunny::SkeletonTransformsFilter*>(L, 4);
		animation->compute_local_transforms(delta, *transforms, *filter);
	}
	else
	{
		animation->compute_local_transforms(delta, *transforms);
	}

	return 0;
}

static int nbunny_skeleton_animation_instance_compute_local_transform(lua_State* L)
{
	auto animation = nbunny::lua::get<nbunny::SkeletonAnimationInstance*>(L, 1);
	auto delta = nbunny::lua::get<float>(L, 2);
	auto bone_index = nbunny::lua::get<int>(L, 3);
	auto transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 4);
	animation->compute_local_transform(delta, bone_index, *transforms);
	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_skeletonanimationresourceinstance(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "setKeyFrames", &nbunny_skeleton_animation_instance_set_key_frames },
		{ "computeLocalTransforms", &nbunny_skeleton_animation_instance_compute_local_transforms },
		{ "computeLocalTransform", &nbunny_skeleton_animation_instance_compute_local_transform },
		{ "getDuration", &nbunny_skeleton_animation_instance_get_duration },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_child_type<nbunny::SkeletonAnimationInstance, nbunny::ResourceInstance>(L, &nbunny_resource_constructor<nbunny::SkeletonAnimationInstance>, metatable);

	return 1;
}

nbunny::SkeletonTransforms::SkeletonTransforms(const std::shared_ptr<SkeletonInstance>& skeleton) :
	skeleton(skeleton)
{
	transforms.resize(skeleton->get_num_bones(), glm::mat4(1.0f));
}

const std::shared_ptr<nbunny::SkeletonInstance>& nbunny::SkeletonTransforms::get_skeleton() const
{
	return skeleton;
}

void nbunny::SkeletonTransforms::apply_transform(int index, const glm::mat4& value)
{
	transforms.at(index) *= value;
}

void nbunny::SkeletonTransforms::set_transform(int index, const glm::mat4& value)
{
	transforms.at(index) = value;
}

void nbunny::SkeletonTransforms::set_identity(int index)
{
	transforms.at(index) = glm::mat4(1.0f);
}

const glm::mat4& nbunny::SkeletonTransforms::get_transform(int index) const
{
	return transforms.at(index);
}

const std::vector<glm::mat4>& nbunny::SkeletonTransforms::get_transforms() const
{
	return transforms;
}

void nbunny::SkeletonTransforms::reset()
{
	for (std::size_t i = 0; i < transforms.size(); ++i)
	{
		transforms[i] = glm::mat4(1.0f);
	}
}

void nbunny::SkeletonTransforms::copy(SkeletonTransforms& other) const
{
	other.transforms = transforms;
}

static int nbunny_skeleton_transforms_constructor(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonInstance>(L, 2);
	nbunny::lua::push(L, std::make_shared<nbunny::SkeletonTransforms>(skeleton));
	return 1;
}

static int nbunny_skeleton_transforms_apply_transform(lua_State* L)
{
	auto transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 1);
	int bone_index = luaL_checkinteger(L, 2);
	auto transform = love::luax_checktype<love::math::Transform>(L, 3);
	auto matrix = glm::make_mat4(transform->getMatrix().getElements());
	transforms->apply_transform(bone_index, matrix);
	return 0;
}

static int nbunny_skeleton_transforms_set_transform(lua_State* L)
{
	auto transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 1);
	int bone_index = luaL_checkinteger(L, 2);
	auto transform = love::luax_checktype<love::math::Transform>(L, 3);
	auto matrix = glm::make_mat4(transform->getMatrix().getElements());
	transforms->set_transform(bone_index, matrix);
	return 0;
}

static int nbunny_skeleton_transforms_set_identity(lua_State* L)
{
	auto transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 1);
	int bone_index = luaL_checkinteger(L, 2);
	transforms->set_identity(bone_index);
	return 0;
}

static int nbunny_skeleton_transforms_get_transform(lua_State* L)
{
	auto transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 1);
	int bone_index = luaL_checkinteger(L, 2);
	auto matrix = transforms->get_transform(bone_index);
	auto transform = love::math::Math::instance.newTransform();
	transform->setMatrix(love::Matrix4(glm::value_ptr(matrix)));
	love::luax_pushtype(L, transform);
	transform->release();
	return 1;
}

static int nbunny_skeleton_transforms_get_transforms(lua_State* L)
{
	auto transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 1);
	auto skeleton = transforms->get_skeleton();

	lua_createtable(L, (int)skeleton->get_num_bones(), 0);
	for (std::size_t i = 0; i < skeleton->get_num_bones(); ++i)
	{
		auto matrix = transforms->get_transform(i);
		auto transform = love::math::Math::instance.newTransform();
		transform->setMatrix(love::Matrix4(glm::value_ptr(matrix)));
		love::luax_pushtype(L, transform);
		lua_rawseti(L, -2, i + 1);
		transform->release();
	}

	return 1;
}

static int nbunny_skeleton_transforms_reset(lua_State* L)
{
	auto transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 1);
	transforms->reset();
	return 0;
}

static int nbunny_skeleton_transforms_copy(lua_State* L)
{
	auto transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 1);
	auto other_transforms = nbunny::lua::get<nbunny::SkeletonTransforms*>(L, 2);
	transforms->copy(*other_transforms);
	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_skeletontransforms(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "applyTransform", &nbunny_skeleton_transforms_apply_transform },
		{ "setTransform", &nbunny_skeleton_transforms_set_transform },
		{ "setIdentity", &nbunny_skeleton_transforms_set_identity },
		{ "getTransform", &nbunny_skeleton_transforms_get_transform },
		{ "getTransforms", &nbunny_skeleton_transforms_get_transforms },
		{ "reset", &nbunny_skeleton_transforms_reset },
		{ "copy", &nbunny_skeleton_transforms_copy },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_type<nbunny::SkeletonTransforms>(L, &nbunny_skeleton_transforms_constructor, metatable);

	return 1;
}

nbunny::SkeletonTransformsFilter::SkeletonTransformsFilter(const std::shared_ptr<SkeletonInstance>& skeleton) :
	skeleton(skeleton)
{
	// Nothing.
}

void nbunny::SkeletonTransformsFilter::enable_all_bones()
{
	for (std::size_t i = 0; i < skeleton->get_num_bones(); ++i)
	{
		enabled_bones.emplace((int)i);
	}
}

void nbunny::SkeletonTransformsFilter::enable_bone_at_index(int index)
{
	enabled_bones.emplace(index);
}

void nbunny::SkeletonTransformsFilter::disable_all_bones()
{
	enabled_bones.clear();
}

void nbunny::SkeletonTransformsFilter::disable_bone_at_index(int index)
{
	enabled_bones.erase(index);
}

bool nbunny::SkeletonTransformsFilter::is_enabled(int index) const
{
	return enabled_bones.count(index) == 1;
}

bool nbunny::SkeletonTransformsFilter::is_disabled(int index) const
{
	return enabled_bones.count(index) == 0;
}

int nbunny_skeleton_transforms_filter_constructor(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonInstance>(L, 2);
	nbunny::lua::push(L, std::make_shared<nbunny::SkeletonTransformsFilter>(skeleton));
	return 1;
}

int nbunny_skeleton_transforms_filter_enable_all_bones(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonTransformsFilter*>(L, 1);
	skeleton->enable_all_bones();
	return 0;
}

int nbunny_skeleton_transforms_filter_enable_bone_at_index(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonTransformsFilter*>(L, 1);
	auto bone_index = nbunny::lua::get<int>(L, 2);
	skeleton->enable_bone_at_index(bone_index);
	return 0;
}

int nbunny_skeleton_transforms_filter_disable_all_bones(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonTransformsFilter*>(L, 1);
	skeleton->disable_all_bones();
	return 0;
}

int nbunny_skeleton_transforms_filter_disable_bone_at_index(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonTransformsFilter*>(L, 1);
	auto bone_index = nbunny::lua::get<int>(L, 2);
	skeleton->disable_bone_at_index(bone_index);
	return 0;
}

int nbunny_skeleton_transforms_filter_is_enabled(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonTransformsFilter*>(L, 1);
	auto bone_index = nbunny::lua::get<int>(L, 2);
	nbunny::lua::push(L, skeleton->is_enabled(bone_index));
	return 0;
}

int nbunny_skeleton_transforms_filter_is_disabled(lua_State* L)
{
	auto skeleton = nbunny::lua::get<nbunny::SkeletonTransformsFilter*>(L, 1);
	auto bone_index = nbunny::lua::get<int>(L, 2);
	nbunny::lua::push(L, skeleton->is_disabled(bone_index));
	return 0;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_skeletontransformsfilter(lua_State* L)
{
	static const luaL_Reg metatable[] = {
		{ "enableAllBones", &nbunny_skeleton_transforms_filter_enable_all_bones },
		{ "disableAllBones", &nbunny_skeleton_transforms_filter_disable_all_bones },
		{ "enableBoneAtIndex", &nbunny_skeleton_transforms_filter_enable_bone_at_index },
		{ "disableBoneAtIndex", &nbunny_skeleton_transforms_filter_disable_bone_at_index },
		{ "isEnabled", &nbunny_skeleton_transforms_filter_is_enabled },
		{ "isDisabled", &nbunny_skeleton_transforms_filter_is_disabled },
		{ nullptr, nullptr }
	};

	nbunny::lua::register_type<nbunny::SkeletonTransformsFilter>(L, &nbunny_skeleton_transforms_filter_constructor, metatable);

	return 1;
}
