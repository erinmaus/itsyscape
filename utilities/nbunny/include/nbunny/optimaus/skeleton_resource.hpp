////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/skeleton_resource.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_SKELETON_RESOURCE_HPP
#define NBUNNY_OPTIMAUS_SKELETON_RESOURCE_HPP

#include <string>
#include <unordered_map>
#include <unordered_set>
#include "nbunny/skeleton.hpp"
#include "nbunny/optimaus/resource.hpp"

namespace nbunny
{
	class SkeletonResource : public Resource
	{
	public:
		std::shared_ptr<ResourceInstance> instantiate(lua_State* L) override;
	};

	struct SkeletonBone
	{
		enum
		{
			NO_PARENT = -1,
			NO_INDEX  = -1
		};

		int parent_index = NO_PARENT;
		std::string parent_name;

		std::string name;
		int index = NO_INDEX;

		glm::mat4 inverse_bind_pose = glm::mat4(1.0f);
	};

	class SkeletonTransforms;
	class SkeletonTransformsFilter;

	class SkeletonInstance : public ResourceInstance
	{
	private:
		std::vector<SkeletonBone> bones;
		std::unordered_map<std::string, int> bone_to_index;

    public:
		SkeletonInstance() = default;
		SkeletonInstance(int id, int reference);

		SkeletonBone add_bone(
			const std::string& name,
			const std::string& parent_name,
			const glm::mat4& inverse_bind_pose);

		SkeletonBone get_bone_by_index(int index) const;
		SkeletonBone get_bone_by_name(const std::string& name) const;
		int get_bone_index(const std::string& name);
		std::size_t get_num_bones() const;
		bool has_bone(const std::string& name);

		void apply_transforms(SkeletonTransforms& transforms) const;
		void apply_bind_pose(SkeletonTransforms& transforms) const;
	};

	class SkeletonAnimationResource : public Resource
	{
	public:
		std::shared_ptr<ResourceInstance> instantiate(lua_State* L) override;
	};

	class SkeletonAnimationInstance : public ResourceInstance
	{
	private:
		typedef std::vector<KeyFrame> BoneAnimation;
		float duration = 0.0f;

		std::unordered_map<int, BoneAnimation> bones;

	public:
		SkeletonAnimationInstance(int id, int reference);
		SkeletonAnimationInstance() = default;

		float get_duration() const;

		void set_key_frames(int bone, const std::vector<KeyFrame>& key_frames);

		void compute_local_transforms(float time, SkeletonTransforms& transforms) const;
		void compute_local_transforms(float time, SkeletonTransforms& transforms, SkeletonTransformsFilter& filter) const;
		void compute_local_transform(float time, int bone_index, SkeletonTransforms& transforms) const;
	};

	class SkeletonTransforms
	{
	private:
		std::vector<glm::mat4> transforms;
		std::shared_ptr<SkeletonInstance> skeleton;

	public:
		SkeletonTransforms(const std::shared_ptr<SkeletonInstance>& skeleton);
		~SkeletonTransforms() = default;

		const std::shared_ptr<SkeletonInstance>& get_skeleton() const;

		void apply_transform(int index, const glm::mat4& value);
		void set_transform(int index, const glm::mat4& value);
		void set_identity(int index);

		const glm::mat4& get_transform(int index) const;
		const std::vector<glm::mat4>& get_transforms() const;

		void reset();

		void copy(SkeletonTransforms& other) const;
	};

	class SkeletonTransformsFilter
	{
	private:
		std::unordered_set<int> enabled_bones;
		std::shared_ptr<SkeletonInstance> skeleton;

	public:
		SkeletonTransformsFilter(const std::shared_ptr<SkeletonInstance>& skeleton);
		~SkeletonTransformsFilter() = default;

		void enable_all_bones();
		void disable_all_bones();
		void enable_bone_at_index(int index);
		void disable_bone_at_index(int index);
		bool is_enabled(int index) const;
		bool is_disabled(int index) const;
	};
}

#endif
